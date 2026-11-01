import 'package:daftar/db/database.dart';
import 'package:daftar/repo.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an open transaction sees tags added and removed', () async {
    final db = AppDb(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = Repo(db);
    final id = await repo.addManual(amount: -1000, accountId: 1, at: DateTime(2026, 10, 1));
    final tagA = (await db.select(db.tags).get()).first.id;

    final seen = <List<int>>[];
    final sub = repo.watchOne(id).listen((r) => seen.add(r!.tagIds));
    await pumpEventQueue();
    await repo.addTag([id], tagA);
    await pumpEventQueue();
    await repo.removeTag([id], tagA);
    await pumpEventQueue();
    await sub.cancel();

    expect(seen.first, isEmpty);
    expect(seen.any((t) => t.contains(tagA)), isTrue, reason: 'selected state must show up');
    expect(seen.last, isEmpty, reason: 'deselecting must show up');
  });
}
