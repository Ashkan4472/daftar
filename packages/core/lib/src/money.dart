const _faDigits = '۰۱۲۳۴۵۶۷۸۹';

/// Converts ASCII digits in [s] to Persian digits.
String toPersianDigits(String s) =>
    s.replaceAllMapped(RegExp(r'\d'), (m) => _faDigits[int.parse(m[0]!)]);

/// Formats an integer Rial [amount] with thousands separators.
///
/// With [toman] the value is divided by 10 (rounded). With [signed] a
/// leading `+` / `−` is always shown. [persian] switches to Persian digits
/// and the Persian thousands separator.
String formatMoney(
  int amount, {
  bool toman = false,
  bool signed = false,
  bool persian = false,
}) {
  var v = toman ? (amount / 10).round() : amount;
  final neg = v < 0;
  v = v.abs();
  final digits = v.toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(persian ? '٬' : ',');
    buf.write(digits[i]);
  }
  var out = buf.toString();
  if (persian) out = toPersianDigits(out);
  if (neg) return '−$out';
  return signed && v != 0 ? '+$out' : out;
}
