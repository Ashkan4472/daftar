import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/seed.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../state.dart';
import 'people_data.dart';
import '../ui/format.dart';
import '../ui/pickers.dart';
import '../ui/widgets.dart';

/// Asks how to divide [total] (positive Rial) across categories. Null = cancelled.
Future<List<(int, int)>?> showCategorySplit(BuildContext context,
        {required CategoryKind kind, required int total, List<(int, int)> initial = const []}) =>
    showModalBottomSheet<List<(int, int)>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => CategorySplitSheet(kind: kind, total: total, initial: initial),
    );

class CategorySplitSheet extends ConsumerStatefulWidget {
  const CategorySplitSheet({super.key, required this.kind, required this.total, required this.initial});
  final CategoryKind kind;
  final int total;
  final List<(int, int)> initial;

  @override
  ConsumerState<CategorySplitSheet> createState() => _CategorySplitSheetState();
}

class _Part {
  _Part([this.category, String text = '']) : input = TextEditingController(text: text);
  int? category;
  final TextEditingController input;
}

class _CategorySplitSheetState extends ConsumerState<CategorySplitSheet> {
  SplitMode _mode = SplitMode.exact;
  late final List<_Part> _parts;

  int get _unit => ref.read(prefsProvider).toman ? 10 : 1;

  @override
  void initState() {
    super.initState();
    _parts = widget.initial.isEmpty
        ? [_Part(), _Part()]
        : [for (final (c, a) in widget.initial) _Part(c, formatMoney(a ~/ _unit))];
  }

  @override
  void dispose() {
    for (final p in _parts) {
      p.input.dispose();
    }
    super.dispose();
  }

  List<int>? get _amounts => splitParts(widget.total, _mode, [
        for (final p in _parts) (parseMoney(p.input.text) ?? 0) * (_mode == SplitMode.exact ? _unit : 1),
      ]);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final amounts = _amounts;
    final ok = amounts != null && _parts.every((p) => p.category != null);
    final entered = _parts.fold<int>(0, (a, p) => a + (parseMoney(p.input.text) ?? 0) * (_mode == SplitMode.exact ? _unit : 1));
    return SheetFrame(
      action: FilledButton(
        onPressed: ok ? () => Navigator.pop(context, [for (final (i, p) in _parts.indexed) (p.category!, amounts[i])]) : null,
        child: Text(l.save),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        Text(l.catSplit, style: Theme.of(context).textTheme.titleLarge),
        Text(prefs.money(widget.total), textDirection: TextDirection.ltr, style: context.mutedStyle),
        const SizedBox(height: 16),
        SegmentedButton<SplitMode>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(value: SplitMode.equal, label: Text(l.splitEqual)),
            ButtonSegment(value: SplitMode.percent, label: Text(l.splitPercent)),
            ButtonSegment(value: SplitMode.exact, label: Text(l.splitExact)),
          ],
          selected: {_mode},
          onSelectionChanged: (s) => setState(() => _mode = s.first),
        ),
        for (final (i, p) in _parts.indexed) ...[
          const SizedBox(height: 12),
          CategoryField(kind: widget.kind, selected: p.category, onChanged: (c) => setState(() => p.category = c)),
          Row(children: [
            if (_mode != SplitMode.equal)
              Expanded(
                child: TextField(
                  controller: p.input,
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  inputFormatters: _mode == SplitMode.exact ? [MoneyInputFormatter()] : null,
                  decoration: InputDecoration(suffixText: _mode == SplitMode.percent ? '%' : null),
                  onChanged: (_) => setState(() {}),
                ),
              )
            else
              Expanded(child: Text(amounts == null ? '' : prefs.money(amounts[i]), textDirection: TextDirection.ltr)),
            if (_parts.length > 2)
              IconButton(
                tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                icon: Icon(appIcon('x')),
                onPressed: () => setState(() => _parts.removeAt(i).input.dispose()),
              ),
          ]),
        ],
        TextButton.icon(
          onPressed: () => setState(() => _parts.add(_Part())),
          icon: Icon(appIcon('plus')),
          label: Text(l.addPart),
        ),
        if (_mode != SplitMode.equal)
          Row(children: [
            Expanded(child: Text(l.partsLeft, style: Theme.of(context).textTheme.titleSmall)),
            Text(
              _mode == SplitMode.exact ? prefs.money(widget.total - entered) : '${prefs.digits('${100 - entered}')}%',
              textDirection: TextDirection.ltr,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ]),
        if (!ok && _parts.every((p) => p.input.text.isNotEmpty || _mode == SplitMode.equal) && _parts.every((p) => p.category != null))
          Text(l.catSplitInvalid, style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ]),
    );
  }
}

/// Shows the current category split (if any) with edit/remove, or the button that starts one.
class CatSplitView extends ConsumerWidget {
  const CatSplitView({super.key, required this.kind, required this.total, required this.parts, required this.onChanged});
  final CategoryKind kind;
  final int total; // positive Rial; 0 = amount not known yet
  final List<(int, int)> parts;

  /// Empty list = split removed.
  final ValueChanged<List<(int, int)>> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final cats = ref.watch(categoryMapProvider);
    Future<void> edit() async {
      final r = await showCategorySplit(context, kind: kind, total: total, initial: parts);
      if (r != null) onChanged(r);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (parts.isNotEmpty)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              for (final (c, a) in parts)
                if (cats[c] case final cat?)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: IconAvatar(cat.icon, cat.color, size: 32),
                    title: Text(displayName(cat.name, cat.nameKey, prefs.lang)),
                    trailing: Text(prefs.money(a), textDirection: TextDirection.ltr),
                  ),
            ]),
          ),
        ),
      OutlinedButton.icon(
        onPressed: total > 0 ? edit : null,
        icon: Icon(appIcon('git-fork')),
        label: Text(parts.isEmpty ? l.catSplit : l.editCatSplit),
        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      ),
      if (parts.isNotEmpty) TextButton(onPressed: () => onChanged(const []), child: Text(l.removeCatSplit)),
    ]);
  }
}

/// Detail-sheet wrapper: reads the saved split and writes changes straight to the DB.
class TxCatSplit extends ConsumerWidget {
  const TxCatSplit({super.key, required this.txId, required this.amount});
  final int txId, amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parts = ref.watch(txPartsProvider(txId)).value ?? const <TxPart>[];
    final repo = ref.read(repoProvider);
    return CatSplitView(
      kind: amount < 0 ? CategoryKind.expense : CategoryKind.income,
      total: amount.abs(),
      parts: [for (final p in parts) (p.categoryId, p.amount)],
      // Removing keeps the largest part's category (already in transactions.category_id).
      onChanged: (r) => r.isEmpty ? repo.setCategory([txId], null) : repo.setParts(txId, r),
    );
  }
}
