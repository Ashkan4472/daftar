import 'package:core/core.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:drift/drift.dart';

import '../db/database.dart';
import '../db/seed.dart';
import '../features/report_data.dart';
import '../repo.dart';
import '../state.dart';
import 'notifier.dart';

/// Proposes transfers between own accounts from the last 30 days.
Future<void> proposeTransfers(AppDb db) async {
  final since = DateTime.now().subtract(const Duration(days: 30));
  final rows = await (db.select(db.transactions)
        ..where((t) => t.deletedAt.isNull() & t.occurredAt.isBiggerOrEqualValue(since) & t.kind.equals(TxKind.transfer.name).not() & t.transferGroupId.isNull()))
      .get();
  final known = await db.select(db.transferProposals).get();
  final taken = {for (final p in known) ...[p.outTxId, p.inTxId]};
  final pairs = findTransferPairs([
    for (final t in rows)
      if (!taken.contains(t.id)) TxLite(t.id, t.accountId, t.amount, t.occurredAt),
  ]);
  if (pairs.isEmpty) return;
  final accounts = {for (final a in await db.select(db.accounts).get()) a.id: a};
  final repo = Repo(db);
  final l = await l10nFor(repo);
  final prefs = Prefs(lang: await repo.setting('lang') ?? 'en', toman: await repo.setting('toman') != 'false');
  final byId = {for (final t in rows) t.id: t};
  for (final (o, i) in pairs) {
    await db.into(db.transferProposals).insert(TransferProposalsCompanion.insert(outTxId: o, inTxId: i));
    final out = byId[o]!, inn = byId[i]!;
    await notify(db,
        kind: 'transfer',
        title: l.notifTransferTitle,
        body: l.notifTransferBody(prefs.digits(prefs.money(inn.amount)), accounts[out.accountId]?.name ?? '', accounts[inn.accountId]?.name ?? ''),
        payload: 'transfers');
  }
}

Future<void> confirmTransfer(AppDb db, TransferProposal p) async {
  await db.transaction(() async {
    final c = TransactionsCompanion(
      kind: const Value(TxKind.transfer), categoryId: const Value(null), needsReview: const Value(false),
      transferGroupId: Value(p.id), updatedAt: Value(DateTime.now()));
    await (db.update(db.transactions)..where((t) => t.id.isIn([p.outTxId, p.inTxId]))).write(c);
    await (db.delete(db.txParts)..where((x) => x.transactionId.isIn([p.outTxId, p.inTxId]))).go();
    await (db.update(db.transferProposals)..where((x) => x.id.equals(p.id))).write(const TransferProposalsCompanion(status: Value('confirmed')));
  });
}

Future<void> dismissTransfer(AppDb db, TransferProposal p) =>
    (db.update(db.transferProposals)..where((x) => x.id.equals(p.id))).write(const TransferProposalsCompanion(status: Value('dismissed')));

/// Finds monthly repeats in the last ~14 months. Runs at most once a day.
Future<void> detectRecurringJob(AppDb db, {bool force = false}) async {
  final repo = Repo(db);
  final today = DateTime.now();
  final stamp = '${today.year}-${today.month}-${today.day}';
  if (!force && await repo.setting('recurring_run') == stamp) return;
  await repo.putSetting('recurring_run', stamp);
  final since = today.subtract(const Duration(days: 430));
  final rows = await (db.select(db.transactions)
        ..where((t) => t.deletedAt.isNull() & t.occurredAt.isBiggerOrEqualValue(since) & t.kind.equals(TxKind.transfer.name).not()))
      .get();
  final guesses = detectRecurring([for (final t in rows) TxLite(t.id, t.accountId, t.amount, t.occurredAt)]);
  final existing = await db.select(db.recurrings).get();
  for (final g in guesses) {
    final dup = existing.any((e) => e.accountId == g.accountId && e.expectedAmount.sign == g.amount.sign && (e.expectedAmount.abs() - g.amount.abs()).abs() <= g.amount.abs() * 0.1);
    if (dup) {
      // Keep the next due date fresh for ones already known.
      for (final e in existing.where((e) => e.accountId == g.accountId && (e.expectedAmount.abs() - g.amount.abs()).abs() <= g.amount.abs() * 0.1)) {
        await (db.update(db.recurrings)..where((x) => x.id.equals(e.id))).write(RecurringsCompanion(nextDue: Value(g.nextDue)));
      }
      continue;
    }
    await db.into(db.recurrings).insert(RecurringsCompanion.insert(
        accountId: g.accountId, expectedAmount: g.amount, periodDays: g.periodDays, nextDue: g.nextDue));
  }
}

/// Notifies once when a budget reaches 80% and once when it passes 100%.
Future<void> checkBudgets(AppDb db) async {
  final repo = Repo(db);
  final ym = jalaliYm(DateTime.now());
  final l = await l10nFor(repo);
  final prefs = Prefs(lang: await repo.setting('lang') ?? 'en', toman: await repo.setting('toman') != 'false');
  for (final b in await loadBudgets(db, ym)) {
    final level = b.ratio >= 1 ? 100 : b.ratio >= 0.8 ? 80 : 0;
    if (level == 0) continue;
    final key = 'budget_alert_${b.budget.id}_$ym';
    if (int.tryParse(await repo.setting(key) ?? '0')! >= level) continue;
    await repo.putSetting(key, '$level');
    final name = displayName(b.category.name, b.category.nameKey, prefs.lang);
    await notify(db,
        kind: 'budget',
        title: level == 100 ? l.notifBudgetOver(name) : l.notifBudgetWarn(name, prefs.digits('${(b.ratio * 100).round()}')),
        body: l.notifBudgetBody(prefs.money(b.spent), prefs.money(b.budget.monthlyLimit)),
        payload: 'budgets');
  }
}

/// Mid-month: warn once per category that runs far above its usual.
Future<void> checkLeaks(AppDb db) async {
  final repo = Repo(db);
  final now = DateTime.now();
  final ym = jalaliYm(now);
  if (Jalali.fromDateTime(now).day < 15) return;
  final leaks = await computeLeaks(db, ym, 500000);
  final cats = {for (final c in await db.select(db.categories).get()) c.id: c};
  final l = await l10nFor(repo);
  final lang = await repo.setting('lang') ?? 'en';
  for (final s in leaks.spikes) {
    final key = 'leak_alert_${s.categoryId}_$ym';
    if (await repo.setting(key) != null) continue;
    await repo.putSetting(key, '1');
    final c = cats[s.categoryId];
    if (c == null) continue;
    await notify(db, kind: 'leak', title: l.notifLeakTitle(displayName(c.name, c.nameKey, lang)), payload: 'leaks');
  }
}

/// On a new Jalali month, summarise the one that just ended (once).
Future<void> monthlySummary(AppDb db) async {
  final repo = Repo(db);
  final cur = jalaliYm(DateTime.now());
  final last = int.tryParse(await repo.setting('summary_ym') ?? '');
  if (last == null) {
    await repo.putSetting('summary_ym', '$cur'); // do not summarise history on first run
    return;
  }
  if (last >= cur) return;
  await repo.putSetting('summary_ym', '$cur');
  final prev = prevYm(cur);
  final l = await l10nFor(repo);
  final prefs = Prefs(lang: await repo.setting('lang') ?? 'en', toman: await repo.setting('toman') != 'false');
  final t = await db.customSelect('''
    SELECT COALESCE(SUM(CASE WHEN kind = 'income' THEN $effSql END), 0) AS income,
           COALESCE(SUM(CASE WHEN kind = 'expense' THEN $effSql END), 0) AS expense, COUNT(*) AS n
    FROM transactions WHERE deleted_at IS NULL AND NOT excluded AND kind != 'transfer' AND jalali_ym = ?
  ''', variables: [Variable.withInt(prev)]).getSingle();
  if (t.read<int>('n') == 0) return;
  final top = await db.customSelect('''
    SELECT COALESCE(c.parent_id, c.id) AS k, SUM(-($catEff)) AS total
    FROM transactions $partJoin JOIN categories c ON c.id = $catKey
    WHERE transactions.deleted_at IS NULL AND NOT transactions.excluded AND transactions.kind = 'expense' AND transactions.jalali_ym = ?
    GROUP BY k ORDER BY total DESC LIMIT 3
  ''', variables: [Variable.withInt(prev)]).get();
  final cats = {for (final c in await db.select(db.categories).get()) c.id: c};
  final review = await db.customSelect(
      "SELECT COUNT(*) AS n FROM transactions WHERE deleted_at IS NULL AND category_id IS NULL AND kind != 'transfer' AND jalali_ym = ?",
      variables: [Variable.withInt(prev)]).getSingle();
  final income = t.read<int>('income'), expense = t.read<int>('expense');
  final names = [for (final r in top) if (cats[r.read<int>('k')] case final c?) '${displayName(c.name, c.nameKey, prefs.lang)} ${prefs.money(r.read<int>('total'))}'];
  final lines = [
    l.notifSummaryBody(prefs.money(income), prefs.money(-expense), prefs.money(income + expense, signed: true)),
    if (names.isNotEmpty) l.notifSummaryTop(names.join('، ')),
    if (review.read<int>('n') > 0) l.notifSummaryReview(review.read<int>('n')),
  ];
  await notify(db, kind: 'summary', title: l.notifSummaryTitle(prefs.monthName(prev)), body: lines.join('\n'), payload: 'reports');
}

/// Everything that should follow a batch of new transactions.
Future<void> afterImport(AppDb db) async {
  await proposeTransfers(db);
  await detectRecurringJob(db);
  await checkBudgets(db);
  await checkLeaks(db);
  await monthlySummary(db);
}
