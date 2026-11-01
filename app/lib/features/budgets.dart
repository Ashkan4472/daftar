import 'package:core/core.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/seed.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/format.dart';
import '../ui/pickers.dart';
import '../ui/widgets.dart';
import 'report_data.dart';

/// Bar colour by how much of the limit is used.
Color budgetColor(BuildContext context, double ratio) =>
    ratio >= 1 ? context.money.expense : ratio >= 0.8 ? context.money.warning : Theme.of(context).colorScheme.primary;

class BudgetTile extends ConsumerWidget {
  const BudgetTile(this.s, {super.key, this.onTap});
  final BudgetStatus s;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final left = s.budget.monthlyLimit - s.spent;
    final color = budgetColor(context, s.ratio);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            IconAvatar(s.category.icon, s.category.color, size: 40),
            const SizedBox(width: 12),
            Expanded(child: Text(displayName(s.category.name, s.category.nameKey, prefs.lang), style: Theme.of(context).textTheme.titleSmall)),
            Text(prefs.digits('${(s.ratio * 100).round()}٪'), style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color)),
          ]),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: s.ratio.clamp(0, 1).toDouble(), minHeight: 8, color: color, backgroundColor: color.withValues(alpha: 0.14)),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: Text(l.budgetSpent(prefs.money(s.spent), prefs.money(s.budget.monthlyLimit)), style: context.mutedStyle)),
            Text(left >= 0 ? l.budgetLeft(prefs.money(left)) : l.budgetOver(prefs.money(-left)), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
          ]),
        ]),
      ),
    );
  }
}

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final ym = ref.watch(monthProvider);
    final list = ref.watch(budgetsProvider(ym)).value ?? const <BudgetStatus>[];
    return Scaffold(
      appBar: AppBar(title: Text(l.budgets)),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _edit(context, ref), icon: Icon(appIcon('plus')), label: Text(l.newBudget)),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 96), children: [
        const Center(child: MonthPill()),
        const SizedBox(height: 12),
        if (list.isEmpty)
          EmptyStateInline(icon: 'target', title: l.noBudgets, hint: l.budgetsHint)
        else
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(children: [
              for (final s in list)
                BudgetTile(s, onTap: () => _edit(context, ref, s)),
            ]),
          ),
      ]),
    );
  }
}

class EmptyStateInline extends StatelessWidget {
  const EmptyStateInline({super.key, required this.icon, required this.title, this.hint});
  final String icon, title;
  final String? hint;

  @override
  Widget build(BuildContext context) => SizedBox(height: 320, child: EmptyState(icon: icon, title: title, hint: hint));
}

Future<void> _edit(BuildContext context, WidgetRef ref, [BudgetStatus? existing]) {
  final l = AppLocalizations.of(context);
  final prefs = ref.read(prefsProvider);
  final db = ref.read(dbProvider);
  final unit = prefs.toman ? 10 : 1;
  final limit = TextEditingController(text: existing == null ? '' : formatMoney(existing.budget.monthlyLimit ~/ unit));
  int? category = existing?.budget.categoryId;
  String? error;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => SheetFrame(
        action: FilledButton(
          onPressed: () async {
            final v = parseMoney(limit.text);
            if (category == null) {
              setState(() => error = l.pickCategoryFirst);
              return;
            }
            if (v == null || v == 0) {
              setState(() => error = l.amountRequired);
              return;
            }
            final nav = Navigator.of(ctx);
            final ym = ref.read(monthProvider);
            if (existing == null) {
              await db.into(db.budgets).insert(BudgetsCompanion.insert(categoryId: category!, monthlyLimit: v * unit, fromYm: ym));
            } else {
              await (db.update(db.budgets)..where((b) => b.id.equals(existing.budget.id))).write(BudgetsCompanion(monthlyLimit: Value(v * unit)));
            }
            nav.pop();
          },
          child: Text(l.save),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          Text(existing == null ? l.newBudget : l.editBudget, style: Theme.of(ctx).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: limit,
            autofocus: existing == null,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            inputFormatters: [MoneyInputFormatter()],
            decoration: InputDecoration(labelText: l.monthlyLimit, suffixText: prefs.toman ? l.toman : l.rial, errorText: error),
            onChanged: (_) => setState(() => error = null),
          ),
          if (existing == null) ...[
            SectionHeader(l.category),
            CategoryPicker(kind: CategoryKind.expense, selected: category, onChanged: (c) => setState(() => category = c)),
          ],
          if (existing != null)
            TextButton.icon(
              icon: Icon(appIcon('trash')),
              label: Text(l.removeBudget),
              onPressed: () async {
                final nav = Navigator.of(ctx);
                await (db.delete(db.budgets)..where((b) => b.id.equals(existing.budget.id))).go();
                nav.pop();
              },
            ),
        ]),
      ),
    ),
  );
}
