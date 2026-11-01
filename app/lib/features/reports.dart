import 'package:core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../db/database.dart';
import '../db/seed.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/format.dart';
import '../ui/widgets.dart';
import 'budgets.dart';
import 'leaks.dart';
import 'report_charts.dart';
import 'report_data.dart';
import 'review.dart';
import 'transactions.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  bool _range = false;
  late Jalali _from = Jalali.now().withDay(1);
  late Jalali _to = Jalali.now();
  GroupBy _group = GroupBy.category;
  bool _expense = true;

  Period _period(int ym) =>
      _range ? Period.range(_from.toDateTime(), _to.addDays(1).toDateTime()) : Period.month(ym);

  Future<void> _pickRange() async {
    final r = await showPersianDateRangePicker(
      context: context,
      initialDateRange: JalaliRange(start: _from, end: _to),
      initialDate: _to,
      firstDate: Jalali(1390),
      lastDate: Jalali.now().addDays(1),
    );
    if (r != null) {
      setState(() {
        _from = r.start;
        _to = r.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final ym = ref.watch(monthProvider);
    final period = _period(ym);
    final totals = ref.watch(periodTotalsProvider(period)).value;
    final prevTotals = _range ? null : ref.watch(periodTotalsProvider(Period.month(prevYm(ym)))).value;
    final slices = ref.watch(slicesProvider((period, _group, _expense))).value ?? const <Slice>[];
    final top = ref.watch(topExpensesProvider(period)).value ?? const <TopExpense>[];
    final isNow = !_range && ym == jalaliYm(DateTime.now());
    final days = _range
        ? _to.toDateTime().difference(_from.toDateTime()).inDays + 1
        : isNow
            ? Jalali.now().day
            : Jalali(ym ~/ 100, ym % 100, 1).monthLength;

    return Scaffold(
      appBar: AppBar(title: Text(l.reportsTitle), actions: [
        IconButton(tooltip: l.budgets, icon: Icon(appIcon('target')), onPressed: () => push(context, const BudgetsScreen())),
        IconButton(tooltip: l.leaks, icon: Icon(appIcon('drop-half-bottom')), onPressed: () => push(context, const LeaksScreen())),
      ]),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 96), children: [
        SegmentedButton<bool>(
          showSelectedIcon: false,
          segments: [ButtonSegment(value: false, label: Text(l.periodMonth)), ButtonSegment(value: true, label: Text(l.periodRange))],
          selected: {_range},
          onSelectionChanged: (s) => setState(() => _range = s.first),
        ),
        const SizedBox(height: 12),
        if (_range)
          OutlinedButton.icon(
            onPressed: _pickRange,
            icon: Icon(appIcon('calendar-blank')),
            label: Text('${fmtDate(prefs, _from.toDateTime())}  →  ${fmtDate(prefs, _to.toDateTime())}'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          )
        else
          const Center(child: MonthPill()),
        const SizedBox(height: 12),
        _Summary(totals, prevTotals),
        const SizedBox(height: 8),
        KpiRow(totals: totals, days: days, largest: top.isEmpty ? null : top.first.amount),
        if (!_range) ...[
          SectionHeader(l.paceTitle),
          Padding(padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4), child: Text(l.paceHint, style: context.mutedStyle)),
          PaceChart(ym),
        ],
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: [ButtonSegment(value: true, label: Text(l.filterExpense)), ButtonSegment(value: false, label: Text(l.filterIncome))],
              selected: {_expense},
              onSelectionChanged: (s) => setState(() => _expense = s.first),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: [
          for (final (g, label) in [(GroupBy.category, l.groupCategory), (GroupBy.tag, l.groupTag), (GroupBy.account, l.groupAccount)])
            ChoiceChip(label: Text(label), selected: _group == g, onSelected: (_) => setState(() => _group = g)),
        ]),
        const SizedBox(height: 16),
        if (_group == GroupBy.category && _expense && slices.isNotEmpty && (slices.where((s) => s.key == null).fold(0, (a, s) => a + s.total) / slices.fold(0, (a, s) => a + s.total)) >= 0.8)
          Padding(padding: const EdgeInsets.only(bottom: 12), child: UncategorizedNudge(onReview: () => push(context, const ReviewScreen()))),
        if (slices.isEmpty)
          Card(child: Padding(padding: const EdgeInsets.all(32), child: Center(child: Text(l.noDataPeriod, style: context.mutedStyle))))
        else
          _Breakdown(slices: slices, group: _group, expense: _expense, period: period),
        if (_group == GroupBy.tag) Padding(padding: const EdgeInsets.only(top: 8), child: Text(l.tagsOverlap, style: context.mutedStyle)),
        if (!_range) ...[
          SectionHeader(l.trend12),
          _Trend(ym),
        ],
        SectionHeader(l.weekdayTitle),
        WeekdayChart(period),
        if (top.isNotEmpty) ...[
          SectionHeader(l.topExpensesTitle),
          TopExpenses(top),
        ],
      ]),
    );
  }
}

class _Summary extends ConsumerWidget {
  const _Summary(this.t, this.prev);
  final Totals? t;
  final Totals? prev;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final income = t?.income ?? 0, expense = t?.expense ?? 0;
    final style = Theme.of(context).textTheme;
    Widget cell(String label, int v, {bool colored = true}) => Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: style.labelMedium?.copyWith(color: context.money.muted)),
            FittedBox(fit: BoxFit.scaleDown, alignment: AlignmentDirectional.centerStart, child: Amount(v, style: style.titleMedium)),
          ]),
        );
    String? delta;
    if (prev != null && prev!.expense != 0) {
      final pct = ((expense - prev!.expense) / prev!.expense.abs() * -100).round(); // expense is negative
      delta = l.vsLastMonth('${pct > 0 ? '+' : ''}$pct');
    }
    final saved = income > 0 ? ((income + expense) / income * 100).round() : null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [cell(l.income, income), cell(l.expense, expense), cell(l.net, income + expense)]),
          if (delta != null || saved != null) const SizedBox(height: 12),
          Wrap(spacing: 8, children: [
            if (saved != null) Chip(avatar: Icon(appIcon('piggy-bank'), size: 18), label: Text(prefs.digits(l.savingsRate('$saved')))),
            if (delta != null) Chip(avatar: Icon(appIcon('arrows-down-up'), size: 18), label: Text(prefs.digits('${l.expense}: $delta'))),
          ]),
        ]),
      ),
    );
  }
}

class _Breakdown extends ConsumerWidget {
  const _Breakdown({required this.slices, required this.group, required this.expense, required this.period});
  final List<Slice> slices;
  final GroupBy group;
  final bool expense;
  final Period period;

  ({String name, String icon, int color}) _label(WidgetRef ref, AppLocalizations l, Prefs prefs, Slice s) {
    if (s.key == null) return (name: group == GroupBy.tag ? '—' : l.uncategorized, icon: 'question:regular', color: 0xFF94A3B8);
    switch (group) {
      case GroupBy.category:
        final c = ref.watch(categoryMapProvider)[s.key];
        return c == null ? (name: '?', icon: 'question', color: 0xFF94A3B8) : (name: displayName(c.name, c.nameKey, prefs.lang), icon: c.icon, color: c.color);
      case GroupBy.tag:
        final t = ref.watch(tagMapProvider)[s.key];
        return t == null ? (name: '?', icon: 'question', color: 0xFF94A3B8) : (name: displayName(t.name, t.nameKey, prefs.lang), icon: t.icon, color: t.color);
      case GroupBy.account:
        final a = (ref.watch(accountsProvider).value ?? const <Account>[]).where((a) => a.id == s.key).firstOrNull;
        return a == null ? (name: '?', icon: 'question', color: 0xFF94A3B8) : (name: a.name, icon: a.icon, color: a.color);
    }
  }

  TxFilter _drill(WidgetRef ref, Slice s) {
    final base = period.filter();
    final kind = expense ? TxKind.expense : TxKind.income;
    switch (group) {
      case GroupBy.category:
        if (s.key == null) return base.copyWith(kind: kind, uncategorized: true);
        final kids = (ref.read(categoriesProvider).value ?? const <Category>[]).where((c) => c.parentId == s.key).map((c) => c.id);
        return base.copyWith(kind: kind, categoryIds: [s.key!, ...kids]);
      case GroupBy.tag:
        return base.copyWith(kind: kind, tagId: s.key);
      case GroupBy.account:
        return base.copyWith(kind: kind, accountId: s.key);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final total = slices.fold(0, (a, s) => a + s.total);
    final top = slices.take(6).toList();
    final otherTotal = slices.skip(6).fold(0, (a, s) => a + s.total);
    final labels = [for (final s in top) _label(ref, l, prefs, s)];
    final t = Theme.of(context).textTheme;

    return Column(children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 220,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Stack(alignment: Alignment.center, children: [
                PieChart(PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 72,
                  sections: [
                    for (var i = 0; i < top.length; i++)
                      PieChartSectionData(value: top[i].total.toDouble(), color: Color(labels[i].color), radius: 30, showTitle: false),
                    if (otherTotal > 0) PieChartSectionData(value: otherTotal.toDouble(), color: context.money.muted, radius: 30, showTitle: false),
                  ],
                )),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(expense ? l.spentTotal : l.earnedTotal, style: t.labelMedium?.copyWith(color: context.money.muted)),
                  Text(prefs.money(total), style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700, fontFeatures: tabular)),
                ]),
              ]),
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      Card(
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          for (final s in slices)
            Builder(builder: (context) {
              final lab = _label(ref, l, prefs, s);
              final pct = total == 0 ? 0.0 : s.total / total;
              return InkWell(
                onTap: () => push(context, TransactionsScreen(initial: _drill(ref, s), title: lab.name)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(children: [
                    IconAvatar(lab.icon, lab.color, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text(lab.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
                          Text(prefs.money(s.total), textDirection: TextDirection.ltr, style: t.titleSmall?.copyWith(fontFeatures: tabular)),
                        ]),
                        const SizedBox(height: 6),
                        Row(children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(value: pct, minHeight: 6, color: Color(lab.color), backgroundColor: Color(lab.color).withValues(alpha: 0.12)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(prefs.digits('${(pct * 100).round()}٪'), style: context.mutedStyle),
                        ]),
                      ]),
                    ),
                  ]),
                ),
              );
            }),
        ]),
      ),
    ]);
  }
}

class _Trend extends ConsumerWidget {
  const _Trend(this.endYm);
  final int endYm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(prefsProvider);
    final bars = ref.watch(trendProvider(endYm)).value ?? const <MonthBar>[];
    final scheme = Theme.of(context).colorScheme;
    if (bars.isEmpty) return const SizedBox.shrink();
    final maxY = bars.fold<int>(1, (m, b) => [m, b.income, b.expense].reduce((a, c) => a > c ? a : c)).toDouble();
    final months = prefs.persian ? jalaliMonthsFa : jalaliMonthsEn;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 24, 16, 8),
        child: Column(children: [
          SizedBox(
            height: 200,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: BarChart(BarChartData(
                maxY: maxY * 1.1,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 3,
                  getDrawingHorizontalLine: (_) => FlLine(color: Theme.of(context).dividerColor, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      interval: maxY / 3,
                      getTitlesWidget: (v, meta) => v == meta.max ? const SizedBox.shrink() : Text(compactMoney(v, prefs), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.money.muted)),
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (v, _) => Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(prefs.digits('${bars[v.toInt()].ym % 100}'), style: Theme.of(context).textTheme.labelSmall),
                      ),
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, gi, rod, ri) {
                      final b = bars[group.x];
                      return BarTooltipItem(
                        '${months[b.ym % 100 - 1]} ${prefs.digits('${b.ym ~/ 100}')}\n${prefs.money(ri == 0 ? b.income : b.expense)}',
                        TextStyle(color: scheme.onInverseSurface, fontFamily: 'Vazirmatn', fontSize: 12),
                      );
                    },
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < bars.length; i++)
                    BarChartGroupData(x: i, barsSpace: 2, barRods: [
                      BarChartRodData(toY: bars[i].income.toDouble(), width: 6, color: context.money.income, borderRadius: BorderRadius.circular(2)),
                      BarChartRodData(toY: bars[i].expense.toDouble(), width: 6, color: context.money.expense, borderRadius: BorderRadius.circular(2)),
                    ]),
                ],
              )),
            ),
          ),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(appIcon('arrow-down-left'), size: 16, color: context.money.income),
            Text(' ${AppLocalizations.of(context).income}   ', style: context.mutedStyle),
            Icon(appIcon('arrow-up-right'), size: 16, color: context.money.expense),
            Text(' ${AppLocalizations.of(context).expense}', style: context.mutedStyle),
          ]),
        ]),
      ),
    );
  }
}
