import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/format.dart';
import '../ui/pickers.dart';
import '../ui/widgets.dart';
import 'tx_sheet.dart';

/// One transaction at a time: tap a category and the next one appears.
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  List<int>? _ids; // snapshot, so rows do not vanish from under the user
  int _i = 0;
  int? _suggestion;

  @override
  void initState() {
    super.initState();
    ref.read(repoProvider).query(const TxFilter(toReview: true)).get().then((rs) {
      if (!mounted) return;
      setState(() => _ids = [for (final r in rs) r.readTable(ref.read(dbProvider).transactions).id]);
      _loadSuggestion();
    });
  }

  Future<void> _loadSuggestion() async {
    final ids = _ids;
    if (ids == null || _i >= ids.length) return;
    final row = await ref.read(repoProvider).get(ids[_i]);
    if (row == null) return;
    final db = ref.read(dbProvider);
    final prev = await (db.select(db.transactions)
          ..where((t) => t.accountId.equals(row.tx.accountId) & t.amount.equals(row.tx.amount) & t.categoryId.isNotNull() & t.id.equals(row.tx.id).not())
          ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])
          ..limit(1))
        .getSingleOrNull();
    if (mounted && _ids != null && _i < _ids!.length && _ids![_i] == row.tx.id) setState(() => _suggestion = prev?.categoryId);
  }

  void _go(int to) {
    setState(() {
      _i = to;
      _suggestion = null;
    });
    _loadSuggestion();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final ids = _ids;
    final done = ids != null && _i >= ids.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.reviewTitle),
        bottom: ids == null || ids.isEmpty
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(value: (_i / ids.length).clamp(0, 1).toDouble(), minHeight: 4),
              ),
        actions: [
          if (ids != null && ids.isNotEmpty && !done)
            Center(child: Padding(padding: const EdgeInsetsDirectional.only(end: 16), child: Text(prefs.digits(l.reviewProgress(_i + 1, ids.length))))),
        ],
      ),
      body: ids == null
          ? const Center(child: CircularProgressIndicator())
          : (ids.isEmpty || done)
              ? EmptyState(
                  icon: 'check-circle:duotone',
                  title: l.reviewDone,
                  hint: l.reviewDoneHint,
                  action: FilledButton(onPressed: () => Navigator.pop(context), child: Text(l.done)),
                )
              : _Card(key: ValueKey(ids[_i]), id: ids[_i], suggestion: _suggestion, onNext: () => _go(_i + 1), onPrev: _i > 0 ? () => _go(_i - 1) : null),
    );
  }
}

class _Card extends ConsumerWidget {
  const _Card({super.key, required this.id, required this.suggestion, required this.onNext, this.onPrev});
  final int id;
  final int? suggestion;
  final VoidCallback onNext;
  final VoidCallback? onPrev;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final row = ref.watch(txOneProvider(id)).value;
    final repo = ref.read(repoProvider);
    if (row == null) return const SizedBox.shrink();
    final tx = row.tx;
    final t = Theme.of(context).textTheme;
    return Column(children: [
      Expanded(
        child: ListView(padding: const EdgeInsets.all(16), children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Amount(tx.amount, style: t.headlineMedium)),
                  IconButton(
                    tooltip: tx.marked ? l.unmark : l.mark,
                    onPressed: () => repo.setMarked([id], !tx.marked),
                    icon: Icon(appIcon(tx.marked ? 'star:fill' : 'star'), color: tx.marked ? context.money.warning : context.money.muted),
                  ),
                ]),
                Text('${fmtDate(prefs, tx.occurredAt)} · ${fmtTime(prefs, tx.occurredAt)}', style: t.bodyMedium),
                Text(row.account.name, style: context.mutedStyle),
                if (tx.note.isNotEmpty) ...[const SizedBox(height: 8), Text(tx.note)],
              ]),
            ),
          ),
          SectionHeader(l.pickCategory),
          CategoryPicker(
            kind: tx.amount < 0 ? CategoryKind.expense : CategoryKind.income,
            selected: tx.categoryId,
            suggestion: suggestion,
            onChanged: (c) async {
              await repo.setCategory([id], c);
              if (c != null) onNext();
            },
          ),
          SectionHeader(l.tags),
          TagSelector(selected: row.tagIds.toSet(), onToggle: (tag, on) => on ? repo.addTag([id], tag) : repo.removeTag([id], tag)),
          SectionHeader(l.note),
          NoteField(initial: tx.note, onSave: (v) => repo.setNote(id, v)),
        ]),
      ),
      SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(children: [
            OutlinedButton(
              onPressed: onPrev,
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
              child: Text(l.previous),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.tonal(
                onPressed: () async {
                  // Leaving a "needs review" SMS row means it was looked at.
                  if (tx.categoryId != null) await repo.setCategory([id], tx.categoryId);
                  onNext();
                },
                child: Text(tx.categoryId == null ? l.skip : l.done),
              ),
            ),
          ]),
        ),
      ),
    ]);
  }
}
