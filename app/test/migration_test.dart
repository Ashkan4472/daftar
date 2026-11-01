import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

import 'package:daftar/db/database.dart';

void main() {
  test('upgrading from schema v4 keeps all existing data', () async {
    // Build a v4 database: the current schema minus tx_parts, user_version 4.
    final raw = sql.sqlite3.openInMemory();
    final seed = AppDb(NativeDatabase.opened(raw));
    final acc = (await seed.select(seed.accounts).get()).first.id;
    await seed.into(seed.transactions).insert(TransactionsCompanion.insert(
        accountId: acc, amount: -12345, occurredAt: DateTime(2026, 10, 1), jalaliYm: 140407, kind: TxKind.expense, source: TxSource.manual));
    final cats = (await seed.select(seed.categories).get()).length;
    raw.execute('DROP TABLE tx_parts');
    raw.execute('PRAGMA user_version = 4');

    // Reopening runs the real onUpgrade (4 -> 5). Don't close `seed`: it owns the shared handle.
    final db = AppDb(NativeDatabase.opened(raw));
    final txs = await db.select(db.transactions).get();
    expect(txs.single.amount, -12345);
    expect((await db.select(db.categories).get()).length, cats);
    expect(await db.select(db.txParts).get(), isEmpty); // table exists again
    await db.close();
  });
}
