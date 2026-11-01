import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:sqlite3/sqlite3.dart';

const usage = '''
daftar - read Daftar backups on your computer

  daftar decrypt <backup.daftar> -o <out.sqlite>
  daftar export  <backup.daftar> -o <out.csv> [--from 1405/01/01] [--to 1405/06/31]

The password is asked on the terminal (or set DAFTAR_PASSWORD).''';

Future<void> main(List<String> args) async {
  if (args.length < 2 || !{'decrypt', 'export'}.contains(args.first)) {
    stderr.writeln(usage);
    exit(64);
  }
  final cmd = args.first, input = args[1];
  String? opt(String name) {
    final i = args.indexOf(name);
    return i >= 0 && i + 1 < args.length ? args[i + 1] : null;
  }

  final out = opt('-o');
  if (out == null) {
    stderr.writeln('Missing -o <output file>\n$usage');
    exit(64);
  }
  final password = Platform.environment['DAFTAR_PASSWORD'] ?? _ask('Backup password: ');
  final Uint8List db;
  try {
    db = await decryptBackup(await File(input).readAsBytes(), password);
  } on BackupError catch (e) {
    stderr.writeln(e.message);
    exit(1);
  }

  if (cmd == 'decrypt') {
    await File(out).writeAsBytes(db);
    stdout.writeln('Wrote $out (${db.length} bytes). Open it with any SQLite tool.');
    return;
  }

  final tmp = File('${Directory.systemTemp.path}/daftar-${DateTime.now().microsecondsSinceEpoch}.sqlite');
  await tmp.writeAsBytes(db);
  try {
    final conn = sqlite3.open(tmp.path, mode: OpenMode.readOnly);
    final from = parseFlexibleDate(opt('--from') ?? '1300/01/01')!;
    final to = (parseFlexibleDate(opt('--to') ?? '1600/01/01')!).add(const Duration(days: 1));
    final rows = conn.select('''
      SELECT t.id, t.occurred_at, a.name AS account, t.kind, t.amount, t.note, t.balance_after,
             c.name AS cat, p.name AS parent,
             (SELECT group_concat(g.name, '|') FROM transaction_tags tt JOIN tags g ON g.id = tt.tag_id WHERE tt.transaction_id = t.id) AS tags,
             (SELECT group_concat(pe.name, '|') FROM splits s JOIN people pe ON pe.id = s.person_id WHERE s.transaction_id = t.id) AS people
      FROM transactions t
      JOIN accounts a ON a.id = t.account_id
      LEFT JOIN categories c ON c.id = t.category_id
      LEFT JOIN categories p ON p.id = c.parent_id
      WHERE t.deleted_at IS NULL AND t.occurred_at >= ? AND t.occurred_at < ?
      ORDER BY t.occurred_at, t.id
    ''', [from.millisecondsSinceEpoch ~/ 1000, to.millisecondsSinceEpoch ~/ 1000]);
    // Category-split parts (backups from before the feature have no such table).
    final parts = <int, List<(String?, String?, int)>>{};
    if (conn.select("SELECT 1 FROM sqlite_master WHERE name = 'tx_parts'").isNotEmpty) {
      for (final p in conn.select('''
        SELECT x.transaction_id AS t, c.name AS cat, pc.name AS parent, x.amount AS amount
        FROM tx_parts x JOIN categories c ON c.id = x.category_id LEFT JOIN categories pc ON pc.id = c.parent_id
        ORDER BY x.amount DESC''')) {
        parts.putIfAbsent(p['t'] as int, () => []).add((p['cat'] as String?, p['parent'] as String?, p['amount'] as int));
      }
    }
    final exported = <ExportRow>[];
    for (final r in rows) {
      final amount = r['amount'] as int;
      final split = parts[r['id'] as int];
      // A sub-category's parent is the "category"; the child goes in "subcategory".
      for (final (cat, parent, partAmount) in split ?? [(r['cat'] as String?, r['parent'] as String?, amount.abs())]) {
        exported.add(ExportRow(
          at: DateTime.fromMillisecondsSinceEpoch((r['occurred_at'] as int) * 1000),
          account: r['account'] as String,
          kind: r['kind'] as String,
          amount: split == null ? amount : (amount < 0 ? -partAmount : partAmount),
          category: (parent ?? cat) ?? '',
          subcategory: parent == null ? '' : cat ?? '',
          tags: ((r['tags'] as String?) ?? '').split('|').where((s) => s.isNotEmpty).toList(),
          note: r['note'] as String,
          people: ((r['people'] as String?) ?? '').split('|').where((s) => s.isNotEmpty).toList(),
          balanceAfter: r['balance_after'] as int?,
          splitOf: split == null ? '' : '${r['id']}:$amount',
        ));
      }
    }
    final csv = exportCsv(exported);
    await File(out).writeAsString(csv);
    stdout.writeln('Wrote $out (${exported.length} rows).');
    conn.close();
  } finally {
    if (await tmp.exists()) await tmp.delete();
  }
}

String _ask(String prompt) {
  stderr.write(prompt);
  stdin.echoMode = false;
  final pw = stdin.readLineSync() ?? '';
  stdin.echoMode = true;
  stderr.writeln();
  return pw;
}
