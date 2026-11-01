import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../db/database.dart';
import '../repo.dart';
import '../sms/importer.dart';
import '../state.dart';
import 'jobs.dart';
import 'notifier.dart';

/// Imports SMS received since the last sync, notifies about each new
/// transaction, then runs the follow-up jobs. Returns the number added.
///
/// The first call only records "now": history is brought in by the user
/// through the import screen.
Future<int> syncSms(AppDb db) async {
  final repo = Repo(db);
  final now = DateTime.now();
  final last = int.tryParse(await repo.setting('last_sync') ?? '');
  if (last == null) {
    await repo.putSetting('last_sync', '${now.millisecondsSinceEpoch}');
    return 0;
  }
  final maxId = db.transactions.id.max();
  final before = (await (db.selectOnly(db.transactions)..addColumns([maxId])).getSingle()).read(maxId) ?? 0;
  try {
    // 2 minutes of overlap: the inbox row can land after the broadcast.
    await SmsImporter(db).importRange(
      DateTime.fromMillisecondsSinceEpoch(last).subtract(const Duration(minutes: 2)),
      now.add(const Duration(minutes: 1)),
    );
  } on PlatformException {
    return 0; // no SMS permission yet
  }
  await repo.putSetting('last_sync', '${now.millisecondsSinceEpoch}');

  final fresh = await (db.select(db.transactions)..where((t) => t.id.isBiggerThanValue(before) & t.source.equals(TxSource.sms.name))).get();
  if (fresh.isNotEmpty) {
    final l = await l10nFor(repo);
    final prefs = Prefs(lang: await repo.setting('lang') ?? 'en', toman: await repo.setting('toman') != 'false');
    final accounts = {for (final a in await db.select(db.accounts).get()) a.id: a};
    for (final t in fresh) {
      await notify(db,
          kind: 'capture',
          title: l.notifCaptureTitle(prefs.money(t.amount, signed: true), accounts[t.accountId]?.name ?? ''),
          body: l.notifCaptureBody,
          payload: 'tx:${t.id}',
          withActions: true);
    }
  }
  await afterImport(db);
  return fresh.length;
}
