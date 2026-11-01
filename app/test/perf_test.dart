// Seeds a million transactions over ten years and times the queries the app
// runs on its main screens. Slow (a minute or two): run on demand with
//   flutter test test/perf_test.dart
import 'dart:io';

import 'package:daftar/db/database.dart';
import 'package:daftar/features/report_data.dart';
import 'package:daftar/repo.dart';
import 'package:daftar/state.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('1M transactions stay fast', () async {
    final dir = Directory.systemTemp.createTempSync('daftar-perf');
    final db = AppDb(NativeDatabase(File('${dir.path}/perf.sqlite')));
    addTearDown(() async {
      await db.close();
      dir.deleteSync(recursive: true);
    });

    const n = int.fromEnvironment('PERF_N', defaultValue: 1000000);
    final sw = Stopwatch()..start();
    await db.customStatement('DROP TRIGGER tx_fts_ai');
    await db.customStatement('''
      WITH RECURSIVE s(i) AS (SELECT 1 UNION ALL SELECT i + 1 FROM s WHERE i < $n)
      INSERT INTO transactions (account_id, amount, occurred_at, jalali_ym, kind, source, category_id, note, balance_after)
      SELECT 1,
             CASE WHEN i % 20 = 0 THEN i % 9000000 + 1000000 ELSE -(i % 900000 + 10000) END,
             1451606400 + (i * 315),
             (1395 + ((i * 120 / $n) / 12)) * 100 + ((i * 120 / $n) % 12) + 1,
             CASE WHEN i % 20 = 0 THEN 'income' ELSE 'expense' END,
             'sms',
             CASE WHEN i % 7 = 0 THEN NULL ELSE 1 + i % 30 END,
             CASE WHEN i % 5 = 0 THEN 'taxi ride ' || i WHEN i % 11 = 0 THEN 'bread and milk' ELSE '' END,
             i * 10
      FROM s
    ''');
    await db.customStatement("INSERT INTO tx_fts(rowid, note, body) SELECT id, note, '' FROM transactions");
    await db.createSearchIndex();
    // ignore: avoid_print
    print('seeded $n rows in ${sw.elapsed.inSeconds}s');

    final c = ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
    addTearDown(c.dispose);
    final repo = c.read(repoProvider);
    const ym = 140205;

    // Riverpod 3 pauses providers nobody listens to, so hold a listener while reading.
    Future<T> value<T>(StreamProvider<T> p) async {
      final sub = c.listen(p, (_, __) {});
      try {
        return await c.read(p.future);
      } finally {
        sub.close();
      }
    }

    Future<int> time(String name, Future<void> Function() run, {required int maxMs, bool warm = true}) async {
      if (warm) await run(); // second visit; streams cache their last result, so they skip this
      final t = Stopwatch()..start();
      await run();
      final ms = t.elapsedMilliseconds;
      // ignore: avoid_print
      print('${name.padRight(26)} $ms ms (limit $maxMs)');
      expect(ms, lessThan(maxMs), reason: name);
      return ms;
    }

    // Limits are for this computer; phones are a few times slower.
    await time('month list, first page', () => repo.query(const TxFilter(ym: ym), limit: 100).get(), maxMs: 40);
    await time('month list, page 5', () => (repo.query(const TxFilter(ym: ym))..limit(100, offset: 400)).get(), maxMs: 60);
    await time('month totals', () => value(periodTotalsProvider(const Period.month(ym))), maxMs: 120, warm: false);
    await time('month by category', () => value(slicesProvider((const Period.month(ym), GroupBy.category, true))), maxMs: 150, warm: false);
    await time('12-month trend', () => value(trendProvider(ym)), maxMs: 200, warm: false);
    await time('to-review count', () => repo.count(const TxFilter(toReview: true, ym: ym)), maxMs: 80);
    await time('search "taxi" (all time)', () => repo.query(const TxFilter(query: 'taxi'), limit: 100).get(), maxMs: 300);

    final totals = await value(periodTotalsProvider(const Period.month(ym)));
    // ignore: avoid_print
    print('month has ${totals.count} rows');
    expect(totals.count, greaterThan(n ~/ 200)); // the timings above measured real work

    // Every main query must use an index instead of scanning the table.
    for (final sql in [
      'SELECT * FROM transactions WHERE jalali_ym = 140205 AND deleted_at IS NULL ORDER BY occurred_at DESC, id DESC LIMIT 100',
      'SELECT category_id, SUM(amount) FROM transactions WHERE jalali_ym = 140205 GROUP BY category_id',
    ]) {
      final plan = (await db.customSelect('EXPLAIN QUERY PLAN $sql').get()).map((r) => r.read<String>('detail')).join(' | ');
      // ignore: avoid_print
      print(plan);
      expect(plan, isNot(contains('SCAN transactions')), reason: sql);
    }
  }, timeout: const Timeout(Duration(minutes: 10)));
}
