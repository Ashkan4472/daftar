import 'package:daftar/db/database.dart';
import 'package:daftar/repo.dart';
import 'package:daftar/state.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDb db;
  late ProviderContainer c;
  setUp(() {
    db = AppDb(NativeDatabase.memory());
    c = ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
  });
  tearDown(() async {
    c.dispose();
    await db.close();
  });

  Future<AccountBalance> balance() async {
    final sub = c.listen(accountBalancesProvider, (_, __) {});
    final all = await c.read(accountBalancesProvider.future);
    sub.close();
    return all.firstWhere((b) => b.account.id == 1);
  }

  Future<void> tx(int amount, DateTime at, {int? balanceAfter}) => db.into(db.transactions).insert(TransactionsCompanion.insert(
        accountId: 1, amount: amount, occurredAt: at, jalaliYm: 140508,
        kind: amount < 0 ? TxKind.expense : TxKind.income, source: TxSource.manual, balanceAfter: Value(balanceAfter)));

  final t0 = DateTime(2026, 10, 1, 12);

  test('no anchor: opening plus everything', () async {
    await (db.update(db.accounts)..where((a) => a.id.equals(1))).write(const AccountsCompanion(openingBalance: Value(1000)));
    await tx(-300, t0);
    final b = await balance();
    expect(b.balance, 700);
    expect(b.source, BalanceSource.computed);
  });

  test('latest SMS balance wins, later entries without a balance are added', () async {
    await tx(-100, t0, balanceAfter: 5000);
    await tx(-50, t0.add(const Duration(hours: 1)), balanceAfter: 4950);
    await tx(-20, t0.add(const Duration(hours: 2))); // manual, no balance
    final b = await balance();
    expect(b.balance, 4930);
    expect(b.source, BalanceSource.sms);
  });

  test('typed-in balance overrides older SMS and later entries add to it', () async {
    await tx(-100, t0, balanceAfter: 5000);
    await Repo(db).setBalance(1, 9000, t0.add(const Duration(hours: 1)));
    await tx(-500, t0.add(const Duration(hours: 2))); // after the typed balance
    final b = await balance();
    expect(b.balance, 8500);
    expect(b.source, BalanceSource.manual);
  });

  test('a newer SMS balance replaces the typed one; clearing returns to automatic', () async {
    await Repo(db).setBalance(1, 9000, t0);
    await tx(-100, t0.add(const Duration(hours: 3)), balanceAfter: 7777);
    var b = await balance();
    expect((b.balance, b.source), (7777, BalanceSource.sms));
    await Repo(db).setBalance(1, null, null);
    b = await balance();
    expect(b.source, BalanceSource.sms);
  });

  test('merging accounts anchors on the newest SMS balance of either', () async {
    final two = await db.into(db.accounts).insert(AccountsCompanion.insert(
        name: 'Card', kind: AccountKind.bank, icon: 'bank:regular', color: 0, number: const Value('6037')));
    await tx(-100, t0, balanceAfter: 5000);
    await db.into(db.transactions).insert(TransactionsCompanion.insert(
        accountId: two, amount: -200, occurredAt: t0.add(const Duration(hours: 1)), jalaliYm: 140508,
        kind: TxKind.expense, source: TxSource.sms, balanceAfter: const Value(4800)));
    await Repo(db).mergeAccounts(from: two, into: 1);
    final b = await balance();
    expect(b.balance, 4800);
    expect((await db.select(db.accounts).get()).any((a) => a.id == two), isFalse);
    expect((await db.accountAliases())['6037'], 1);
  });

  test('split restores the account, its transactions and its number', () async {
    final two = await db.into(db.accounts).insert(AccountsCompanion.insert(
        name: 'Card', kind: AccountKind.bank, icon: 'bank:regular', color: 0, number: const Value('6037'), openingBalance: const Value(70)));
    await tx(-100, t0, balanceAfter: 5000);
    final t2 = await db.into(db.transactions).insert(TransactionsCompanion.insert(
        accountId: two, amount: -200, occurredAt: t0.add(const Duration(hours: 1)), jalaliYm: 140508,
        kind: TxKind.expense, source: TxSource.sms, balanceAfter: const Value(4800)));
    final repo = Repo(db);
    await repo.mergeAccounts(from: two, into: 1);
    expect(await repo.mergedInto(1), [(two, 'Card')]);
    // An SMS for card 6037 arrives after the merge and is filed under account 1.
    final late = await db.into(db.transactions).insert(TransactionsCompanion.insert(
        accountId: 1, amount: -7, occurredAt: t0.add(const Duration(hours: 3)), jalaliYm: 140508, kind: TxKind.expense, source: TxSource.sms));
    await repo.noteAliasTx('6037', late);
    await repo.splitAccount(two);
    final accs = await db.select(db.accounts).get();
    expect(accs.firstWhere((a) => a.id == two).openingBalance, 70);
    expect(accs.firstWhere((a) => a.id == 1).openingBalance, 0);
    expect((await (db.select(db.transactions)..where((t) => t.id.equals(t2))).getSingle()).accountId, two);
    expect((await db.accountAliases()).containsKey('6037'), isFalse);
    expect(await repo.mergedInto(1), isEmpty);
    expect((await (db.select(db.transactions)..where((t) => t.id.equals(late))).getSingle()).accountId, two);
    expect((await balance()).balance, 5000);
  });

  test('chained merges split back level by level', () async {
    final b = await db.into(db.accounts).insert(AccountsCompanion.insert(name: 'B', kind: AccountKind.cash, icon: 'x', color: 0, number: const Value('b')));
    final c = await db.into(db.accounts).insert(AccountsCompanion.insert(name: 'C', kind: AccountKind.cash, icon: 'x', color: 0, number: const Value('c')));
    final repo = Repo(db);
    await repo.mergeAccounts(from: c, into: b);
    await repo.mergeAccounts(from: b, into: 1);
    expect((await db.accountAliases()), {'b': 1, 'c': 1});
    await repo.splitAccount(b);
    expect(await repo.mergedInto(b), [(c, 'C')]);
    expect((await db.accountAliases()), {'c': b});
    await repo.splitAccount(c);
    expect(await db.accountAliases(), isEmpty);
  });

  test('markTransfer links the matching row, or adds the missing leg', () async {
    final cash = await db.into(db.accounts).insert(AccountsCompanion.insert(name: 'Cash', kind: AccountKind.cash, icon: 'x', color: 0));
    final repo = Repo(db);
    Future<List<Transaction>> all() => (db.select(db.transactions)..orderBy([(t) => OrderingTerm.asc(t.id)])).get();

    // No counterpart: a cash leg is added.
    await tx(-500, t0);
    await repo.markTransfer((await all()).last.id, cash);
    var rows = await all();
    expect(rows.length, 2);
    expect(rows.map((r) => r.kind).toSet(), {TxKind.transfer});
    expect(rows[1].accountId, cash);
    expect(rows[1].amount, 500);
    expect(rows[0].transferGroupId, rows[1].transferGroupId);

    // Counterpart exists a day later: linked, nothing added.
    await tx(-200, t0);
    await db.into(db.transactions).insert(TransactionsCompanion.insert(accountId: cash, amount: 200,
        occurredAt: t0.add(const Duration(days: 1)), jalaliYm: 140508, kind: TxKind.income, source: TxSource.manual));
    rows = await all();
    await repo.markTransfer(rows[2].id, cash);
    rows = await all();
    expect(rows.length, 4);
    expect(rows[3].kind, TxKind.transfer);
    expect(rows[2].transferGroupId, rows[3].transferGroupId);
  });
}
