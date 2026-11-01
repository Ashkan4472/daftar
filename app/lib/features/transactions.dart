import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../db/database.dart';
import '../db/seed.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/format.dart';
import '../ui/pickers.dart';
import '../ui/widgets.dart';
import 'tx_sheet.dart';

enum _Quick { all, expense, income, review, marked, gap }

/// Transaction list with search, filters, bulk select and infinite scroll.
///
/// As a tab it follows the global month. With [initial] (drill-down from
/// reports) it shows exactly that filter.
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key, this.initial, this.title});
  final TxFilter? initial;
  final String? title;

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  static const _page = 100;
  late TxFilter _f = widget.initial ?? const TxFilter();
  final _search = TextEditingController();
  Timer? _debounce;
  bool _allMonths = false;
  int _limit = _page;
  final Set<int> _selected = {};

  bool get _drill => widget.initial != null;

  _Quick get _quick {
    if (_f.toReview) return _Quick.review;
    if (_f.marked) return _Quick.marked;
    if (_f.hasGap) return _Quick.gap;
    return switch (_f.kind) {
      TxKind.expense => _Quick.expense,
      TxKind.income => _Quick.income,
      _ => _Quick.all,
    };
  }

  void _setQuick(_Quick q) => setState(() {
        _limit = _page;
        _f = TxFilter(
          ym: _f.ym, from: _f.from, to: _f.to, query: _f.query,
          categoryIds: _f.categoryIds, tagId: _f.tagId, accountId: _f.accountId, personId: _f.personId,
          kind: q == _Quick.expense ? TxKind.expense : q == _Quick.income ? TxKind.income : null,
          toReview: q == _Quick.review,
          marked: q == _Quick.marked,
          hasGap: q == _Quick.gap,
        );
      });

  /// Month scoping is applied last so searching can span every month.
  TxFilter _effective(int month) {
    if (_drill) return _f;
    final searching = _f.query.isNotEmpty;
    return _f.copyWith(ym: (_allMonths || searching) ? null : month);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _toggle(int id) => setState(() => _selected.contains(id) ? _selected.remove(id) : _selected.add(id));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final month = ref.watch(monthProvider);
    final f = _effective(month);
    final rows = ref.watch(txListProvider((f, _limit)));
    final selecting = _selected.isNotEmpty;
    final reviewCount = ref.watch(txCountProvider(f.copyWith(toReview: true, marked: false, hasGap: false, kind: null))).value ?? 0;

    return PopScope(
      canPop: !selecting,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && selecting) setState(_selected.clear);
      },
      child: Scaffold(
        appBar: selecting ? _selectionBar(context) : AppBar(title: Text(widget.title ?? l.tabTransactions)),
        body: Column(children: [
          if (!_drill) const Padding(padding: EdgeInsets.only(bottom: 4), child: Center(child: MonthPill())),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l.search,
                prefixIcon: Icon(appIcon('magnifying-glass')),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l.cancel,
                        icon: Icon(appIcon('x')),
                        onPressed: () {
                          _search.clear();
                          setState(() => _f = _f.copyWith(query: ''));
                        },
                      ),
              ),
              onChanged: (v) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  if (mounted) {
                    setState(() {
                      _f = _f.copyWith(query: v);
                      _limit = _page;
                    });
                  }
                });
              },
            ),
          ),
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                if (!_drill)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: FilterChip(
                      label: Text(l.allMonths),
                      selected: _allMonths,
                      showCheckmark: false,
                      onSelected: (v) => setState(() {
                        _allMonths = v;
                        _limit = _page;
                      }),
                    ),
                  ),
                _chip(l.filterAll, _Quick.all),
                _chip(l.filterExpense, _Quick.expense),
                _chip(l.filterIncome, _Quick.income),
                _chip(reviewCount > 0 ? '${l.filterToReview} · ${ref.read(prefsProvider).digits('$reviewCount')}' : l.filterToReview, _Quick.review),
                _chip(l.filterMarked, _Quick.marked),
                _chip(l.filterGap, _Quick.gap),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ActionChip(
                    avatar: Icon(appIcon('sliders-horizontal'), size: 18),
                    label: Text(_extraCount == 0 ? l.moreFilters : '${l.moreFilters} · ${ref.read(prefsProvider).digits('$_extraCount')}'),
                    onPressed: _openFilters,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: rows.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (rows) => rows.isEmpty ? _empty(context, l) : _list(context, rows),
            ),
          ),
        ]),
      ),
    );
  }

  int get _extraCount => [_f.categoryIds != null, _f.tagId != null, _f.accountId != null, _f.personId != null].where((b) => b).length;

  Widget _chip(String label, _Quick q) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: ChoiceChip(label: Text(label), selected: _quick == q, onSelected: (_) => _setQuick(q)),
      );

  Widget _empty(BuildContext context, AppLocalizations l) {
    final filtered = _f.query.isNotEmpty || _f.activeCount > 0;
    return EmptyState(
      icon: filtered ? 'funnel-x' : 'receipt',
      title: filtered ? l.noResults : l.noTransactions,
      hint: filtered ? l.noResultsHint : l.noTransactionsHint,
      action: filtered
          ? OutlinedButton(
              onPressed: () => setState(() {
                _search.clear();
                _f = TxFilter(ym: _f.ym, from: _f.from, to: _f.to);
              }),
              child: Text(l.clearFilters),
            )
          : FilledButton.icon(onPressed: () => showAddSheet(context), icon: Icon(appIcon('plus')), label: Text(l.addTransaction)),
    );
  }

  Widget _list(BuildContext context, List<TxRow> rows) {
    final prefs = ref.watch(prefsProvider);
    final items = <Object>[];
    int? day;
    for (final r in rows) {
      final j = Jalali.fromDateTime(r.tx.occurredAt);
      final key = j.year * 10000 + j.month * 100 + j.day;
      if (key != day) {
        items.add(r.tx.occurredAt);
        day = key;
      }
      items.add(r);
    }
    final months = prefs.persian ? jalaliMonthsFa : jalaliMonthsEn;
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: items.length,
      itemExtentBuilder: (i, _) => i >= items.length ? null : (items[i] is DateTime ? 40 : 68),
      itemBuilder: (context, i) {
        if (i >= items.length - 8 && rows.length >= _limit) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && rows.length >= _limit) setState(() => _limit += _page);
          });
        }
        final it = items[i];
        if (it is DateTime) {
          final j = Jalali.fromDateTime(it);
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 4),
            child: Text(prefs.digits('${j.day} ${months[j.month - 1]} ${j.year}'),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: context.money.muted)),
          );
        }
        final row = it as TxRow;
        return TransactionTile(
          row,
          key: ValueKey(row.tx.id),
          selected: _selected.contains(row.tx.id),
          selecting: _selected.isNotEmpty,
          onTap: () => _selected.isNotEmpty ? _toggle(row.tx.id) : showTxSheet(context, row.tx.id),
          onLongPress: () => _toggle(row.tx.id),
        );
      },
    );
  }

  PreferredSizeWidget _selectionBar(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.read(prefsProvider);
    final repo = ref.read(repoProvider);
    final ids = _selected.toList();
    return AppBar(
      leading: IconButton(tooltip: l.cancel, icon: Icon(appIcon('x')), onPressed: () => setState(_selected.clear)),
      title: Text(prefs.digits(l.selectedCount(ids.length))),
      actions: [
        IconButton(tooltip: l.category, icon: Icon(appIcon('squares-four')), onPressed: () => _bulkCategory(ids)),
        IconButton(
          tooltip: l.mark,
          icon: Icon(appIcon('star')),
          onPressed: () {
            repo.setMarked(ids, true);
            setState(_selected.clear);
          },
        ),
        IconButton(
          tooltip: l.delete,
          icon: Icon(appIcon('trash')),
          onPressed: () {
            repo.softDelete(ids);
            setState(_selected.clear);
            showUndo(context, l.movedToTrash, () => repo.restore(ids));
          },
        ),
      ],
    );
  }

  Future<void> _bulkCategory(List<int> ids) async {
    final repo = ref.read(repoProvider);
    final rows = [for (final id in ids) await repo.get(id)];
    final allIncome = rows.every((r) => r != null && r.tx.amount > 0);
    if (!mounted) return;
    final picked = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: SingleChildScrollView(
          child: CategoryPicker(
            kind: allIncome ? CategoryKind.income : CategoryKind.expense,
            selected: null,
            onChanged: (c) => Navigator.pop(ctx, c),
          ),
        ),
      ),
    );
    if (picked != null) {
      await repo.setCategory(ids, picked);
      if (mounted) setState(_selected.clear);
    }
  }

  Future<void> _openFilters() async {
    final res = await showModalBottomSheet<TxFilter>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _FilterSheet(_f),
    );
    if (res != null) {
      setState(() {
        _f = res;
        _limit = _page;
      });
    }
  }
}

class TransactionTile extends ConsumerWidget {
  const TransactionTile(this.row, {super.key, this.selected = false, this.selecting = false, this.onTap, this.onLongPress});
  final TxRow row;
  final bool selected, selecting;
  final VoidCallback? onTap, onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final tagMap = ref.watch(tagMapProvider);
    final tx = row.tx;
    final c = row.category;
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final muted = context.money.muted;
    final gap = tx.balanceGap ?? 0;
    final isTransfer = tx.kind == TxKind.transfer;
    final title = isTransfer ? l.transfer : c == null ? l.uncategorized : displayName(c.name, c.nameKey, prefs.lang);
    final part = row.partAmount;
    final sub = [
      if (part != null) prefs.money(tx.amount.abs()),
      if (tx.note.isNotEmpty) tx.note else row.account.name,
      fmtTime(prefs, tx.occurredAt),
    ].join(' · ');

    return Semantics(
      selected: selected,
      label: '$title, ${prefs.money(tx.amount, signed: true)}',
      child: Material(
        color: selected ? scheme.primary.withValues(alpha: 0.10) : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              selecting
                  ? SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(selected ? Icons.check_circle : Icons.radio_button_unchecked, color: selected ? scheme.primary : muted),
                    )
                  : c == null || isTransfer
                      ? IconAvatar(isTransfer ? 'arrows-left-right:regular' : 'question:regular', muted.toARGB32(), size: 44)
                      : IconAvatar(c.icon, c.color, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500, color: c == null && !isTransfer ? muted : null)),
                  const SizedBox(height: 2),
                  Row(children: [
                    if (gap != 0) ...[Icon(appIcon('warning:fill'), size: 14, color: context.money.warning), const SizedBox(width: 4)],
                    if (tx.marked) ...[Icon(appIcon('star:fill'), size: 14, color: context.money.warning), const SizedBox(width: 4)],
                    if (tx.needsReview && tx.source == TxSource.sms) ...[Icon(appIcon('seal-question'), size: 14, color: context.money.warning), const SizedBox(width: 4)],
                    for (final id in row.tagIds.take(3))
                      if (tagMap[id] != null) Padding(padding: const EdgeInsetsDirectional.only(end: 4), child: TagDot(tagMap[id]!.icon, tagMap[id]!.color)),
                    Flexible(child: Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodySmall?.copyWith(color: muted))),
                  ]),
                ]),
              ),
              const SizedBox(width: 8),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                Amount(part == null ? tx.amount : (tx.amount < 0 ? -part : part), neutral: isTransfer),
                if (tx.balanceAfter != null)
                  Text(prefs.money(tx.balanceAfter!), textDirection: TextDirection.ltr, style: t.bodySmall?.copyWith(color: muted, fontFeatures: tabular)),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

class _FilterSheet extends ConsumerStatefulWidget {
  const _FilterSheet(this.initial);
  final TxFilter initial;

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  late TxFilter _f = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final cats = (ref.watch(categoriesProvider).value ?? const <Category>[]).where((c) => c.parentId == null && !c.archived).toList();
    final all = ref.watch(categoriesProvider).value ?? const <Category>[];
    final tags = ref.watch(tagsProvider).value ?? const <Tag>[];
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final people = ref.watch(peopleProvider).value ?? const <Person>[];

    List<int> idsFor(Category c) => [c.id, ...all.where((k) => k.parentId == c.id).map((k) => k.id)];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(children: [
        Expanded(
          child: ListView(controller: scroll, padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
            Text(l.moreFilters, style: Theme.of(context).textTheme.titleLarge),
            SectionHeader(l.category),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final c in cats)
                FilterChip(
                  avatar: Icon(appIcon(c.icon), size: 18, color: Color(c.color)),
                  label: Text(displayName(c.name, c.nameKey, prefs.lang)),
                  selected: _f.categoryIds?.contains(c.id) ?? false,
                  showCheckmark: false,
                  onSelected: (v) => setState(() => _f = _f.copyWith(categoryIds: v ? idsFor(c) : null)),
                ),
            ]),
            if (tags.isNotEmpty) ...[
              SectionHeader(l.tags),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final t in tags)
                  FilterChip(
                    avatar: Icon(appIcon(t.icon), size: 18, color: Color(t.color)),
                    label: Text(displayName(t.name, t.nameKey, prefs.lang)),
                    selected: _f.tagId == t.id,
                    showCheckmark: false,
                    onSelected: (v) => setState(() => _f = _f.copyWith(tagId: v ? t.id : null)),
                  ),
              ]),
            ],
            SectionHeader(l.accounts),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final a in accounts)
                FilterChip(
                  avatar: Icon(appIcon(a.icon), size: 18, color: Color(a.color)),
                  label: Text(a.name),
                  selected: _f.accountId == a.id,
                  showCheckmark: false,
                  onSelected: (v) => setState(() => _f = _f.copyWith(accountId: v ? a.id : null)),
                ),
            ]),
            if (people.isNotEmpty) ...[
              SectionHeader(l.tabPeople),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final p in people)
                  FilterChip(
                    avatar: Icon(appIcon(p.icon), size: 18, color: Color(p.color)),
                    label: Text(p.name),
                    selected: _f.personId == p.id,
                    showCheckmark: false,
                    onSelected: (v) => setState(() => _f = _f.copyWith(personId: v ? p.id : null)),
                  ),
              ]),
            ],
          ]),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(children: [
              OutlinedButton(
                onPressed: () => setState(() => _f = _f.copyWith(categoryIds: null, tagId: null, accountId: null, personId: null)),
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
                child: Text(l.clearFilters),
              ),
              const SizedBox(width: 12),
              Expanded(child: FilledButton(onPressed: () => Navigator.pop(context, _f), child: Text(l.applyFilters))),
            ]),
          ),
        ),
      ]),
    );
  }
}
