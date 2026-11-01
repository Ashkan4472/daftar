import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daftar/db/database.dart';
import 'package:daftar/features/report_data.dart';
import 'package:daftar/repo.dart';

void main() {
  test('category split: reports count parts, single category undoes it', () async {
    final db = AppDb(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = Repo(db);
    final cats = await db.select(db.categories).get();
    final (a, b) = (cats[0].id, cats[1].id);
    final acc = (await db.select(db.accounts).get()).first.id;
    final at = DateTime(2026, 10, 5);
    final id = await repo.addManual(amount: -100000, accountId: acc, at: at, categoryId: a, note: '', tagIds: {});

    await repo.setParts(id, [(a, 30000), (b, 70000)]);
    final slices = await db
        .customSelect(
          'SELECT COALESCE(p.category_id, transactions.category_id) AS k, SUM(-($catEff)) AS t FROM transactions $partJoin GROUP BY k',
        )
        .get();
    expect({for (final r in slices) r.read<int>('k'): r.read<int>('t')}, {a: 30000, b: 70000});
    expect((await repo.get(id))!.tx.categoryId, b); // largest part

    final byCat = await repo.query(TxFilter(categoryIds: [a])).get();
    expect(byCat.length, 1); // one row per matching part, showing that part
    expect(byCat.single.read(db.txParts.amount), 30000);

    await repo.updateManual(id, amount: -50000, at: at); // amount changed -> split dropped
    expect(await db.select(db.txParts).get(), isEmpty);

    await repo.setParts(id, [(a, 20000), (b, 30000)]);
    await repo.setCategory([id], a);
    expect(await db.select(db.txParts).get(), isEmpty);
  });
}
