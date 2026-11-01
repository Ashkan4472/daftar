import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/seed.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/widgets.dart';
import 'recurring.dart';
import 'report_data.dart';
import 'transactions.dart';

/// Purchases under this many Rial count as "small" (50,000 Toman).
const smallLimitRial = 500000;

class LeaksScreen extends ConsumerWidget {
  const LeaksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final ym = ref.watch(monthProvider);
    final leaks = ref.watch(leaksProvider((ym, smallLimitRial))).value;
    final cats = ref.watch(categoryMapProvider);
    final f = TxFilter(ym: ym);

    Widget card({required String icon, required Color color, required String title, required String detail, VoidCallback? onTap}) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: ListTile(
              minVerticalPadding: 14,
              leading: Icon(appIcon(icon), color: color, size: 28),
              title: Text(title, style: Theme.of(context).textTheme.titleSmall),
              subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(detail)),
              trailing: onTap == null ? null : Icon(appIcon(Directionality.of(context) == TextDirection.rtl ? 'caret-left' : 'caret-right'), size: 18),
              onTap: onTap,
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.leaksTitle)),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 32), children: [
        const Center(child: MonthPill()),
        const SizedBox(height: 4),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(l.leaksHint, style: context.mutedStyle)),
        if (leaks == null)
          const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
        else if (leaks.isEmpty)
          SizedBox(height: 320, child: EmptyState(icon: 'check-circle:duotone', title: l.leaksNone, hint: l.leaksNoneHint))
        else ...[
          for (final s in leaks.spikes)
            if (cats[s.categoryId] case final c?)
              card(
                icon: 'trend-up',
                color: context.money.expense,
                title: l.leakSpike(displayName(c.name, c.nameKey, prefs.lang), prefs.digits('${s.pct}')),
                detail: l.leakSpikeDetail(prefs.money(s.now), prefs.money(s.avg)),
                onTap: () => push(context, TransactionsScreen(initial: f.copyWith(kind: TxKind.expense, categoryIds: [c.id, ...cats.values.where((k) => k.parentId == c.id).map((k) => k.id)]), title: displayName(c.name, c.nameKey, prefs.lang))),
              ),
          if (leaks.smallCount >= 10)
            card(
              icon: 'coins',
              color: context.money.warning,
              title: l.leakSmall(leaks.smallCount, prefs.money(leaks.smallTotal)),
              detail: l.leakSmallDetail(prefs.money(smallLimitRial)),
            ),
          if (leaks.uncatCount > 0)
            card(
              icon: 'question',
              color: context.money.warning,
              title: l.leakUncategorized(leaks.uncatCount, prefs.money(leaks.uncatTotal)),
              detail: l.leakUncategorizedDetail,
              onTap: () => push(context, TransactionsScreen(initial: f.copyWith(uncategorized: true), title: l.uncategorized)),
            ),
          if (leaks.gapCount > 0)
            card(
              icon: 'warning-circle',
              color: context.money.warning,
              title: l.leakGaps(leaks.gapCount),
              detail: l.leakGapsDetail(prefs.money(leaks.gapTotal)),
              onTap: () => push(context, TransactionsScreen(initial: f.copyWith(hasGap: true), title: l.filterGap)),
            ),
          if (leaks.recurringCount > 0)
            card(
              icon: 'repeat',
              color: context.money.warning,
              title: l.leakRecurring(leaks.recurringCount),
              detail: l.leakRecurringDetail,
              onTap: () => push(context, const RecurringScreen()),
            ),
        ],
      ]),
    );
  }
}
