import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:test/test.dart';

DateTime j(int y, int m, int d, [int h = 0, int min = 0]) =>
    Jalali(y, m, d, h, min).toDateTime();

void main() {
  group('Resalat', () {
    // Real samples (bank sends trailing spaces / leading space).
    const s1 = '10.11228735.1\n-1,900,000 \n07/30_09:57\nمانده: 22,975,232 ';
    const s2 = ' 10.11228735.1\n+20,000,000 \n08/01_17:39\nمانده: 39,375,232 ';
    const s3 = '10.11228735.1\n-2,500,000 \n08/02_18:18\nمانده: 825,063,832';

    test('parses withdrawal', () {
      final p = parseSms('Resalat', s1, j(1405, 7, 30, 9, 58))!;
      expect(p.templateId, 'resalat.v1');
      expect(p.amount, -1900000);
      expect(p.balance, 22975232);
      expect(p.account, '10.11228735.1');
      expect(p.occurredAt, j(1405, 7, 30, 9, 57));
      expect(p.needsReview, isFalse);
    });

    test('parses deposit', () {
      final p = parseSms('Resalat', s2, j(1405, 8, 1, 17, 40))!;
      expect(p.amount, 20000000);
      expect(p.balance, 39375232);
    });

    test('Persian digits and bidi marks normalize to the same result', () {
      final fa = '‏۱۰.۱۱۲۲۸۷۳۵.۱\n-۲٬۵۰۰٬۰۰۰\n۰۸/۰۲_۱۸:۱۸\nمانده: ۸۲۵٬۰۶۳٬۸۳۲';
      final p = parseSms('Resalat', fa, j(1405, 8, 2, 18, 19))!;
      expect(p.templateId, 'resalat.v1');
      expect(p.amount, -2500000);
      expect(p.balance, 825063832);
    });

    test('balance gaps in the samples are detected', () {
      expect(balanceGap(previousBalance: 22975232, amount: 20000000, balance: 39375232), -3600000);
      expect(balanceGap(previousBalance: 39375232, amount: -2500000, balance: 825063832), 788188600);
      expect(balanceGap(previousBalance: 100, amount: -40, balance: 60), 0);
    });
  });

  test('year inference across Esfand -> Farvardin', () {
    expect(inferSmsDate(j(1405, 1, 1, 0, 5), month: 12, day: 29, hour: 23, minute: 59),
        j(1404, 12, 29, 23, 59));
    expect(inferSmsDate(j(1405, 8, 2), month: 8, day: 2), j(1405, 8, 2));
    expect(inferSmsDate(j(1405, 8, 2), year: 1403, month: 8, day: 2), j(1403, 8, 2));
  });

  group('heuristic', () {
    test('keyword based expense', () {
      final p = parseSms('9850001', 'بانک نمونه\nبرداشت: 150,000\nمانده: 1,000,000\n05/08/01 12:30',
          j(1405, 8, 1, 12, 31))!;
      expect(p.templateId, 'heuristic');
      expect(p.amount, -150000);
      expect(p.balance, 1000000);
      expect(p.occurredAt, j(1405, 8, 1, 12, 30));
      expect(p.needsReview, isTrue);
    });

    test('keyword based income', () {
      final p = parseSms('x', 'واریز مبلغ 3,000,000 ریال', j(1405, 8, 1))!;
      expect(p.amount, 3000000);
    });

    test('non-transaction SMS is ignored', () {
      expect(parseSms('x', 'رمز یکبار مصرف شما: 123456', j(1405, 8, 1)), isNull);
    });
  });

  test('money formatting', () {
    expect(formatMoney(22975232), '22,975,232');
    expect(formatMoney(-1900000, toman: true), '−190,000');
    expect(formatMoney(20000000, signed: true), '+20,000,000');
    expect(formatMoney(1500, persian: true), '۱٬۵۰۰');
  });

  test('jalali month helpers', () {
    expect(jalaliYm(j(1405, 8, 2, 12)), 140508);
    expect(nextYm(140512), 140601);
    expect(prevYm(140601), 140512);
    final (s, e) = jalaliMonthRange(140507);
    expect(s, j(1405, 7, 1));
    expect(e, j(1405, 8, 1));
  });

  test('split math', () {
    expect(splitShares(100000, SplitMode.equal, [0, 0]), [33333, 33333]); // remainder 33334 is mine
    expect(splitShares(100000, SplitMode.percent, [25, 50]), [25000, 50000]);
    expect(splitShares(100000, SplitMode.exact, [60000, 30000]), [60000, 30000]);
    expect(splitShares(100000, SplitMode.exact, [60000, 50000]), isNull);
    expect(splitShares(100000, SplitMode.percent, [60, 50]), isNull);
    expect(splitShares(0, SplitMode.equal, [0]), isNull);
  });

  test('category split math', () {
    expect(splitParts(100001, SplitMode.equal, [0, 0, 0]), [33335, 33333, 33333]);
    expect(splitParts(100000, SplitMode.percent, [33, 67]), [33000, 67000]);
    expect(splitParts(100000, SplitMode.percent, [50, 40]), isNull); // must reach 100
    expect(splitParts(100000, SplitMode.exact, [60000, 40000]), [60000, 40000]);
    expect(splitParts(100000, SplitMode.exact, [60000, 30000]), isNull); // must add up
    expect(splitParts(100000, SplitMode.exact, [100000]), isNull); // one part is not a split
  });

  test('transfer pairing', () {
    final t = DateTime(2026, 10, 1, 12);
    final pairs = findTransferPairs([
      TxLite(1, 1, -5000000, t),
      TxLite(2, 2, 5000000, t.add(const Duration(minutes: 2))),
      TxLite(3, 1, -5000000, t.add(const Duration(hours: 5))), // no partner in window
      TxLite(4, 1, 5000000, t.add(const Duration(minutes: 1))), // same account as out
    ]);
    expect(pairs, [(1, 2)]);
  });

  test('recurring detection', () {
    final d = DateTime(2026, 5, 3);
    final txs = [
      for (var i = 0; i < 4; i++) TxLite(i, 1, -(1000000 + i * 10000), d.add(Duration(days: 30 * i))),
      TxLite(10, 1, -750000, d), // one-off
      TxLite(11, 2, -1000000, d), // other account, single
    ];
    final r = detectRecurring(txs);
    expect(r.length, 1);
    expect(r.first.count, 4);
    expect(r.first.periodDays, 30);
    expect(r.first.amount, -1010000);
    expect(r.first.nextDue, d.add(const Duration(days: 120)));
  });

  test('csv round trip with Persian, quotes and newlines', () {
    final rows = [
      ['a', 'b,c', 'd"e'],
      ['خرید\nنان', '', '۱۲۳'],
    ];
    expect(parseCsv(csvBom + toCsv(rows)), rows);
  });

  test('export row and flexible dates', () {
    final r = ExportRow(at: j(1405, 8, 2, 18, 18), account: 'Resalat', kind: 'expense', amount: -2500000, tags: ['a', 'b'], balanceAfter: 5);
    final c = r.toCells();
    expect(c[0], '1405/08/02');
    expect(c[2], '18:18');
    expect(c[8], 'a|b');
    expect(parseFlexibleDate(c[0], c[2]), j(1405, 8, 2, 18, 18));
    expect(parseFlexibleDate(c[1], c[2]), j(1405, 8, 2, 18, 18));
    expect(parseFlexibleDate('hello'), isNull);
  });

  test('backup encrypt/decrypt and wrong password', () async {
    final plain = Uint8List.fromList(utf8.encode('SQLite format 3 ${'x' * 5000}'));
    final enc = await encryptBackup(plain, 'secret');
    expect(enc.length, lessThan(plain.length)); // compressed
    expect(await decryptBackup(enc, 'secret'), plain);
    await expectLater(decryptBackup(enc, 'wrong'), throwsA(isA<BackupError>()));
    final tampered = Uint8List.fromList(enc)..[20] ^= 1; // header is authenticated
    await expectLater(decryptBackup(tampered, 'secret'), throwsA(isA<BackupError>()));
    await expectLater(decryptBackup(Uint8List(10), 'secret'), throwsA(isA<BackupError>()));
  }, timeout: const Timeout(Duration(minutes: 2)));

  test('template builder learns a new bank format', () {
    // Invented layout with the sign inside the amount token, a word, and date+time.
    const sms = 'بانک نمونه\nواریز +5,000,000\nحساب 6037997712345678\n1405/08/02 14:30\nمانده 12,345,000';
    final text = normalizeSms(sms);
    final toks = tokenizeSms(text);
    final at = {for (final (i, t) in toks.indexed) t.text: i};
    final roles = {
      at['+5,000,000']!: TokenRole.amount,
      at['6037997712345678']!: TokenRole.account,
      at['1405/08/02']!: TokenRole.date,
      at['14:30']!: TokenRole.date,
      at['12,345,000']!: TokenRole.balance,
    };
    final r = buildTemplatePattern(toks, roles);
    expect(r.error, isNull);
    expect(patternHasDirection(r.pattern!), isTrue);
    final tpl = SmsTemplate(id: 'user.test', pattern: r.pattern!, verified: true);
    final p = tpl.parse(text, j(1405, 8, 2, 14, 31))!;
    expect(p.amount, 5000000);
    expect(p.balance, 12345000);
    expect(p.account, '6037997712345678');
    expect(p.occurredAt, j(1405, 8, 2, 14, 30));
    // Same format, different numbers, still parses.
    final other = normalizeSms('بانک نمونه\nواریز +9,000 \nحساب 6037997712345678\n1405/09/10 08:05\nمانده 1,000');
    expect(tpl.parse(other, j(1405, 9, 10, 8, 6))!.amount, 9000);
    expect(buildTemplatePattern(toks, {0: TokenRole.date}).error, 'بانک');
  });
}
