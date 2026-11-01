import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'jalali.dart';

final _bidiMarks = RegExp('[‎‏‪-‮⁦-⁩]');

/// Canonical form of an SMS body: ASCII digits, Persian ی/ک, no bidi marks,
/// trimmed lines, single spaces. All templates are written against this.
String normalizeSms(String body) {
  final b = StringBuffer();
  for (final c in body.runes) {
    if (c >= 0x06F0 && c <= 0x06F9) {
      b.writeCharCode(c - 0x06F0 + 0x30);
    } else if (c >= 0x0660 && c <= 0x0669) {
      b.writeCharCode(c - 0x0660 + 0x30);
    } else {
      b.writeCharCode(switch (c) {
        0x064A => 0x06CC, // ي -> ی
        0x0649 => 0x06CC, // ى -> ی
        0x0643 => 0x06A9, // ك -> ک
        0x066C => 0x2C, // ٬ -> ,
        0x066B => 0x2E, // ٫ -> .
        0x2212 => 0x2D, // − -> -
        0x00A0 => 0x20,
        _ => c,
      });
    }
  }
  return b
      .toString()
      .replaceAll(_bidiMarks, '')
      .replaceAll('\r', '')
      .split('\n')
      .map((l) => l.replaceAll(RegExp(r'[ \t]+'), ' ').trim())
      .where((l) => l.isNotEmpty)
      .join('\n');
}

/// Stable dedupe key for a raw SMS.
String smsHash(String address, String body, DateTime receivedAt) => sha1
    .convert(utf8.encode('$address\n$body\n${receivedAt.millisecondsSinceEpoch}'))
    .toString();

final _expenseWords = RegExp(r'برداشت|خرید|کسر|پرداخت|انتقال از');
final _incomeWords = RegExp(r'واریز|انتقال به|سود|دریافت|بستانکار');

/// A regex with named groups, written against [normalizeSms] output.
///
/// Recognised groups: amount (required), sign, kind_word, balance, year,
/// month, day, hour, minute, account, card, desc.
class SmsTemplate {
  SmsTemplate({
    required this.id,
    required this.pattern,
    this.bankCode,
    this.sender,
    this.verified = false,
  }) : _re = RegExp(pattern, multiLine: false);

  final String id;
  final String pattern;
  final String? bankCode;

  /// Optional regex on the sender address; null matches any sender.
  final String? sender;
  final bool verified;
  final RegExp _re;

  ParsedSms? parse(String normalized, DateTime received) {
    final m = _re.firstMatch(normalized);
    if (m == null) return null;
    String? g(String name) =>
        m.groupNames.contains(name) ? m.namedGroup(name) : null;

    final amount = parseAmount(g('amount'));
    if (amount == null || amount == 0) return null;
    final sign = g('sign');
    final kindWord = g('kind_word');
    int dir;
    if (sign != null) {
      dir = sign == '-' ? -1 : 1;
    } else if (kindWord != null && _expenseWords.hasMatch(kindWord)) {
      dir = -1;
    } else if (kindWord != null && _incomeWords.hasMatch(kindWord)) {
      dir = 1;
    } else {
      return null;
    }

    final month = int.tryParse(g('month') ?? '');
    final day = int.tryParse(g('day') ?? '');
    final occurredAt = month != null && day != null
        ? inferSmsDate(
            received,
            year: int.tryParse(g('year') ?? ''),
            month: month,
            day: day,
            hour: int.tryParse(g('hour') ?? '') ?? 0,
            minute: int.tryParse(g('minute') ?? '') ?? 0,
          )
        : received;

    return ParsedSms(
      amount: dir * amount,
      balance: parseAmount(g('balance')),
      occurredAt: occurredAt,
      account: g('account') ?? g('card'),
      description: g('desc'),
      templateId: id,
      needsReview: !verified,
    );
  }
}

class ParsedSms {
  const ParsedSms({
    required this.amount,
    required this.occurredAt,
    required this.templateId,
    this.balance,
    this.account,
    this.description,
    this.needsReview = false,
  });

  /// Signed Rial: negative = money out.
  final int amount;
  final int? balance;
  final DateTime occurredAt;
  final String? account;
  final String? description;
  final String templateId;
  final bool needsReview;

  @override
  String toString() =>
      'ParsedSms($amount, bal=$balance, $occurredAt, acc=$account, $templateId)';
}

/// "1,900,000" / "-22,975" -> int. Null when not a number.
int? parseAmount(String? s) {
  if (s == null) return null;
  final neg = s.trim().startsWith('-');
  final v = int.tryParse(s.replaceAll(RegExp(r'[^\d]'), ''));
  return v == null ? null : (neg ? -v : v);
}

/// Built-in templates. Only `verified` ones are confirmed against real SMS;
/// the rest are best guesses that mark their transactions for review.
final builtinTemplates = <SmsTemplate>[
  // Resalat: "10.11228735.1\n-1,900,000\n07/30_09:57\nمانده: 22,975,232"
  SmsTemplate(
    id: 'resalat.v1',
    bankCode: 'resalat',
    verified: true,
    pattern: r'^(?<account>\d+(?:\.\d+)+)\n'
        r'(?<sign>[+-])(?<amount>[\d,]+)\n'
        r'(?<month>\d{1,2})/(?<day>\d{1,2})_(?<hour>\d{1,2}):(?<minute>\d{2})\n'
        r'مانده ?: ?(?<balance>-?[\d,]+)$',
  ),
];

final _hBalance = RegExp(r'(?:مانده|موجودی)[^\d\n-]{0,12}(-?[\d,]{2,})');
final _hSigned = RegExp(r'(?:^|[\s:])([+-])([\d,]{3,})(?=\s|$)', multiLine: true);
final _hKeyword = RegExp(
    r'(برداشت|خرید|کسر|پرداخت|انتقال از|واریز|انتقال به|سود|دریافت|مبلغ)'
    r'[^\d\n]{0,15}([\d,]{3,})');
final _hDate = RegExp(r'(?:(\d{2,4})/)?(\d{1,2})/(\d{1,2})');
final _hTime = RegExp(r'(\d{1,2}):(\d{2})');

/// Fallback for unknown formats. Every result needs review.
ParsedSms? heuristicParse(String normalized, DateTime received) {
  int? amount;
  final s = _hSigned.firstMatch(normalized);
  if (s != null) {
    amount = parseAmount(s[2]);
    if (amount != null && s[1] == '-') amount = -amount;
  } else {
    final k = _hKeyword.firstMatch(normalized);
    if (k == null) return null;
    amount = parseAmount(k[2]);
    final word = k[1]!;
    final dir = _expenseWords.hasMatch(word)
        ? -1
        : _incomeWords.hasMatch(word)
            ? 1
            : _expenseWords.hasMatch(normalized)
                ? -1
                : _incomeWords.hasMatch(normalized)
                    ? 1
                    : 0;
    if (dir == 0 || amount == null) return null;
    amount *= dir;
  }
  if (amount == null || amount == 0) return null;

  var at = received;
  final d = _hDate.firstMatch(normalized);
  final month = int.tryParse(d?[2] ?? ''), day = int.tryParse(d?[3] ?? '');
  if (month != null && day != null && month >= 1 && month <= 12 && day >= 1 && day <= 31) {
    final t = _hTime.firstMatch(normalized);
    at = inferSmsDate(
      received,
      year: int.tryParse(d?[1] ?? ''),
      month: month,
      day: day,
      hour: int.tryParse(t?[1] ?? '') ?? 0,
      minute: int.tryParse(t?[2] ?? '') ?? 0,
    );
  }
  return ParsedSms(
    amount: amount,
    balance: parseAmount(_hBalance.firstMatch(normalized)?[1]),
    occurredAt: at,
    templateId: 'heuristic',
    needsReview: true,
  );
}

/// Tries sender-specific templates first, then the rest, then the heuristic.
ParsedSms? parseSms(
  String address,
  String body,
  DateTime received, {
  List<SmsTemplate>? templates,
  bool useHeuristic = true,
}) {
  final text = normalizeSms(body);
  final all = templates ?? builtinTemplates;
  bool forSender(SmsTemplate t) =>
      t.sender != null && RegExp(t.sender!).hasMatch(address);
  for (final t in [...all.where(forSender), ...all.where((t) => t.sender == null)]) {
    final p = t.parse(text, received);
    if (p != null) return p;
  }
  return useHeuristic ? heuristicParse(text, received) : null;
}

/// Rial the bank balance moved that no SMS explains. 0 = consistent.
int balanceGap({required int previousBalance, required int amount, required int balance}) =>
    balance - (previousBalance + amount);
