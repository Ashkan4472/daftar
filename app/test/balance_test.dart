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
}
