import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../db/database.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';

final _plugin = FlutterLocalNotificationsPlugin();

/// Payload of the notification the user just tapped; the app shell reacts to it.
final notificationTaps = ValueNotifier<String?>(null);

bool _inited = false;

Future<void> initNotifications() async {
  if (_inited) return;
  _inited = true;
  tzdata.initializeTimeZones();
  await _plugin.initialize(
    settings: const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
    onDidReceiveNotificationResponse: (r) => notificationTaps.value = r.payload,
    onDidReceiveBackgroundNotificationResponse: notificationBackground,
  );
}

/// The launch payload if the app was started by tapping a notification.
Future<String?> launchPayload() async {
  await initNotifications();
  final d = await _plugin.getNotificationAppLaunchDetails();
  return d?.didNotificationLaunchApp == true ? d!.notificationResponse?.payload : null;
}

AndroidFlutterLocalNotificationsPlugin? get _android =>
    _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

Future<bool> requestNotificationPermission() async {
  await initNotifications();
  return await _android?.requestNotificationsPermission() ?? false;
}

Future<bool> exactAlarmsAllowed() async => await _android?.canScheduleExactNotifications() ?? false;

Future<void> requestExactAlarms() async => _android?.requestExactAlarmsPermission();

Future<AppLocalizations> l10nFor(Repo repo) async =>
    lookupAppLocalizations(Locale(await repo.setting('lang') ?? 'en'));

/// Logs to the in-app inbox and shows a system notification.
/// Returns false when the user switched this kind off.
Future<bool> notify(
  AppDb db, {
  required String kind,
  required String title,
  String body = '',
  String? payload,
  bool withActions = false,
}) async {
  final repo = Repo(db);
  if (await repo.setting('notif_$kind') == 'false') return false;
  final l = await l10nFor(repo);
  final id = await db.into(db.inboxItems).insert(InboxItemsCompanion.insert(
        kind: kind, title: title, body: Value(body), payload: Value(payload)));
  await initNotifications();
  await _plugin.show(
    id: id,
    title: title,
    body: body,
    payload: payload,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        kind,
        kind,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(body),
        actions: withActions
            ? [
                AndroidNotificationAction('categorize', l.notifActionCategorize, showsUserInterface: true),
                AndroidNotificationAction('note', l.notifActionNote,
                    inputs: [AndroidNotificationActionInput(label: l.notifNoteLabel)]),
                AndroidNotificationAction('mark', l.notifActionMark),
              ]
            : null,
      ),
    ),
  );
  return true;
}

/// Runs when the user uses Note/Mark on a notification while the app is closed.
@pragma('vm:entry-point')
Future<void> notificationBackground(NotificationResponse r) async {
  final payload = r.payload ?? '';
  if (!payload.startsWith('tx:')) return;
  final id = int.tryParse(payload.substring(3));
  if (id == null) return;
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  final db = AppDb();
  final repo = Repo(db);
  try {
    if (r.actionId == 'mark') await repo.setMarked([id], true);
    if (r.actionId == 'note' && (r.input ?? '').trim().isNotEmpty) await repo.setNote(id, r.input!.trim());
  } finally {
    await db.close();
  }
}

// ---- reminders ------------------------------------------------------------------------

const _reminderBase = 1000000;

String reminderPayload(Reminder r) => switch (r.targetType) {
      ReminderTarget.transaction => 'tx:${r.targetId}',
      ReminderTarget.person => 'person:${r.targetId}',
      ReminderTarget.recurring => 'recurring',
    };

Future<void> scheduleReminder(Reminder r, String title) async {
  if (r.done || r.at.isBefore(DateTime.now())) return;
  await initNotifications();
  final exact = await exactAlarmsAllowed();
  await _plugin.zonedSchedule(
    id: _reminderBase + r.id,
    title: title,
    body: r.body,
    payload: reminderPayload(r),
    scheduledDate: tz.TZDateTime.from(r.at, tz.UTC),
    androidScheduleMode: exact ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.inexactAllowWhileIdle,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails('reminder', 'reminder', importance: Importance.high, priority: Priority.high),
    ),
  );
}

Future<void> cancelReminder(int id) async {
  await initNotifications();
  await _plugin.cancel(id: _reminderBase + id);
}

/// On app start: re-schedule future reminders (survives reboots/updates) and
/// move reminders that already fired into the inbox.
Future<void> syncReminders(AppDb db) async {
  final repo = Repo(db);
  final l = await l10nFor(repo);
  final rows = await (db.select(db.reminders)..where((r) => r.done.equals(false))).get();
  for (final r in rows) {
    if (r.at.isAfter(DateTime.now())) {
      await scheduleReminder(r, l.reminderTitle);
    } else {
      await db.into(db.inboxItems).insert(InboxItemsCompanion.insert(
          kind: 'reminder', title: l.reminderTitle, body: Value(r.body), payload: Value(reminderPayload(r))));
      await (db.update(db.reminders)..where((x) => x.id.equals(r.id))).write(const RemindersCompanion(done: Value(true)));
    }
  }
}
