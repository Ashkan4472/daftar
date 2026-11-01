import 'package:shamsi_date/shamsi_date.dart';

/// UTF-8 BOM so Excel opens Persian text correctly.
const csvBom = '﻿';

String csvEscape(String s) =>
    s.contains(RegExp(r'[",\n\r]')) ? '"${s.replaceAll('"', '""')}"' : s;

String toCsv(List<List<String>> rows) => '${rows.map((r) => r.map(csvEscape).join(',')).join('\r\n')}\r\n';

/// RFC 4180 parser: quoted fields, escaped quotes, CRLF/LF, leading BOM.
List<List<String>> parseCsv(String text) {
  if (text.startsWith(csvBom)) text = text.substring(1);
  final rows = <List<String>>[];
  var row = <String>[];
  final f = StringBuffer();
  var quoted = false, any = false;
  void endField() {
    row.add(f.toString());
    f.clear();
  }

  for (var i = 0; i < text.length; i++) {
    final c = text[i];
    if (quoted) {
      if (c == '"') {
        if (i + 1 < text.length && text[i + 1] == '"') {
          f.write('"');
          i++;
        } else {
          quoted = false;
        }
      } else {
        f.write(c);
      }
    } else if (c == '"') {
      quoted = true;
      any = true;
    } else if (c == ',') {
      endField();
      any = true;
    } else if (c == '\n' || c == '\r') {
      if (c == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
      if (any || f.isNotEmpty) {
        endField();
        rows.add(row);
      }
      row = <String>[];
      any = false;
    } else {
      f.write(c);
      any = true;
    }
  }
  if (any || f.isNotEmpty) {
    endField();
    rows.add(row);
  }
  return rows;
}

const exportHeader = [
  'date_jalali', 'date_gregorian', 'time', 'account', 'kind', 'amount_rial',
  'category', 'subcategory', 'tags', 'note', 'people', 'balance_after',
];

class ExportRow {
  const ExportRow({
    required this.at,
    required this.account,
    required this.kind,
    required this.amount,
    this.category = '',
    this.subcategory = '',
    this.tags = const [],
    this.note = '',
    this.people = const [],
    this.balanceAfter,
  });
  final DateTime at;
  final String account, kind, category, subcategory, note;
  final int amount;
  final int? balanceAfter;
  final List<String> tags, people;

  List<String> toCells() {
    final j = Jalali.fromDateTime(at);
    String p2(int n) => n.toString().padLeft(2, '0');
    return [
      '${j.year}/${p2(j.month)}/${p2(j.day)}',
      '${at.year}-${p2(at.month)}-${p2(at.day)}',
      '${p2(at.hour)}:${p2(at.minute)}',
      account, kind, '$amount', category, subcategory,
      tags.join('|'), note, people.join('|'), balanceAfter?.toString() ?? '',
    ];
  }
}

/// Parses "2026-10-24", "1405/08/02" or "1405-08-02" (+ optional time) to a local DateTime.
/// Years below 1700 are Jalali. Returns null when it does not look like a date.
DateTime? parseFlexibleDate(String date, [String time = '']) {
  final m = RegExp(r'^(\d{2,4})[-/.](\d{1,2})[-/.](\d{1,2})').firstMatch(date.trim());
  if (m == null) return null;
  var y = int.parse(m[1]!);
  final mo = int.parse(m[2]!), d = int.parse(m[3]!);
  final t = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(time.isEmpty ? date : time);
  final h = int.tryParse(t?[1] ?? '') ?? 0, mi = int.tryParse(t?[2] ?? '') ?? 0;
  if (mo < 1 || mo > 12 || d < 1 || d > 31) return null;
  if (y < 100) y += 1400;
  if (y < 1700) {
    return Jalali(y, mo, d, h, mi).toDateTime();
  }
  return DateTime(y, mo, d, h, mi);
}

/// Shared by the app and CLI so both write identical files.
String exportCsv(Iterable<ExportRow> rows) =>
    csvBom + toCsv([exportHeader, for (final r in rows) r.toCells()]);
