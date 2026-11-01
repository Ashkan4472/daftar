import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../state.dart';
import '../theme/theme.dart';

export '../widgets.dart';

void push(BuildContext context, Widget page) =>
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));

/// Snackbar with an Undo action. Replaces any snackbar already showing.
void showUndo(BuildContext context, String message, VoidCallback onUndo) {
  final m = ScaffoldMessenger.of(context);
  m.clearSnackBars();
  m.showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 5),
    action: SnackBarAction(label: AppLocalizations.of(context).undo, onPressed: onUndo),
  ));
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action});
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 20, 0, 8),
        child: Row(children: [
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
          if (action != null) action!,
        ]),
      );
}

/// Jalali month with prev/next. Tap the name to jump to any month.
class MonthPill extends ConsumerWidget {
  const MonthPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final ym = ref.watch(monthProvider);
    final prefs = ref.watch(prefsProvider);
    final m = ref.read(monthProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    // "Previous" points to the start side of the reading direction.
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      decoration: BoxDecoration(color: scheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(28)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
          tooltip: l.prevMonth,
          onPressed: m.prev,
          icon: Icon(appIcon(rtl ? 'caret-right:bold' : 'caret-left:bold'), size: 20),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => showMonthPicker(context),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 120, minHeight: 48),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(prefs.monthName(ym), style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: 4),
              Icon(appIcon('caret-down:bold'), size: 14, color: scheme.primary),
            ]),
          ),
        ),
        IconButton(
          tooltip: l.nextMonth,
          onPressed: m.next,
          icon: Icon(appIcon(rtl ? 'caret-left:bold' : 'caret-right:bold'), size: 20),
        ),
      ]),
    );
  }
}

/// Year row plus a 3x4 grid of Jalali months. A dot marks months that have data.
Future<void> showMonthPicker(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      builder: (_) => const _MonthPickerSheet(),
    );

class _MonthPickerSheet extends ConsumerStatefulWidget {
  const _MonthPickerSheet();

  @override
  ConsumerState<_MonthPickerSheet> createState() => _MonthPickerSheetState();
}

class _MonthPickerSheetState extends ConsumerState<_MonthPickerSheet> {
  late int _year = ref.read(monthProvider) ~/ 100;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final current = ref.watch(monthProvider);
    final nowYm = jalaliYm(DateTime.now());
    final withData = ref.watch(monthsWithDataProvider(_year)).value ?? const <int>{};
    final scheme = Theme.of(context).colorScheme;
    final months = prefs.persian ? jalaliMonthsFa : jalaliMonthsEn;
    final rtl = Directionality.of(context) == TextDirection.rtl;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            IconButton(
              tooltip: l.prevMonth,
              onPressed: () => setState(() => _year--),
              icon: Icon(appIcon(rtl ? 'caret-right:bold' : 'caret-left:bold')),
            ),
            Expanded(child: Text(prefs.digits('$_year'), textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge)),
            IconButton(
              tooltip: l.nextMonth,
              onPressed: () => setState(() => _year++),
              icon: Icon(appIcon(rtl ? 'caret-left:bold' : 'caret-right:bold')),
            ),
          ]),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.1,
            children: [
              for (var m = 1; m <= 12; m++)
                _MonthCell(
                  label: months[m - 1],
                  selected: current == _year * 100 + m,
                  isNow: nowYm == _year * 100 + m,
                  hasData: withData.contains(m),
                  onTap: () {
                    ref.read(monthProvider.notifier).set(_year * 100 + m);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              ref.read(monthProvider.notifier).set(nowYm);
              Navigator.pop(context);
            },
            icon: Icon(appIcon('calendar-check'), color: scheme.primary),
            label: Text(l.presetThisMonth),
          ),
        ]),
      ),
    );
  }
}

class _MonthCell extends StatelessWidget {
  const _MonthCell({required this.label, required this.selected, required this.isNow, required this.hasData, required this.onTap});
  final String label;
  final bool selected, isNow, hasData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? const Color(0xFF1E40AF) : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            decoration: isNow && !selected ? BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: scheme.primary, width: 1.5)) : null,
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: selected ? Colors.white : null)),
                const SizedBox(height: 2),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: hasData ? (selected ? Colors.white : scheme.primary) : Colors.transparent),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small colored dot-icon used for tags.
class TagDot extends StatelessWidget {
  const TagDot(this.icon, this.color, {super.key});
  final String icon;
  final int color;

  @override
  Widget build(BuildContext context) => Icon(appIcon(icon), size: 14, color: Color(color));
}

Color onColor(Color c) => c.computeLuminance() > 0.5 ? Colors.black : Colors.white;

extension MutedText on BuildContext {
  TextStyle? get mutedStyle =>
      Theme.of(this).textTheme.bodySmall?.copyWith(color: money.muted);
}

/// Primary action bar pinned to the bottom of a screen or sheet, so the main
/// button is always in the same place.
class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: SafeArea(top: false, child: Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 12), child: SizedBox(width: double.infinity, child: child))),
      );
}

/// Bottom-sheet layout: scrolling content above, [action] pinned below.
class SheetFrame extends StatelessWidget {
  const SheetFrame({super.key, required this.child, required this.action});
  final Widget child;
  final Widget action;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Flexible(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: child)),
          BottomBar(child: action),
        ]),
      );
}
