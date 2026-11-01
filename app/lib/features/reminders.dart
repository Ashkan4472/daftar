import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../db/database.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../services/notifier.dart';
import '../state.dart';
import '../ui/format.dart';

final _remindersProvider = StreamProvider.family<List<Reminder>, (ReminderTarget, int)>((ref, k) {
  final db = ref.watch(dbProvider);
  return (db.select(db.reminders)
        ..where((r) => r.targetType.equals(k.$1.name) & r.targetId.equals(k.$2) & r.done.equals(false))
        ..orderBy([(r) => OrderingTerm.asc(r.at)]))
      .watch();
});

/// Lists a target's reminders and lets the user add one.
class ReminderButton extends ConsumerWidget {
  const ReminderButton({super.key, required this.targetType, required this.targetId, this.defaultAt});
  final ReminderTarget targetType;
  final int targetId;
  final DateTime? defaultAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final list = ref.watch(_remindersProvider((targetType, targetId))).value ?? const <Reminder>[];
    final db = ref.read(dbProvider);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final r in list)
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Icon(appIcon('bell-ringing')),
          title: Text('${fmtDate(prefs, r.at)} · ${fmtTime(prefs, r.at)}'),
          subtitle: r.body.isEmpty ? null : Text(r.body),
          trailing: IconButton(
            tooltip: l.removeReminder,
            icon: Icon(appIcon('x')),
            onPressed: () async {
              await cancelReminder(r.id);
              await (db.delete(db.reminders)..where((x) => x.id.equals(r.id))).go();
            },
          ),
        ),
      OutlinedButton.icon(
        onPressed: () => _add(context, ref),
        icon: Icon(appIcon('bell-simple-plus')),
        label: Text(l.remindMe),
        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      ),
    ]);
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final db = ref.read(dbProvider);
    final messenger = ScaffoldMessenger.of(context);
    final base = defaultAt ?? DateTime.now().add(const Duration(days: 1));
    final j = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.fromDateTime(base),
      firstDate: Jalali.now(),
      lastDate: Jalali.now().addYears(5),
      helpText: l.pickReminderTime,
    );
    if (j == null || !context.mounted) return;
    final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
    if (t == null || !context.mounted) return;
    final d = j.toDateTime();
    final at = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    if (at.isBefore(DateTime.now())) {
      messenger.showSnackBar(SnackBar(content: Text(l.reminderInPast)));
      return;
    }
    final text = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.remindMe),
        content: TextField(controller: text, autofocus: true, decoration: InputDecoration(hintText: l.reminderText)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.save)),
        ],
      ),
    );
    if (ok != true) return;
    await requestNotificationPermission();
    if (!await exactAlarmsAllowed()) {
      messenger.showSnackBar(SnackBar(content: Text(l.exactAlarmHint), action: SnackBarAction(label: l.settings, onPressed: requestExactAlarms)));
    }
    final id = await db.into(db.reminders).insert(RemindersCompanion.insert(targetType: targetType, targetId: targetId, at: at, body: Value(text.text.trim())));
    final row = await (db.select(db.reminders)..where((r) => r.id.equals(id))).getSingle();
    await scheduleReminder(row, l.reminderTitle);
    messenger.showSnackBar(SnackBar(content: Text(l.reminderSet)));
  }
}
