import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/format.dart';
import '../ui/widgets.dart';
import 'reminders.dart';

final recurringsProvider = StreamProvider<List<(Recurring, Account)>>((ref) {
  final db = ref.watch(dbProvider);
  final q = db.select(db.recurrings).join([innerJoin(db.accounts, db.accounts.id.equalsExp(db.recurrings.accountId))])
    ..where(db.recurrings.dismissed.equals(false))
    ..orderBy([OrderingTerm.desc(db.recurrings.confirmed), OrderingTerm.asc(db.recurrings.nextDue)]);
  return q.watch().map((rs) => [for (final r in rs) (r.readTable(db.recurrings), r.readTable(db.accounts))]);
});

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final list = ref.watch(recurringsProvider).value ?? const <(Recurring, Account)>[];
    final db = ref.read(dbProvider);
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(l.recurringTitle)),
      body: list.isEmpty
          ? EmptyState(icon: 'repeat', title: l.recurringEmpty, hint: l.recurringEmptyHint)
          : ListView(padding: const EdgeInsets.all(16), children: [
              for (final (r, a) in list)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        Row(children: [
                          Icon(appIcon(r.confirmed ? 'calendar-check' : 'repeat'), color: r.confirmed ? context.money.income : context.money.warning),
                          const SizedBox(width: 12),
                          Expanded(child: Amount(r.expectedAmount, style: t.titleLarge)),
                          Text(a.name, style: context.mutedStyle),
                        ]),
                        const SizedBox(height: 4),
                        Text(prefs.digits(l.recurringEvery(r.periodDays)), style: context.mutedStyle),
                        Text(l.recurringNext(fmtDate(prefs, r.nextDue)), style: t.bodyMedium),
                        const SizedBox(height: 12),
                        if (!r.confirmed)
                          Row(children: [
                            Expanded(child: FilledButton(onPressed: () => (db.update(db.recurrings)..where((x) => x.id.equals(r.id))).write(const RecurringsCompanion(confirmed: Value(true))), child: Text(l.confirmRecurring))),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () => (db.update(db.recurrings)..where((x) => x.id.equals(r.id))).write(const RecurringsCompanion(dismissed: Value(true))),
                              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
                              child: Text(l.dismissRecurring),
                            ),
                          ])
                        else
                          ReminderButton(targetType: ReminderTarget.recurring, targetId: r.id, defaultAt: r.nextDue.subtract(const Duration(days: 1))),
                      ]),
                    ),
                  ),
                ),
            ]),
    );
  }
}
