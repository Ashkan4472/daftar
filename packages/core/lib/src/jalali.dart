import 'package:shamsi_date/shamsi_date.dart';

const jalaliMonthsEn = [
  'Farvardin', 'Ordibehesht', 'Khordad', 'Tir', 'Mordad', 'Shahrivar',
  'Mehr', 'Aban', 'Azar', 'Dey', 'Bahman', 'Esfand',
];
const jalaliMonthsFa = [
  'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور',
  'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند',
];

/// Jalali year*100 + month, e.g. 140508. Indexed column for monthly reports.
int jalaliYm(DateTime t) {
  final j = Jalali.fromDateTime(t.toLocal());
  return j.year * 100 + j.month;
}

/// First instant of Jalali month [ym] and of the month after it (local time).
(DateTime start, DateTime end) jalaliMonthRange(int ym) {
  final y = ym ~/ 100, m = ym % 100;
  final start = Jalali(y, m, 1).toDateTime();
  final end = (m == 12 ? Jalali(y + 1, 1, 1) : Jalali(y, m + 1, 1)).toDateTime();
  return (start, end);
}

int nextYm(int ym) => ym % 100 == 12 ? (ym ~/ 100 + 1) * 100 + 1 : ym + 1;
int prevYm(int ym) => ym % 100 == 1 ? (ym ~/ 100 - 1) * 100 + 12 : ym - 1;

/// Builds a date from SMS month/day/time fields that lack a year.
///
/// The year comes from [received]; if the SMS month is after the received
/// month (Esfand transaction, Farvardin SMS) it belongs to the previous year.
DateTime inferSmsDate(
  DateTime received, {
  int? year,
  required int month,
  required int day,
  int hour = 0,
  int minute = 0,
}) {
  final r = Jalali.fromDateTime(received.toLocal());
  var y = year ?? r.year;
  if (y < 100) y += 1400; // two-digit Jalali years (e.g. 05/08/02)
  if (year == null && month > r.month) y -= 1;
  return Jalali(y, month, day, hour, minute).toDateTime();
}
