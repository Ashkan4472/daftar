import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../services/jobs.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/format.dart';
import '../ui/widgets.dart';
import 'recurring.dart';

class _Pending {
  const _Pending(this.p, this.out, this.inn, this.outAcc, this.inAcc);
  final TransferProposal p;
  final Transaction out, inn;
  final Account outAcc, inAcc;
}

final _pendingProvider = StreamProvider<List<_Pending>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.transferProposals)..where((p) => p.status.equals('pending'))).watch().asyncMap((rows) async {
    final txs = {for (final t in await db.select(db.transactions).get()) t.id: t};
    final accs = {for (final a in await db.select(db.accounts).get()) a.id: a};
    return [
      for (final p in rows)
        if (txs[p.outTxId] case final o? when txs[p.inTxId] != null && accs[o.accountId] != null && accs[txs[p.inTxId]!.accountId] != null)
          _Pending(p, o, txs[p.inTxId]!, accs[o.accountId]!, accs[txs[p.inTxId]!.accountId]!),
    ];
  });
});

/// "Is this a transfer between your accounts?" cards on Home.
class TransferCards extends ConsumerWidget {
  const TransferCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final list = ref.watch(_pendingProvider).value ?? const <_Pending>[];
    final db = ref.read(dbProvider);
    return Column(children: [
      for (final p in list.take(2))
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Icon(appIcon('arrows-left-right'), color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l.transferTitle, style: Theme.of(context).textTheme.titleSmall)),
                ]),
                const SizedBox(height: 4),
                Text(l.transferBody('\u2066${prefs.money(p.inn.amount)}\u2069', p.outAcc.name, p.inAcc.name), style: context.mutedStyle),
                Text(fmtDate(prefs, p.out.occurredAt), style: context.mutedStyle),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: FilledButton(onPressed: () => confirmTransfer(db, p.p), child: Text(l.yesTransfer))),
                  const SizedBox(width: 12),
                  OutlinedButton(onPressed: () => dismissTransfer(db, p.p), style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)), child: Text(l.notTransfer)),
                ]),
              ]),
            ),
          ),
        ),
    ]);
  }
}

/// Confirmed repeating charges due in the next 7 days.
class UpcomingCard extends ConsumerWidget {
  const UpcomingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final soon = DateTime.now().add(const Duration(days: 7));
    final list = (ref.watch(recurringsProvider).value ?? const <(Recurring, Account)>[])
        .where((e) => e.$1.confirmed && e.$1.nextDue.isBefore(soon))
        .toList();
    if (list.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(l.upcoming),
      Card(
        child: Column(children: [
          for (final (r, a) in list)
            ListTile(
              leading: Icon(appIcon('calendar-check'), color: context.money.warning),
              title: Text(fmtDate(prefs, r.nextDue)),
              subtitle: Text(a.name),
              trailing: Amount(r.expectedAmount),
            ),
        ]),
      ),
    ]);
  }
}
