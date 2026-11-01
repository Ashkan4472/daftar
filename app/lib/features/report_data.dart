import 'package:core/core.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../repo.dart';
import '../state.dart';

/// My share of a transaction: the amount minus what people owe me for it.
const effSql = 'transactions.amount + COALESCE((SELECT SUM(share) FROM splits s WHERE s.transaction_id = transactions.id), 0)';

/// A report period: one Jalali month, or an arbitrary [from, to) range.
class Period {
  const Period.month(int this.ym)
      : from = null,
        to = null;
  const Period.range(DateTime this.from, DateTime this.to) : ym = null;
  final int? ym;
  final DateTime? from, to;

  String get where => ym != null ? 'transactions.jalali_ym = ?' : 'transactions.occurred_at >= ? AND transactions.occurred_at < ?';
  List<Variable> get vars =>
      ym != null ? [Variable.withInt(ym!)] : [Variable.withDateTime(from!), Variable.withDateTime(to!)];

  TxFilter filter() => ym != null ? TxFilter(ym: ym) : TxFilter(from: from, to: to);

  @override
  bool operator ==(Object other) => other is Period && other.ym == ym && other.from == from && other.to == to;
  @override
  int get hashCode => Object.hash(ym, from, to);
}

class Totals {
  const Totals(this.income, this.expense, this.count);
  final int income, expense, count;
  int get net => income + expense;
}

enum GroupBy { category, tag, account }

class Slice {
  const Slice({required this.key, required this.total, required this.count});
  final int? key; // category/tag/account id; null = uncategorized
  final int total; // positive magnitude
  final int count;
}

const _base = "transactions.deleted_at IS NULL AND NOT transactions.excluded AND transactions.kind != 'transfer'";

final periodTotalsProvider = StreamProvider.family<Totals, Period>((ref, p) {
  final db = ref.watch(dbProvider);
  return db.customSelect('''
    SELECT COALESCE(SUM(CASE WHEN kind = 'income' THEN $effSql END), 0) AS income,
           COALESCE(SUM(CASE WHEN kind = 'expense' THEN $effSql END), 0) AS expense,
           COUNT(*) AS n
    FROM transactions WHERE $_base AND ${p.where}
  ''', variables: p.vars, readsFrom: {db.transactions, db.splits}).watchSingle().map(
        (r) => Totals(r.read<int>('income'), r.read<int>('expense'), r.read<int>('n')));
});

typedef SliceKey = (Period, GroupBy, bool /* expense? */);

/// Totals grouped by category (rolled up to top level), tag or account.
final slicesProvider = StreamProvider.family<List<Slice>, SliceKey>((ref, k) {
  final db = ref.watch(dbProvider);
  final (p, g, expense) = k;
  final kind = expense ? 'expense' : 'income';
  final sign = expense ? -1 : 1;
  final (join, key) = switch (g) {
    GroupBy.category => ('LEFT JOIN categories c ON c.id = transactions.category_id', 'COALESCE(c.parent_id, c.id)'),
    GroupBy.tag => ('LEFT JOIN transaction_tags tt ON tt.transaction_id = transactions.id', 'tt.tag_id'),
    GroupBy.account => ('', 'transactions.account_id'),
  };
  return db.customSelect('''
    SELECT $key AS k, SUM($sign * ($effSql)) AS total, COUNT(*) AS n
    FROM transactions $join
    WHERE $_base AND transactions.kind = '$kind' AND ${p.where}
    GROUP BY k HAVING total > 0 ORDER BY total DESC
  ''', variables: p.vars, readsFrom: {db.transactions, db.categories, db.transactionTags, db.splits}).watch().map(
        (rows) => [for (final r in rows) Slice(key: r.read<int?>('k'), total: r.read<int>('total'), count: r.read<int>('n'))],
      );
});

class MonthBar {
  const MonthBar(this.ym, this.income, this.expense);
  final int ym, income, expense; // expense is positive
}

/// Last [n] months ending at [endYm], zero-filled.
final trendProvider = StreamProvider.family<List<MonthBar>, int>((ref, endYm) {
  final db = ref.watch(dbProvider);
  var start = endYm;
  for (var i = 1; i < 12; i++) {
    start = prevYm(start);
  }
  return db.customSelect('''
    SELECT jalali_ym AS ym,
           COALESCE(SUM(CASE WHEN kind = 'income' THEN $effSql END), 0) AS income,
           COALESCE(SUM(CASE WHEN kind = 'expense' THEN -($effSql) END), 0) AS expense
    FROM transactions WHERE $_base AND jalali_ym BETWEEN ? AND ?
    GROUP BY jalali_ym
  ''', variables: [Variable.withInt(start), Variable.withInt(endYm)], readsFrom: {db.transactions, db.splits}).watch().map((rows) {
    final by = {for (final r in rows) r.read<int>('ym'): MonthBar(r.read<int>('ym'), r.read<int>('income'), r.read<int>('expense'))};
    final out = <MonthBar>[];
    for (var ym = start; ym <= endYm; ym = nextYm(ym)) {
      out.add(by[ym] ?? MonthBar(ym, 0, 0));
    }
    return out;
  });
});

// ---- budgets ------------------------------------------------------------------------

class BudgetStatus {
  const BudgetStatus(this.budget, this.category, this.spent);
  final Budget budget;
  final Category category;
  final int spent; // positive
  double get ratio => budget.monthlyLimit == 0 ? 0 : spent / budget.monthlyLimit;
}

Selectable<QueryRow> _budgetRows(AppDb db, int ym) => db.customSelect('''
    SELECT b.id AS id,
      (SELECT COALESCE(SUM(-($effSql)), 0) FROM transactions
        WHERE $_base AND transactions.kind = 'expense' AND transactions.jalali_ym = ?1
          AND (transactions.category_id = b.category_id
               OR transactions.category_id IN (SELECT id FROM categories WHERE parent_id = b.category_id))) AS spent
    FROM budgets b WHERE b.from_ym <= ?1 AND (b.to_ym IS NULL OR b.to_ym >= ?1)
  ''', variables: [Variable.withInt(ym)], readsFrom: {db.budgets, db.transactions, db.categories, db.splits});

Future<List<BudgetStatus>> _budgetStatuses(AppDb db, List<QueryRow> rows) async {
  final budgets = {for (final b in await db.select(db.budgets).get()) b.id: b};
  final cats = {for (final c in await db.select(db.categories).get()) c.id: c};
  return [
    for (final r in rows)
      if (budgets[r.read<int>('id')] case final b? when cats[b.categoryId] != null)
        BudgetStatus(b, cats[b.categoryId]!, r.read<int>('spent')),
  ]..sort((a, b) => b.ratio.compareTo(a.ratio));
}

Future<List<BudgetStatus>> loadBudgets(AppDb db, int ym) async => _budgetStatuses(db, await _budgetRows(db, ym).get());

final budgetsProvider = StreamProvider.family<List<BudgetStatus>, int>((ref, ym) {
  final db = ref.watch(dbProvider);
  return _budgetRows(db, ym).watch().asyncMap((rows) => _budgetStatuses(db, rows));
});

// ---- leaks --------------------------------------------------------------------------

class Spike {
  const Spike(this.categoryId, this.now, this.avg);
  final int categoryId, now, avg;
  int get pct => ((now - avg) * 100 / avg).round();
}

class Leaks {
  const Leaks({required this.spikes, required this.smallCount, required this.smallTotal, required this.uncatCount, required this.uncatTotal, required this.gapCount, required this.gapTotal, required this.recurringCount});
  final List<Spike> spikes;
  final int smallCount, smallTotal, uncatCount, uncatTotal, gapCount, gapTotal, recurringCount;
  bool get isEmpty => spikes.isEmpty && smallCount < 10 && uncatCount == 0 && gapCount == 0 && recurringCount == 0;
}

/// [smallLimit] in Rial: purchases below it count as "small".
typedef LeakKey = (int, int);

Future<Leaks> computeLeaks(AppDb db, int ym, int smallLimit) async {
  var prev3 = ym;
  for (var i = 0; i < 3; i++) {
    prev3 = prevYm(prev3);
  }
  final cat = await db.customSelect('''
    SELECT COALESCE(c.parent_id, c.id) AS k, transactions.jalali_ym AS ym, SUM(-($effSql)) AS total
    FROM transactions JOIN categories c ON c.id = transactions.category_id
    WHERE $_base AND transactions.kind = 'expense' AND transactions.jalali_ym BETWEEN ? AND ?
    GROUP BY k, ym
  ''', variables: [Variable.withInt(prev3), Variable.withInt(ym)]).get();
  final now = <int, int>{}, past = <int, int>{};
  for (final r in cat) {
    (r.read<int>('ym') == ym ? now : past).update(r.read<int>('k'), (v) => v + r.read<int>('total'), ifAbsent: () => r.read<int>('total'));
  }
  final spikes = <Spike>[
    for (final e in now.entries)
      if ((past[e.key] ?? 0) > 0 && e.value > (past[e.key]! / 3) * 1.5 && e.value - past[e.key]! / 3 > smallLimit)
        Spike(e.key, e.value, (past[e.key]! / 3).round()),
  ]..sort((a, b) => (b.now - b.avg).compareTo(a.now - a.avg));

  final small = await db.customSelect('''
    SELECT COUNT(*) AS n, COALESCE(SUM(-($effSql)), 0) AS total FROM transactions
    WHERE $_base AND transactions.kind = 'expense' AND transactions.jalali_ym = ? AND -($effSql) < ?
  ''', variables: [Variable.withInt(ym), Variable.withInt(smallLimit)]).getSingle();
  final unc = await db.customSelect('''
    SELECT COUNT(*) AS n, COALESCE(SUM(ABS(transactions.amount)), 0) AS total FROM transactions
    WHERE $_base AND transactions.category_id IS NULL AND transactions.jalali_ym = ?
  ''', variables: [Variable.withInt(ym)]).getSingle();
  final gap = await db.customSelect('''
    SELECT COUNT(*) AS n, COALESCE(SUM(ABS(balance_gap)), 0) AS total FROM transactions
    WHERE deleted_at IS NULL AND balance_gap IS NOT NULL AND balance_gap != 0 AND jalali_ym = ?
  ''', variables: [Variable.withInt(ym)]).getSingle();
  final rec = await db.customSelect('SELECT COUNT(*) AS n FROM recurrings WHERE NOT confirmed AND NOT dismissed').getSingle();
  return Leaks(
    spikes: spikes.take(5).toList(),
    smallCount: small.read<int>('n'), smallTotal: small.read<int>('total'),
    uncatCount: unc.read<int>('n'), uncatTotal: unc.read<int>('total'),
    gapCount: gap.read<int>('n'), gapTotal: gap.read<int>('total'),
    recurringCount: rec.read<int>('n'),
  );
}

final leaksProvider = StreamProvider.family<Leaks, LeakKey>((ref, k) {
  final db = ref.watch(dbProvider);
  final List<ResultSetImplementation> watched = [db.transactions, db.categories, db.recurrings, db.splits];
  return db.tableUpdates(TableUpdateQuery.onAllTables(watched)).asyncMap((_) => computeLeaks(db, k.$1, k.$2)).startWith(() => computeLeaks(db, k.$1, k.$2));
});

extension<T> on Stream<T> {
  Stream<T> startWith(Future<T> Function() first) async* {
    yield await first();
    yield* this;
  }
}

// ---- richer report data -----------------------------------------------------------

/// Spending per day of a Jalali month (positive Rial), one entry per day.
final dailySpendProvider = StreamProvider.family<List<int>, int>((ref, ym) {
  final db = ref.watch(dbProvider);
  final days = Jalali(ym ~/ 100, ym % 100, 1).monthLength;
  return db.customSelect('''
    SELECT transactions.occurred_at AS at, -($effSql) AS amt FROM transactions
    WHERE $_base AND transactions.kind = 'expense' AND transactions.jalali_ym = ?
  ''', variables: [Variable.withInt(ym)], readsFrom: {db.transactions, db.splits}).watch().map((rows) {
    final out = List<int>.filled(days, 0);
    for (final r in rows) {
      final d = Jalali.fromDateTime(r.read<DateTime>('at')).day - 1;
      if (d >= 0 && d < days) out[d] += r.read<int>('amt');
    }
    return out;
  });
});

/// Spending by weekday, Saturday first (index 0) to Friday (6).
final weekdayProvider = StreamProvider.family<List<int>, Period>((ref, p) {
  final db = ref.watch(dbProvider);
  return db.customSelect('''
    SELECT CAST(strftime('%w', transactions.occurred_at, 'unixepoch', 'localtime') AS INTEGER) AS wd, SUM(-($effSql)) AS total
    FROM transactions WHERE $_base AND transactions.kind = 'expense' AND ${p.where} GROUP BY wd
  ''', variables: p.vars, readsFrom: {db.transactions, db.splits}).watch().map((rows) {
    final out = List<int>.filled(7, 0);
    for (final r in rows) {
      out[(r.read<int>('wd') + 1) % 7] = r.read<int>('total'); // strftime: 0 = Sunday
    }
    return out;
  });
});

class TopExpense {
  const TopExpense(this.id, this.amount);
  final int id, amount; // amount: my share, negative
}

final topExpensesProvider = StreamProvider.family<List<TopExpense>, Period>((ref, p) {
  final db = ref.watch(dbProvider);
  return db.customSelect('''
    SELECT transactions.id AS id, ($effSql) AS amt FROM transactions
    WHERE $_base AND transactions.kind = 'expense' AND ${p.where} ORDER BY amt ASC LIMIT 5
  ''', variables: p.vars, readsFrom: {db.transactions, db.splits}).watch().map(
        (rows) => [for (final r in rows) TopExpense(r.read<int>('id'), r.read<int>('amt'))],
      );
});
