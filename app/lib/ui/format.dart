import 'package:core/core.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../state.dart';

String fmtDate(Prefs p, DateTime d) {
  final j = Jalali.fromDateTime(d);
  final months = p.persian ? jalaliMonthsFa : jalaliMonthsEn;
  return p.digits('${j.day} ${months[j.month - 1]} ${j.year}');
}

String fmtDayMonth(Prefs p, DateTime d) {
  final j = Jalali.fromDateTime(d);
  final months = p.persian ? jalaliMonthsFa : jalaliMonthsEn;
  return p.digits('${j.day} ${months[j.month - 1]}');
}

String fmtTime(Prefs p, DateTime d) =>
    p.digits('${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}');

String fmtGregorian(DateTime d) => DateFormat.yMMMd('en').format(d);

/// "1,234,567" as you type; accepts Persian digits.
class MoneyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue next) {
    final digits = normalizeSms(next.text).replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return const TextEditingValue();
    final capped = digits.length > 15 ? digits.substring(0, 15) : digits;
    final f = formatMoney(int.parse(capped));
    return TextEditingValue(text: f, selection: TextSelection.collapsed(offset: f.length));
  }
}

/// Typed digits -> integer in display units (Rial or Toman).
int? parseMoney(String s) {
  final digits = normalizeSms(s).replaceAll(RegExp(r'\D'), '');
  return digits.isEmpty ? null : int.parse(digits);
}
