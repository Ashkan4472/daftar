import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../db/database.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/format.dart';
import '../ui/pickers.dart';
import '../ui/widgets.dart';
import 'cat_split.dart';
import 'tx_extras.dart';

Future<void> showTxSheet(BuildContext context, int id) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => TxDetailSheet(id),
    );

Future<void> showAddSheet(BuildContext context, {int? editId}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AddTxSheet(editId: editId),
    );

// ---- detail ---------------------------------------------------------------------

class TxDetailSheet extends ConsumerWidget {
  const TxDetailSheet(this.id, {super.key});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final row = ref.watch(txOneProvider(id)).value;
    final repo = ref.read(repoProvider);
    if (row == null)
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    final tx = row.tx;
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final gap = tx.balanceGap ?? 0;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(
        children: [
          Expanded(
            child: ListView(
              controller: scroll,
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                16 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              children: [
                Row(
                  children: [
                    row.category == null
                        ? IconAvatar(
                            'question:regular',
                            context.money.muted.toARGB32(),
                            size: 52,
                          )
                        : IconAvatar(
                            row.category!.icon,
                            row.category!.color,
                            size: 52,
                          ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Amount(
                            tx.amount,
                            style: t.headlineSmall,
                            neutral: tx.kind == TxKind.transfer,
                          ),
                          Text(
                            '${fmtDate(prefs, tx.occurredAt)} · ${fmtTime(prefs, tx.occurredAt)}',
                            style: t.bodyMedium,
                          ),
                          Text(
                            '${row.account.name} · ${fmtGregorian(tx.occurredAt)}',
                            style: context.mutedStyle,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: tx.marked ? l.unmark : l.mark,
                      iconSize: 28,
                      onPressed: () => repo.setMarked([id], !tx.marked),
                      icon: Icon(
                        appIcon(tx.marked ? 'star:fill' : 'star'),
                        color: tx.marked
                            ? context.money.warning
                            : context.money.muted,
                      ),
                    ),
                  ],
                ),
                if (tx.needsReview && tx.source == TxSource.sms)
                  _Banner(
                    icon: 'warning',
                    color: context.money.warning,
                    text: l.needsReviewHint,
                  ),
                if (gap != 0)
                  _Banner(
                    icon: 'warning-circle',
                    color: context.money.warning,
                    title: l.gapTitle,
                    text: l.gapExplain(
                      '\u2066${prefs.money(gap, signed: true)}\u2069',
                    ),
                  ),
                const SizedBox(height: 8),
                if (tx.kind == TxKind.transfer)
                  Chip(
                    avatar: Icon(appIcon('arrows-left-right')),
                    label: Text(l.transfer),
                  )
                else ...[
                  SectionHeader(l.category),
                  CategoryField(
                    kind: tx.amount < 0
                        ? CategoryKind.expense
                        : CategoryKind.income,
                    selected: tx.categoryId,
                    onChanged: (c) => repo.setCategory([id], c),
                  ),
                  const SizedBox(height: 8),
                  TxCatSplit(txId: id, amount: tx.amount),
                ],
                SectionHeader(l.tags),
                TagSelector(
                  selected: row.tagIds.toSet(),
                  onToggle: (tag, on) =>
                      on ? repo.addTag([id], tag) : repo.removeTag([id], tag),
                ),
                SectionHeader(l.note),
                NoteField(initial: tx.note, onSave: (v) => repo.setNote(id, v)),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.excludeFromReports),
                  subtitle: Text(l.excludeHint),
                  value: tx.excluded,
                  onChanged: (v) => repo.setExcluded(id, v),
                ),
                TxExtras(txId: id, amount: tx.amount),
                const Divider(height: 24),
                if (tx.balanceAfter != null)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(appIcon('wallet')),
                    title: Text(l.balanceAfter),
                    trailing: Text(
                      prefs.money(tx.balanceAfter!),
                      textDirection: TextDirection.ltr,
                      style: t.titleSmall,
                    ),
                  ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(appIcon('info')),
                  title: Text(switch (tx.source) {
                    TxSource.sms => l.sourceSms,
                    TxSource.manual => l.sourceManual,
                    TxSource.import => l.sourceImport,
                  }),
                ),
                if (tx.rawSmsId != null) _RawSms(tx.rawSmsId!),
              ],
            ),
          ),
          BottomBar(
            child: Row(
              children: [
                if (tx.source == TxSource.manual)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => showAddSheet(context, editId: id),
                      icon: Icon(appIcon('pencil-simple')),
                      label: Text(l.edit),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                if (tx.source == TxSource.manual) const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final messenger = ScaffoldMessenger.of(context);
                      Navigator.pop(context);
                      repo.softDelete([id]);
                      messenger.clearSnackBars();
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(l.movedToTrash),
                          action: SnackBarAction(
                            label: l.undo,
                            onPressed: () => repo.restore([id]),
                          ),
                        ),
                      );
                    },
                    icon: Icon(appIcon('trash'), color: scheme.error),
                    label: Text(
                      l.delete,
                      style: TextStyle(color: scheme.error),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: BorderSide(
                        color: scheme.error.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.color,
    required this.text,
    this.title,
  });
  final String icon, text;
  final String? title;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(appIcon(icon), color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(title!, style: Theme.of(context).textTheme.titleSmall),
              Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    ),
  );
}

class _RawSms extends ConsumerWidget {
  const _RawSms(this.id);
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final db = ref.watch(dbProvider);
    return FutureBuilder(
      future: (db.select(
        db.rawSms,
      )..where((r) => r.id.equals(id))).getSingleOrNull(),
      builder: (context, snap) {
        final r = snap.data;
        if (r == null) return const SizedBox.shrink();
        return ExpansionTile(
          tilePadding: EdgeInsets.zero,
          shape: const Border(),
          collapsedShape: const Border(),
          leading: Icon(appIcon('chat-text')),
          title: Text(l.originalSms),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                '${r.address}\n\n${r.body}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Autosaving note field: saves 500ms after typing stops and when closed.
class NoteField extends StatefulWidget {
  const NoteField({super.key, required this.initial, required this.onSave});
  final String initial;
  final void Function(String) onSave;

  @override
  State<NoteField> createState() => _NoteFieldState();
}

class _NoteFieldState extends State<NoteField> {
  late final _c = TextEditingController(text: widget.initial);
  Timer? _t;
  late String _saved = widget.initial;

  void _flush() {
    _t?.cancel();
    if (_c.text != _saved) {
      _saved = _c.text;
      widget.onSave(_c.text);
    }
  }

  @override
  void dispose() {
    _flush();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _c,
    minLines: 2,
    maxLines: 5,
    textInputAction: TextInputAction.newline,
    decoration: InputDecoration(hintText: AppLocalizations.of(context).addNote),
    onChanged: (_) {
      _t?.cancel();
      _t = Timer(const Duration(milliseconds: 500), _flush);
    },
    onTapOutside: (_) {
      _flush();
      FocusScope.of(context).unfocus();
    },
  );
}

// ---- add / edit -------------------------------------------------------------------

class AddTxSheet extends ConsumerStatefulWidget {
  const AddTxSheet({super.key, this.editId});
  final int? editId;

  @override
  ConsumerState<AddTxSheet> createState() => _AddTxSheetState();
}

class _AddTxSheetState extends ConsumerState<AddTxSheet> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  int _type = 0; // 0 expense, 1 income, 2 transfer
  int? _toAccount;
  bool get _expense => _type == 0;
  int? _account, _category;
  List<(int, int)>? _parts; // category split; null = single category
  DateTime _at = DateTime.now();
  final Set<int> _tags = {};
  String? _error;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    final id = widget.editId;
    if (id != null) {
      ref.read(repoProvider).get(id).then((row) async {
        if (row == null || !mounted) return;
        final saved = await (ref.read(dbProvider).select(ref.read(dbProvider).txParts)..where((p) => p.transactionId.equals(id))).get();
        if (!mounted) return;
        if (saved.isNotEmpty) _parts = [for (final p in saved) (p.categoryId, p.amount)];
        final prefs = ref.read(prefsProvider);
        final units = row.tx.amount.abs() ~/ (prefs.toman ? 10 : 1);
        setState(() {
          _type = row.tx.amount < 0 ? 0 : 1;
          _amount.text = formatMoney(units);
          _note.text = row.tx.note;
          _account = row.tx.accountId;
          _category = row.tx.categoryId;
          _at = row.tx.occurredAt;
          _tags.addAll(row.tagIds);
          _loaded = true;
        });
      });
    } else {
      ref.read(repoProvider).setting('last_account').then((v) {
        if (mounted && v != null) setState(() => _account = int.tryParse(v));
      });
      _loaded = true;
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final j = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.fromDateTime(_at),
      firstDate: Jalali(1390),
      lastDate: Jalali.now().addDays(1),
    );
    if (j != null) {
      final d = j.toDateTime();
      setState(
        () => _at = DateTime(d.year, d.month, d.day, _at.hour, _at.minute),
      );
    }
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_at),
    );
    if (t != null)
      setState(
        () => _at = DateTime(_at.year, _at.month, _at.day, t.hour, t.minute),
      );
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final prefs = ref.read(prefsProvider);
    final units = parseMoney(_amount.text);
    if (units == null || units == 0) {
      setState(() => _error = l.amountRequired);
      return;
    }
    final rial = units * (prefs.toman ? 10 : 1) * (_expense ? -1 : 1);
    final isTransfer = _type == 2 && widget.editId == null;
    final repo = ref.read(repoProvider);
    final accounts = ref.read(accountsProvider).value ?? const <Account>[];
    final account =
        _account ??
        accounts
            .firstWhere(
              (a) => a.kind == AccountKind.cash,
              orElse: () => accounts.first,
            )
            .id;
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    if (isTransfer) {
      if (_toAccount == null || _toAccount == account) {
        setState(() => _error = l.transferPick);
        return;
      }
      await repo.addTransfer(
        from: account,
        to: _toAccount!,
        amount: units * (prefs.toman ? 10 : 1),
        at: _at,
        note: _note.text.trim(),
      );
      nav.pop();
      return;
    }
    if (_parts != null && _parts!.fold<int>(0, (a, p) => a + p.$2) != rial.abs()) {
      setState(() => _error = l.catSplitStale);
      return;
    }
    await repo.putSetting('last_account', '$account');
    if (widget.editId != null) {
      final id = widget.editId!;
      await repo.updateManual(id, amount: rial, at: _at);
      await (_parts != null ? repo.setParts(id, _parts!) : repo.setCategory([id], _category));
      await repo.setNote(id, _note.text.trim());
      final old = (await repo.get(id))!.tagIds.toSet();
      for (final t in old.difference(_tags)) {
        await repo.removeTag([id], t);
      }
      for (final t in _tags.difference(old)) {
        await repo.addTag([id], t);
      }
      nav.pop();
      return;
    }
    final id = await repo.addManual(
      amount: rial,
      accountId: account,
      at: _at,
      categoryId: _category,
      note: _note.text.trim(),
      tagIds: _tags,
    );
    if (_parts != null) await repo.setParts(id, _parts!);
    nav.pop();
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(prefs.money(rial, signed: true)),
        action: SnackBarAction(
          label: l.undo,
          onPressed: () => repo.softDelete([id]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final accounts = (ref.watch(accountsProvider).value ?? const <Account>[])
        .where((a) => !a.archived)
        .toList();
    final account =
        _account ??
        accounts
            .where((a) => a.kind == AccountKind.cash)
            .map((a) => a.id)
            .firstOrNull;
    final editing = widget.editId != null;
    final t = Theme.of(context).textTheme;
    final color = _type == 2
        ? context.money.transfer
        : _expense
        ? context.money.expense
        : context.money.income;

    if (!_loaded)
      return const SizedBox(
        height: 240,
        child: Center(child: CircularProgressIndicator()),
      );
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.92,
        maxChildSize: 0.95,
        builder: (context, scroll) => Column(
          children: [
            Expanded(
              child: ListView(
                controller: scroll,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Text(
                    editing ? l.edit : l.addTransaction,
                    style: t.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<int>(
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    segments: [
                      ButtonSegment(
                        value: 0,
                        label: Text(l.typeExpense),
                        icon: Icon(appIcon('arrow-up-right')),
                      ),
                      ButtonSegment(
                        value: 1,
                        label: Text(l.typeIncome),
                        icon: Icon(appIcon('arrow-down-left')),
                      ),
                      if (!editing)
                        ButtonSegment(
                          value: 2,
                          label: Text(l.typeTransfer),
                          icon: Icon(appIcon('arrows-left-right')),
                        ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (s) => setState(() {
                      _type = s.first;
                      _category = null;
                      _error = null;
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amount,
                    autofocus: !editing,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    inputFormatters: [MoneyInputFormatter()],
                    style: t.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontFeatures: tabular,
                    ),
                    decoration: InputDecoration(
                      labelText: l.amount,
                      suffixText: prefs.toman ? l.toman : l.rial,
                      errorText: _error,
                    ),
                    onChanged: (_) => setState(() => _error = null),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: Icon(appIcon('calendar-blank')),
                          label: Text(fmtDate(prefs, _at)),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _pickTime,
                        icon: Icon(appIcon('clock')),
                        label: Text(fmtTime(prefs, _at)),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                        ),
                      ),
                    ],
                  ),
                  if (!editing && _type == 2) ...[
                    SectionHeader(l.transferFrom),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final a in accounts)
                          ChoiceChip(
                            avatar: Icon(
                              appIcon(a.icon),
                              size: 18,
                              color: Color(a.color),
                            ),
                            label: Text(a.name),
                            selected: account == a.id,
                            onSelected: (_) => setState(() => _account = a.id),
                          ),
                      ],
                    ),
                    SectionHeader(l.transferTo),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final a in accounts)
                          ChoiceChip(
                            avatar: Icon(
                              appIcon(a.icon),
                              size: 18,
                              color: Color(a.color),
                            ),
                            label: Text(a.name),
                            selected: _toAccount == a.id,
                            onSelected: (_) =>
                                setState(() => _toAccount = a.id),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        l.transferManualHint,
                        style: context.mutedStyle,
                      ),
                    ),
                  ] else if (!editing && accounts.length > 1) ...[
                    SectionHeader(l.account),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final a in accounts)
                          ChoiceChip(
                            avatar: Icon(
                              appIcon(a.icon),
                              size: 18,
                              color: Color(a.color),
                            ),
                            label: Text(a.name),
                            selected: account == a.id,
                            onSelected: (_) => setState(() => _account = a.id),
                          ),
                      ],
                    ),
                  ],
                  if (_type != 2) ...[
                    SectionHeader(l.category),
                    if (_parts == null)
                      CategoryPicker(
                        kind: _expense
                            ? CategoryKind.expense
                            : CategoryKind.income,
                        selected: _category,
                        onChanged: (c) => setState(() => _category = c),
                      ),
                    CatSplitView(
                      kind: _expense ? CategoryKind.expense : CategoryKind.income,
                      total: (parseMoney(_amount.text) ?? 0) * (prefs.toman ? 10 : 1),
                      parts: _parts ?? const [],
                      onChanged: (r) => setState(() {
                        _parts = r.length < 2 ? null : r;
                        if (r.isNotEmpty) _category = r.reduce((a, b) => b.$2 > a.$2 ? b : a).$1;
                      }),
                    ),
                    SectionHeader(l.tags),
                    TagSelector(
                      selected: _tags,
                      onToggle: (id, on) =>
                          setState(() => on ? _tags.add(id) : _tags.remove(id)),
                    ),
                  ],
                  SectionHeader(l.note),
                  TextField(
                    controller: _note,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(hintText: l.addNote),
                  ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: Text(l.save),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
