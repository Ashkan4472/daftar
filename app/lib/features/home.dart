import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/seed.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/widgets.dart';
import 'backup_screen.dart';
import 'balance_sheet.dart';
import 'budgets.dart';
import 'import_sms.dart';
import 'manage.dart';
import 'inbox.dart';
import 'transfers.dart';
import 'report_data.dart';
import 'review.dart';
import 'settings.dart';
import 'transactions.dart';
import 'tx_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final ym = ref.watch(monthProvider);
    final prefs = ref.watch(prefsProvider);
    final summary = ref.watch(monthSummaryProvider(ym)).value;
    final accounts = (ref.watch(accountBalancesProvider).value ?? const <AccountBalance>[]).where((a) => !a.account.archived).toList();
    final total = ref.watch(txCountProvider(const TxFilter())).value;
    final recent = ref.watch(txListProvider((TxFilter(ym: ym), 5))).value ?? const [];
    final budgets = ref.watch(budgetsProvider(ym)).value ?? const <BudgetStatus>[];
    final t = Theme.of(context).textTheme;
    final hasData = (total ?? 1) > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.appName),
        actions: [
          IconButton(
            tooltip: l.inbox,
            icon: Badge(isLabelVisible: ref.watch(unreadCountProvider) > 0, smallSize: 9, child: Icon(appIcon('bell'))),
            onPressed: () => push(context, const InboxScreen()),
          ),
          IconButton(tooltip: l.importSms, icon: Icon(appIcon('download-simple')), onPressed: () => push(context, const ImportSmsScreen())),
          IconButton(tooltip: l.settings, icon: Icon(appIcon('gear')), onPressed: () => push(context, const SettingsScreen())),
        ],
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 96), children: [
        const Center(child: MonthPill()),
        const SizedBox(height: 12),
        if (!hasData)
          _FirstRun()
        else ...[
          _Hero(summary),
          if ((summary?.toReview ?? 0) > 0) ...[
            const SizedBox(height: 12),
            Card(
              color: context.money.warning.withValues(alpha: 0.12),
              child: ListTile(
                minVerticalPadding: 12,
                leading: Icon(appIcon('tray'), color: context.money.warning),
                title: Text(prefs.digits(l.toReviewCount(summary!.toReview))),
                trailing: FilledButton.tonal(
                  onPressed: () => push(context, const ReviewScreen()),
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                  child: Text(l.reviewNow),
                ),
                onTap: () => push(context, const ReviewScreen()),
              ),
            ),
          ],
          if (budgets.isNotEmpty) ...[
            SectionHeader(l.budgets, action: TextButton(onPressed: () => push(context, const BudgetsScreen()), child: Text(l.seeAll))),
            Card(clipBehavior: Clip.antiAlias, child: Column(children: [for (final b in budgets.take(3)) BudgetTile(b)])),
          ],
          if (_needsBackup(ref)) ...[
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: Icon(appIcon('cloud-arrow-down'), color: Theme.of(context).colorScheme.primary),
                title: Text(l.backupNudge),
                subtitle: Text(l.backupNudgeHint),
                onTap: () => push(context, const BackupScreen()),
              ),
            ),
          ],
          const TransferCards(),
          const UpcomingCard(),
          SectionHeader(l.accounts, action: TextButton.icon(onPressed: () => editAccount(context, ref), icon: Icon(appIcon('plus'), size: 18), label: Text(l.add))),
          Card(
            child: Column(children: [
              for (final a in accounts)
                ListTile(
                  minVerticalPadding: 8,
                  leading: IconAvatar(a.account.icon, a.account.color),
                  title: Text(displayName(a.account.name, a.account.name, prefs.lang)),
                  subtitle: Text(balanceCaption(l, prefs, a), style: context.mutedStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(prefs.money(a.balance), textDirection: TextDirection.ltr, style: t.titleSmall?.copyWith(fontFeatures: tabular)),
                    IconButton(
                      tooltip: l.balanceUpdate,
                      icon: Icon(appIcon('pencil-simple'), size: 20, color: context.money.muted),
                      onPressed: () => showBalanceSheet(context, ref, a),
                    ),
                  ]),
                  onTap: () => push(context, TransactionsScreen(initial: TxFilter(accountId: a.account.id), title: a.account.name)),
                ),
              if (accounts.length > 1) ...[
                const Divider(height: 1),
                ListTile(
                  dense: true,
                  title: Text(l.balanceTotal),
                  trailing: Text(prefs.money(accounts.fold(0, (s, a) => s + a.balance)), textDirection: TextDirection.ltr, style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ),
              ],
            ]),
          ),
          const SizedBox.shrink(),
          SectionHeader(l.recent,
              action: TextButton(onPressed: () => ref.read(tabProvider.notifier).go(1), child: Text(l.seeAll))),
          if (recent.isEmpty)
            Card(child: Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(l.noTransactions, style: context.mutedStyle))))
          else
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(children: [
                for (final r in recent) SizedBox(height: 68, child: TransactionTile(r, onTap: () => showTxSheet(context, r.tx.id))),
              ]),
            ),
        ],
      ]),
    );
  }
}

bool _needsBackup(WidgetRef ref) {
  final s = ref.watch(settingsMapProvider).value;
  if (s == null) return false;
  final last = int.tryParse(s['last_backup'] ?? '');
  final since = last == null ? null : DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(last)).inDays;
  // Never backed up: nag only once there is real data (after the first week of use).
  final first = int.tryParse(s['installed_at'] ?? '');
  if (since == null) return first != null && DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(first)).inDays >= 7;
  return since >= 14;
}

class _Hero extends ConsumerWidget {
  const _Hero(this.s);
  final MonthSummary? s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final t = Theme.of(context).textTheme;
    final income = s?.income ?? 0, expense = s?.expense ?? 0, net = s?.net ?? 0;
    final pct = income > 0 ? (net / income * 100).clamp(-999, 100).round() : null;
    final spentShare = income > 0 ? (expense.abs() / income).clamp(0.0, 1.0) : (expense != 0 ? 1.0 : 0.0);
    const fg = Colors.white;
    final fg2 = Colors.white.withValues(alpha: 0.78);

    Widget stat(String label, String icon, int v) => Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Icon(appIcon(icon), size: 16, color: fg2), const SizedBox(width: 4), Text(label, style: t.labelMedium?.copyWith(color: fg2))]),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(prefs.money(v, signed: true), textDirection: TextDirection.ltr, style: t.titleMedium?.copyWith(color: fg, fontWeight: FontWeight.w700, fontFeatures: tabular)),
            ),
          ]),
        );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark ? const [Color(0xFF1E3A8A), Color(0xFF172554)] : const [Color(0xFF1E40AF), Color(0xFF1E3A8A)],
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(l.netThisMonth, style: t.labelLarge?.copyWith(color: fg2))),
          if (pct != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(20)),
              child: Text(prefs.digits(l.savingsRate('$pct')), style: t.labelMedium?.copyWith(color: fg)),
            ),
        ]),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(prefs.money(net, signed: true), textDirection: TextDirection.ltr, style: t.displaySmall?.copyWith(color: fg, fontWeight: FontWeight.w800, fontFeatures: tabular)),
        ),
        Text(prefs.toman ? l.toman : l.rial, style: t.bodySmall?.copyWith(color: fg2)),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: spentShare.toDouble(), minHeight: 6, color: fg, backgroundColor: Colors.white.withValues(alpha: 0.2)),
        ),
        const SizedBox(height: 16),
        Row(children: [stat(l.heroIncome, 'arrow-down-left', income), stat(l.heroSpent, 'arrow-up-right', expense)]),
      ]),
    );
  }
}

class _FirstRun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.asset('assets/brand/logo.png', width: 80, height: 80)),
          const SizedBox(height: 16),
          Text(l.importFirstTitle, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(l.importFirstHint, style: context.mutedStyle, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => push(context, const ImportSmsScreen()),
            icon: Icon(appIcon('download-simple')),
            label: Text(l.importSms),
          ),
          const SizedBox(height: 8),
          TextButton.icon(onPressed: () => showAddSheet(context), icon: Icon(appIcon('plus')), label: Text(l.addTransaction)),
        ]),
      ),
    );
  }
}
