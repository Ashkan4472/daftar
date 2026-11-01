import 'package:daftar/db/database.dart';
import 'package:daftar/db/seed.dart';
import 'package:daftar/icons/phosphor_codepoints.g.dart';
import 'package:daftar/sms/importer.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shamsi_date/shamsi_date.dart';

DateTime j(int y, int m, int d, int h, int min) => Jalali(y, m, d, h, min).toDateTime();

void main() {
  late AppDb db;
  setUp(() => db = AppDb(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('every seeded icon exists in Phosphor', () {
    final names = [
      for (final c in seedExpenseCategories) ...[c.$2, for (final s in c.$3) s.$2],
      for (final c in seedIncomeCategories) c.$2,
      for (final t in seedTags) t.$2,
      'bank', 'wallet', 'question', 'receipt', 'chart-pie-slice', 'users',
    ];
    expect(names.where((n) => !phosphorCodepoints.containsKey(n)), isEmpty);
  });

  test('imports Resalat samples, dedupes, flags balance gaps, skips noise', () async {
    final importer = SmsImporter(db);
    final msgs = [
      SmsMessage('Resalat', '10.11228735.1\n-1,900,000 \n07/30_09:57\nمانده: 22,975,232 ', j(1405, 7, 30, 9, 58)),
      SmsMessage('Resalat', ' 10.11228735.1\n+20,000,000 \n08/01_17:39\nمانده: 39,375,232 ', j(1405, 8, 1, 17, 40)),
      SmsMessage('Resalat', '10.11228735.1\n-2,500,000 \n08/02_18:18\nمانده: 825,063,832', j(1405, 8, 2, 18, 19)),
      SmsMessage('+989121234567', 'Hi, dinner tonight?', j(1405, 8, 2, 19, 0)),
      SmsMessage('3000', 'کد تایید شما 12345', j(1405, 8, 2, 19, 1)),
      SmsMessage('9850', 'خرید از فروشگاه 50,000 ریال تخفیف', j(1405, 8, 2, 19, 2)),
    ];
    final r = ImportResult();
    final touched = await importer.importMessages(msgs, r);
    for (final a in touched) {
      await importer.recomputeBalanceGaps(a);
    }
    expect(r.added, 3);
    expect(r.unmatched, 1); // the ad is kept for the template builder; chat/OTP dropped

    final txs = await (db.select(db.transactions)..orderBy([(t) => OrderingTerm.asc(t.occurredAt)])).get();
    expect(txs.map((t) => t.amount), [-1900000, 20000000, -2500000]);
    expect(txs.map((t) => t.jalaliYm), [140507, 140508, 140508]);
    expect(txs.map((t) => t.balanceGap), [null, -3600000, 788188600]);

    final acc = await (db.select(db.accounts)..where((a) => a.number.equals('10.11228735.1'))).getSingle();
    expect(acc.name, 'Resalat 10.11228735.1');
    final sender = await (db.select(db.smsSenders)..where((s) => s.address.equals('Resalat'))).getSingle();
    expect(sender.bankId, acc.bankId);

    // Re-import is a no-op.
    final r2 = ImportResult();
    await importer.importMessages(msgs, r2);
    expect(r2.added, 0);
    expect(r2.duplicates, 4);
    expect(await db.transactions.count().getSingle(), 3);
  });
}
