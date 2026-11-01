import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'db/database.dart';

final dbProvider = Provider<AppDb>((ref) {
  final db = AppDb();
  ref.onDispose(db.close);
  return db;
});

class Prefs {
  const Prefs({this.lang = 'en', this.toman = true, this.theme = ThemeMode.system});
  final String lang;
  final bool toman;
  final ThemeMode theme;

  Locale get locale => Locale(lang);
  bool get persian => lang == 'fa';

  String money(int amount, {bool signed = false}) =>
      formatMoney(amount, toman: toman, signed: signed, persian: persian);

  String digits(String s) => persian ? toPersianDigits(s) : s;

  String monthName(int ym) {
    final m = (persian ? jalaliMonthsFa : jalaliMonthsEn)[ym % 100 - 1];
    return '$m ${digits('${ym ~/ 100}')}';
  }
}

class PrefsNotifier extends Notifier<Prefs> {
  @override
  Prefs build() {
    _load();
    return const Prefs();
  }

  AppDb get _db => ref.read(dbProvider);

  Future<void> _load() async {
    final rows = {for (final s in await _db.select(_db.settings).get()) s.key: s.value};
    state = Prefs(
      lang: rows['lang'] ?? 'en',
      toman: rows['toman'] != 'false',
      theme: ThemeMode.values.firstWhere((m) => m.name == rows['theme'], orElse: () => ThemeMode.system),
    );
  }

  Future<void> _put(String key, String value) =>
      _db.into(_db.settings).insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));

  Future<void> setLang(String lang) async {
    state = Prefs(lang: lang, toman: state.toman, theme: state.theme);
    await _put('lang', lang);
  }

  Future<void> setTheme(ThemeMode m) async {
    state = Prefs(lang: state.lang, toman: state.toman, theme: m);
    await _put('theme', m.name);
  }

  Future<void> setToman(bool v) async {
    state = Prefs(lang: state.lang, toman: v, theme: state.theme);
    await _put('toman', '$v');
  }
}

final prefsProvider = NotifierProvider<PrefsNotifier, Prefs>(PrefsNotifier.new);

class MonthNotifier extends Notifier<int> {
  @override
  int build() => jalaliYm(DateTime.now());
  void set(int ym) => state = ym;
  void next() => state = nextYm(state);
  void prev() => state = prevYm(state);
}

final monthProvider = NotifierProvider<MonthNotifier, int>(MonthNotifier.new);

class MonthSummary {
  const MonthSummary(this.income, this.expense, this.toReview, this.count);
  final int income, expense, toReview, count;
  int get net => income + expense;
}

final monthSummaryProvider = StreamProvider.family<MonthSummary, int>((ref, ym) {
  final db = ref.watch(dbProvider);
  return db.customSelect('''
    SELECT
      COALESCE(SUM(CASE WHEN kind = 'income' AND NOT excluded THEN amount END), 0) AS income,
      COALESCE(SUM(CASE WHEN kind = 'expense' AND NOT excluded THEN amount + COALESCE((SELECT SUM(share) FROM splits s WHERE s.transaction_id = transactions.id), 0) END), 0) AS expense,
      COUNT(CASE WHEN (category_id IS NULL AND kind != 'transfer') OR needs_review THEN 1 END) AS review,
      COUNT(*) AS n
    FROM transactions WHERE jalali_ym = ? AND deleted_at IS NULL
  ''', variables: [Variable.withInt(ym)], readsFrom: {db.transactions, db.splits}).watchSingle().map(
        (r) => MonthSummary(r.read<int>('income'), r.read<int>('expense'), r.read<int>('review'),
            r.read<int>('n')),
      );
});

enum BalanceSource { sms, manual, computed }

class AccountBalance {
  const AccountBalance(this.account, this.balance, this.source, this.asOf);
  final Account account;
  final int balance;
  final BalanceSource source;

  /// When the anchor balance (SMS or typed-in) was valid; null when computed.
  final DateTime? asOf;
}

/// Current balance per account.
///
/// Anchor = the later of the newest SMS balance and the balance the user set.
/// Balance = anchor + transactions after it that carry no balance of their own
/// (manual entries, imports without a "remaining" line). With no anchor it is
/// opening balance + all transactions.
Future<AccountBalance> _balanceOf(AppDb db, Account a) async {
  final t = db.transactions;
  final sms = await (db.select(t)
        ..where((x) => x.accountId.equals(a.id) & x.deletedAt.isNull() & x.balanceAfter.isNotNull())
        ..orderBy([(x) => OrderingTerm.desc(x.occurredAt), (x) => OrderingTerm.desc(x.id)])
        ..limit(1))
      .getSingleOrNull();
  int? value;
  DateTime? at;
  var source = BalanceSource.computed;
  if (a.balanceSet != null && a.balanceSetAt != null && (sms == null || !sms.occurredAt.isAfter(a.balanceSetAt!))) {
    value = a.balanceSet;
    at = a.balanceSetAt;
    source = BalanceSource.manual;
  } else if (sms != null) {
    value = sms.balanceAfter;
    at = sms.occurredAt;
    source = BalanceSource.sms;
  }
  final sum = t.amount.sum();
  final q = db.selectOnly(t)..addColumns([sum])..where(t.accountId.equals(a.id) & t.deletedAt.isNull());
  if (at != null) q.where(t.occurredAt.isBiggerThanValue(at) & t.balanceAfter.isNull());
  final later = (await q.getSingle()).read(sum) ?? 0;
  return AccountBalance(a, (value ?? a.openingBalance) + later, source, at);
}

final accountBalancesProvider = StreamProvider<List<AccountBalance>>((ref) {
  final db = ref.watch(dbProvider);
  return db.customSelect('SELECT id FROM accounts', readsFrom: {db.accounts, db.transactions}).watch().asyncMap((_) async {
    final accounts = await (db.select(db.accounts)..orderBy([(a) => OrderingTerm.asc(a.sort), (a) => OrderingTerm.asc(a.id)])).get();
    return [for (final a in accounts) await _balanceOf(db, a)];
  });
});

class TabNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void go(int i) => state = i;
}

/// Selected bottom-nav tab, so any screen can jump to another tab.
final tabProvider = NotifierProvider<TabNotifier, int>(TabNotifier.new);

/// All settings rows as a map (key -> value).
final settingsMapProvider = StreamProvider<Map<String, String>>((ref) {
  final db = ref.watch(dbProvider);
  return db.select(db.settings).watch().map((rows) => {for (final r in rows) r.key: r.value});
});

/// Months of [year] (1..12) that have at least one transaction.
final monthsWithDataProvider = StreamProvider.family<Set<int>, int>((ref, year) {
  final db = ref.watch(dbProvider);
  return db.customSelect(
    'SELECT DISTINCT jalali_ym AS ym FROM transactions WHERE deleted_at IS NULL AND jalali_ym BETWEEN ? AND ?',
    variables: [Variable.withInt(year * 100 + 1), Variable.withInt(year * 100 + 12)],
    readsFrom: {db.transactions},
  ).watch().map((rows) => {for (final r in rows) r.read<int>('ym') % 100});
});
