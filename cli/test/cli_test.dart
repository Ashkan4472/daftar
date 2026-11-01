import 'dart:io';

import 'package:core/core.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

void main() {
  test('decrypt and export a backup end to end', () async {
    final dir = Directory.systemTemp.createTempSync('daftar-cli');
    addTearDown(() => dir.deleteSync(recursive: true));

    // A tiny database with the tables the exporter reads.
    final dbPath = '${dir.path}/app.sqlite';
    final db = sqlite3.open(dbPath)
      ..execute('''
        CREATE TABLE accounts (id INTEGER PRIMARY KEY, name TEXT);
        CREATE TABLE categories (id INTEGER PRIMARY KEY, name TEXT, parent_id INTEGER);
        CREATE TABLE tags (id INTEGER PRIMARY KEY, name TEXT);
        CREATE TABLE people (id INTEGER PRIMARY KEY, name TEXT);
        CREATE TABLE transaction_tags (transaction_id INTEGER, tag_id INTEGER);
        CREATE TABLE splits (transaction_id INTEGER, person_id INTEGER);
        CREATE TABLE transactions (id INTEGER PRIMARY KEY, account_id INTEGER, category_id INTEGER, amount INTEGER,
          occurred_at INTEGER, kind TEXT, note TEXT, balance_after INTEGER, deleted_at INTEGER);
        INSERT INTO accounts VALUES (1, 'Resalat 10.11228735.1');
        INSERT INTO categories VALUES (1, 'Transport', NULL), (2, 'Taxi', 1);
        INSERT INTO tags VALUES (1, 'work');
        INSERT INTO transaction_tags VALUES (1, 1);
        INSERT INTO transactions VALUES (1, 1, 2, -2500000, 1792858080, 'expense', 'taxi, "fast"', 825063832, NULL);
        INSERT INTO transactions VALUES (2, 1, NULL, -100, 1792858080, 'expense', 'trashed', NULL, 1792858090);
      ''');
    db.close();

    final enc = await encryptBackup(File(dbPath).readAsBytesSync(), 'pw1234');
    File('${dir.path}/b.daftar').writeAsBytesSync(enc);
    final env = {'DAFTAR_PASSWORD': 'pw1234'};

    final dec = await Process.run('dart', ['run', 'bin/daftar.dart', 'decrypt', '${dir.path}/b.daftar', '-o', '${dir.path}/out.sqlite'], environment: env);
    expect(dec.exitCode, 0, reason: '${dec.stderr}');
    expect(File('${dir.path}/out.sqlite').readAsBytesSync(), File(dbPath).readAsBytesSync());

    final exp = await Process.run('dart', ['run', 'bin/daftar.dart', 'export', '${dir.path}/b.daftar', '-o', '${dir.path}/out.csv'], environment: env);
    expect(exp.exitCode, 0, reason: '${exp.stderr}');
    final rows = parseCsv(File('${dir.path}/out.csv').readAsStringSync());
    expect(rows.length, 2); // header + the one live transaction
    expect(rows[1][3], 'Resalat 10.11228735.1');
    expect(rows[1][5], '-2500000');
    expect(rows[1][6], 'Transport');
    expect(rows[1][7], 'Taxi');
    expect(rows[1][8], 'work');
    expect(rows[1][9], 'taxi, "fast"');

    final bad = await Process.run('dart', ['run', 'bin/daftar.dart', 'decrypt', '${dir.path}/b.daftar', '-o', '${dir.path}/x'], environment: {'DAFTAR_PASSWORD': 'wrong'});
    expect(bad.exitCode, 1);
  }, timeout: const Timeout(Duration(minutes: 3)));
}
