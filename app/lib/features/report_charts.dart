import 'package:core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/widgets.dart';
import 'report_data.dart';
import 'transactions.dart';
import 'tx_sheet.dart';

/// Short axis label: 1.2M, 340K. Shown in the user's unit (Toman or Rial).
String compactMoney(num rial, Prefs p) {
  var v = (p.toman ? rial / 10 : rial).abs().toDouble();
  String t(double x, String suffix) {
    final s = x >= 100 || x == x.roundToDouble() ? x.round().toString() : x.toStringAsFixed(1);
    return '$s$suffix';
  }

  final out = v >= 1e9 ? t(v / 1e9, 'B') : v >= 1e6 ? t(v / 1e6, 'M') : v >= 1e3 ? t(v / 1e3, 'K') : t(v, '');
  return p.digits(out);
}

TextStyle _axis(BuildContext context) =>
    Theme.of(context).textTheme.labelSmall!.copyWith(color: context.money.muted);

/// Three small facts about the period: daily average, count, largest expense.
class KpiRow extends ConsumerWidget {
  const KpiRow({super.key, required this.totals, required this.days, required this.largest});
  final Totals? totals;
  final int days; // days to average over (elapsed days of the month, or the range length)
  final int? largest; // negative Rial

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final t = totals;
    final avg = t == null || days == 0 ? 0 : (-t.expense / days).round();
    Widget tile(String label, String value) => Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: context.mutedStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                FittedBox(fit: BoxFit.scaleDown, alignment: AlignmentDirectional.centerStart, child: Text(value, textDirection: TextDirection.ltr, style: Theme.of(context).textTheme.titleMedium)),
              ]),
            ),
          ),
        );
    return Row(children: [
      tile(l.kpiDailyAvg, compactMoney(avg, prefs)),
      const SizedBox(width: 8),
      tile(l.kpiTransactions, prefs.digits('${t?.count ?? 0}')),
      const SizedBox(width: 8),
      tile(l.kpiLargest, largest == null ? '—' : compactMoney(largest!, prefs)),
    ]);
  }
}

/// Running total of spending through the month, against last month.
class PaceChart extends ConsumerWidget {
  const PaceChart(this.ym, {super.key});
  final int ym;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final cur = ref.watch(dailySpendProvider(ym)).value;
    final prev = ref.watch(dailySpendProvider(prevYm(ym))).value;
    if (cur == null || prev == null) return const SizedBox(height: 240);
    final today = DateTime.now();
    final isNow = ym == jalaliYm(DateTime.now());
    final upTo = isNow ? Jalali.fromDateTime(today).day : cur.length;

    List<FlSpot> cumulative(List<int> d, int n) {
      var sum = 0;
      return [for (var i = 0; i < n && i < d.length; i++) FlSpot(i + 1.0, (sum += d[i]).toDouble())];
    }

    final a = cumulative(cur, upTo), b = cumulative(prev, prev.length);
    final maxY = [...a, ...b].fold<double>(1, (m, s) => s.y > m ? s.y : m) * 1.1;
    final days = cur.length > prev.length ? cur.length : prev.length;
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 16, 12),
        child: Column(children: [
          SizedBox(
            height: 200,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: LineChart(LineChartData(
                minX: 1,
                maxX: days.toDouble(),
                minY: 0,
                maxY: maxY,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 3,
                  getDrawingHorizontalLine: (_) => FlLine(color: Theme.of(context).dividerColor, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      interval: maxY / 3,
                      getTitlesWidget: (v, meta) => v == meta.max ? const SizedBox.shrink() : Text(compactMoney(v, prefs), style: _axis(context)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 1,
                      getTitlesWidget: (v, _) => [1, 5, 10, 15, 20, 25, 30].contains(v.toInt())
                          ? Padding(padding: const EdgeInsets.only(top: 6), child: Text(prefs.digits('${v.toInt()}'), style: _axis(context)))
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => [
                      for (final s in spots)
                        LineTooltipItem(
                          s.barIndex == 0 ? '${l.paceThis}\n${prefs.money(s.y.round())}' : '${l.paceLast}\n${prefs.money(s.y.round())}',
                          TextStyle(color: Theme.of(context).colorScheme.onInverseSurface, fontFamily: 'Vazirmatn', fontSize: 12),
                        ),
                    ],
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: a,
                    color: primary,
                    barWidth: 3,
                    isCurved: true,
                    curveSmoothness: 0.15,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: primary.withValues(alpha: 0.12)),
                  ),
                  LineChartBarData(
                    spots: b,
                    color: context.money.muted,
                    barWidth: 2,
                    dashArray: [6, 4],
                    isCurved: true,
                    curveSmoothness: 0.15,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              )),
            ),
          ),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 16, height: 3, color: primary),
            Text('  ${l.paceThis}     ', style: context.mutedStyle),
            Container(width: 16, height: 3, color: context.money.muted),
            Text('  ${l.paceLast}', style: context.mutedStyle),
          ]),
        ]),
      ),
    );
  }
}

/// Spending by day of the week, Saturday first. The busiest day is highlighted.
class WeekdayChart extends ConsumerWidget {
  const WeekdayChart(this.period, {super.key});
  final Period period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(prefsProvider);
    final data = ref.watch(weekdayProvider(period)).value;
    if (data == null || data.every((v) => v == 0)) return const SizedBox.shrink();
    final names = prefs.persian ? const ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'] : const ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    final full = prefs.persian
        ? const ['شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه']
        : const ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final maxV = data.reduce((a, b) => a > b ? a : b);
    final maxY = maxV * 1.15;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 16, 12),
        child: SizedBox(
          height: 180,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: BarChart(BarChartData(
              maxY: maxY.toDouble(),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: maxY / 3,
                getDrawingHorizontalLine: (_) => FlLine(color: Theme.of(context).dividerColor, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    interval: maxY / 3,
                    getTitlesWidget: (v, meta) => v == meta.max ? const SizedBox.shrink() : Text(compactMoney(v, prefs), style: _axis(context)),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    getTitlesWidget: (v, _) => Padding(padding: const EdgeInsets.only(top: 6), child: Text(names[v.toInt()], style: _axis(context))),
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                    '${full[group.x]}\n${prefs.money(data[group.x])}',
                    TextStyle(color: Theme.of(context).colorScheme.onInverseSurface, fontFamily: 'Vazirmatn', fontSize: 12),
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i < 7; i++)
                  BarChartGroupData(x: i, barRods: [
                    BarChartRodData(
                      toY: data[i].toDouble(),
                      width: 18,
                      color: data[i] == maxV ? context.money.expense : Theme.of(context).colorScheme.primary.withValues(alpha: 0.55),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                  ]),
              ],
            )),
          ),
        ),
      ),
    );
  }
}

/// The five largest expenses of the period.
class TopExpenses extends ConsumerWidget {
  const TopExpenses(this.list, {super.key});
  final List<TopExpense> list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (list.isEmpty) return const SizedBox.shrink();
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        for (final t in list)
          Builder(builder: (context) {
            final row = ref.watch(txOneProvider(t.id)).value;
            return row == null ? const SizedBox(height: 68) : SizedBox(height: 68, child: TransactionTile(row, onTap: () => showTxSheet(context, t.id)));
          }),
      ]),
    );
  }
}

/// Shown when almost all spending is still uncategorized.
class UncategorizedNudge extends StatelessWidget {
  const UncategorizedNudge({super.key, required this.onReview});
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      color: context.money.warning.withValues(alpha: 0.12),
      child: ListTile(
        minVerticalPadding: 12,
        title: Text(l.uncatNudge),
        trailing: FilledButton.tonal(onPressed: onReview, style: FilledButton.styleFrom(minimumSize: const Size(0, 44)), child: Text(l.reviewNow)),
      ),
    );
  }
}
