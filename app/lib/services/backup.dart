import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

import '../db/database.dart';
import '../repo.dart';
import '../state.dart';

Future<File> _dbFile() async => File(p.join((await getApplicationDocumentsDirectory()).path, 'daftar.sqlite'));

/// A consistent copy of the live database, compressed and encrypted.
// ponytail: whole file in memory and pure-Dart AES; stream it if backups pass ~200 MB.
Future<Uint8List> createBackup(AppDb db, String password) async {
  final tmp = File(p.join((await getTemporaryDirectory()).path, 'backup-${DateTime.now().microsecondsSinceEpoch}.sqlite'));
  await db.customStatement("VACUUM INTO '${tmp.path.replaceAll("'", "''")}'");
  try {
    final plain = await tmp.readAsBytes();
    final enc = await Isolate.run(() => encryptBackup(plain, password));
    await Repo(db).putSetting('last_backup', '${DateTime.now().millisecondsSinceEpoch}');
    return enc;
  } finally {
    if (await tmp.exists()) await tmp.delete();
  }
}

/// Replaces the current database with the backup. Keeps a safety copy first.
/// Throws [BackupError] for a wrong password or a file that is not a backup.
Future<void> restoreBackup(WidgetRef ref, Uint8List file, String password) async {
  final plain = await Isolate.run(() => decryptBackup(file, password));
  // Check it really is our database before touching anything.
  final probe = File(p.join((await getTemporaryDirectory()).path, 'probe-${DateTime.now().microsecondsSinceEpoch}.sqlite'));
  await probe.writeAsBytes(plain);
  try {
    final c = sql.sqlite3.open(probe.path, mode: sql.OpenMode.readOnly);
    final ok = c.select("SELECT name FROM sqlite_master WHERE type = 'table' AND name IN ('transactions','accounts','categories')").length == 3;
    c.close();
    if (!ok) throw BackupError('Not a Daftar database');
  } on sql.SqliteException {
    throw BackupError('Not a Daftar database');
  } finally {
    if (await probe.exists()) await probe.delete();
  }

  final target = await _dbFile();
  final db = ref.read(dbProvider);
  await db.close();
  final safety = File('${target.path}.before-restore');
  if (await target.exists()) await target.copy(safety.path);
  for (final ext in ['-wal', '-shm']) {
    final f = File('${target.path}$ext');
    if (await f.exists()) await f.delete();
  }
  await target.writeAsBytes(plain, flush: true);
  ref.invalidate(dbProvider); // reopens the new file; open migrates older backups
}
