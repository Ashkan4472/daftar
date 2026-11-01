import 'sms.dart';

enum TokenRole { amount, balance, date, account, word }

class SmsToken {
  const SmsToken(this.text, this.line);
  final String text;
  final int line;
}

/// Splits a normalized SMS into words, remembering which line each is on.
List<SmsToken> tokenizeSms(String normalized) => [
      for (final (li, line) in normalized.split('\n').indexed)
        for (final w in line.split(' ').where((w) => w.isNotEmpty)) SmsToken(w, li),
    ];

final _signedAmount = RegExp(r'^([+-]?)([\d,]+)(.*)$');
final _fullDate = RegExp(r'^(?:(\d{2,4})([/.-]))?(\d{1,2})([/.-])(\d{1,2})(?:([_T-])(\d{1,2}):(\d{2}))?$');
final _timeOnly = RegExp(r'^(\d{1,2}):(\d{2})$');
const _words = ['برداشت', 'خرید', 'کسر', 'پرداخت', 'واریز', 'دریافت', 'سود'];

/// Builds a [SmsTemplate] pattern from the tokens the user tagged.
/// Untagged tokens with digits become `\S+` (they vary), others stay literal.
/// [error] holds the token that could not be understood in its role.
({String? pattern, String? error}) buildTemplatePattern(List<SmsToken> toks, Map<int, TokenRole> roles) {
  final b = StringBuffer('^');
  for (var i = 0; i < toks.length; i++) {
    final t = toks[i];
    if (i > 0) b.write(toks[i - 1].line == t.line ? ' ' : r'\n');
    switch (roles[i]) {
      case TokenRole.amount:
        final m = _signedAmount.firstMatch(t.text);
        if (m == null) return (pattern: null, error: t.text);
        b.write('${m[1]!.isEmpty ? '' : r'(?<sign>[+-])'}(?<amount>[\\d,]+)${RegExp.escape(m[3]!)}');
      case TokenRole.balance:
        if (!RegExp(r'\d').hasMatch(t.text)) return (pattern: null, error: t.text);
        b.write(r'(?<balance>-?[\d,]+)');
      case TokenRole.account:
        b.write(r'(?<account>\S+)');
      case TokenRole.word:
        b.write('(?<kind_word>${{RegExp.escape(t.text), ..._words}.join('|')})');
      case TokenRole.date:
        final d = _fullDate.firstMatch(t.text);
        if (d != null) {
          if (d[1] != null) b.write('(?<year>\\d{2,4})${RegExp.escape(d[2]!)}');
          b.write('(?<month>\\d{1,2})${RegExp.escape(d[4]!)}(?<day>\\d{1,2})');
          if (d[7] != null) b.write('${RegExp.escape(d[6]!)}(?<hour>\\d{1,2}):(?<minute>\\d{2})');
        } else if (_timeOnly.hasMatch(t.text)) {
          b.write(r'(?<hour>\d{1,2}):(?<minute>\d{2})');
        } else {
          return (pattern: null, error: t.text);
        }
      case null:
        b.write(RegExp(r'\d').hasMatch(t.text) ? r'\S+' : RegExp.escape(t.text));
    }
  }
  b.write(r'$');
  return (pattern: b.toString(), error: null);
}

/// True when the pattern says whether money goes out or comes in.
bool patternHasDirection(String pattern) => pattern.contains('(?<sign>') || pattern.contains('(?<kind_word>');
