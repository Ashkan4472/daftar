import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/seed.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../state.dart';
import '../theme/palette.dart';
import '../theme/theme.dart';
import '../ui/format.dart';
import '../ui/pickers.dart';
import 'balance_sheet.dart';
import 'transactions.dart';
import '../ui/widgets.dart';

/// Generic "name + icon + color" editor used for categories, tags, accounts, people.
class EntitySheet extends StatefulWidget {
  const EntitySheet({
    super.key,
    required this.title,
    required this.name,
    required this.icon,
    required this.color,
    required this.onSave,
    this.extra,
    this.footer = const [],
    this.nameLabel,
  });
  final String title, name, icon;
  final String? nameLabel;
  final int color;

  /// Called with (name, icon, color, nameChanged).
  final Future<void> Function(String name, String icon, int color, bool nameChanged) onSave;

  /// Extra fields; rebuilt on setState of the sheet.
  final Widget Function(BuildContext, void Function(VoidCallback))? extra;
  final List<Widget> footer;

  @override
  State<EntitySheet> createState() => _EntitySheetState();
}

class _EntitySheetState extends State<EntitySheet> {
  late final _name = TextEditingController(text: widget.name);
  late String _icon = widget.icon;
  late int _color = widget.color;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final r = await showIconPicker(context, icon: _icon, color: _color);
    if (r != null) {
      setState(() {
        _icon = r.icon;
        _color = r.color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SheetFrame(
      action: FilledButton(
        onPressed: () async {
          final n = _name.text.trim();
          if (n.isEmpty) {
            setState(() => _error = l.nameRequired);
            return;
          }
          final nav = Navigator.of(context);
          try {
            await widget.onSave(n, _icon, _color, n != widget.name);
          } on StateError {
            setState(() {}); // onSave refused (e.g. duplicate number) and set its own error text
            return;
          }
          nav.pop();
        },
        child: Text(l.save),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Row(children: [
          Semantics(
            button: true,
            label: l.chooseIcon,
            child: InkWell(customBorder: const CircleBorder(), onTap: _pick, child: Padding(padding: const EdgeInsets.all(4), child: IconAvatar(_icon, _color, size: 56))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _name,
              autofocus: widget.name.isEmpty,
              decoration: InputDecoration(labelText: widget.nameLabel ?? l.name, errorText: _error),
              onChanged: (_) => setState(() => _error = null),
            ),
          ),
        ]),
        TextButton.icon(onPressed: _pick, icon: Icon(appIcon('paint-brush')), label: Text(l.chooseIcon)),
        if (widget.extra != null) widget.extra!(context, setState),
        ...widget.footer,
      ]),
    );
  }
}

Future<void> showEntitySheet(BuildContext context, EntitySheet sheet) =>
    showModalBottomSheet<void>(context: context, isScrollControlled: true, useSafeArea: true, builder: (_) => sheet);

// ---- categories --------------------------------------------------------------------

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.manageCategories),
          bottom: TabBar(tabs: [Tab(text: l.expenseCategories), Tab(text: l.incomeCategories)]),
        ),
        floatingActionButton: Builder(
          builder: (ctx) => FloatingActionButton.extended(
            onPressed: () => _edit(ctx, ref, kind: DefaultTabController.of(ctx).index == 0 ? CategoryKind.expense : CategoryKind.income),
            icon: Icon(appIcon('plus')),
            label: Text(l.newCategory),
          ),
        ),
        body: TabBarView(children: [_List(CategoryKind.expense), _List(CategoryKind.income)]),
      ),
    );
  }
}

class _List extends ConsumerWidget {
  const _List(this.kind);
  final CategoryKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final all = (ref.watch(categoriesProvider).value ?? const <Category>[]).where((c) => c.kind == kind).toList();
    final active = all.where((c) => !c.archived);
    final archived = all.where((c) => c.archived && c.parentId == null).toList();
    final parents = active.where((c) => c.parentId == null).toList();

    Widget tile(Category c, {bool child = false}) => ListTile(
          contentPadding: EdgeInsetsDirectional.only(start: child ? 40 : 16, end: 16),
          leading: IconAvatar(c.icon, c.color, size: child ? 36 : 44),
          title: Text(displayName(c.name, c.nameKey, prefs.lang)),
          trailing: Icon(appIcon('pencil-simple'), color: context.money.muted),
          onTap: () => _edit(context, ref, kind: kind, existing: c),
        );

    return ListView(padding: const EdgeInsets.only(bottom: 96), children: [
      for (final p in parents) ...[
        tile(p),
        for (final k in active.where((c) => c.parentId == p.id)) tile(k, child: true),
      ],
      if (archived.isNotEmpty) ...[
        SectionHeader(l.archived),
        for (final c in archived)
          ListTile(
            leading: IconAvatar(c.icon, c.color),
            title: Text(displayName(c.name, c.nameKey, prefs.lang)),
            trailing: TextButton(onPressed: () => ref.read(repoProvider).archiveCategory(c.id, false), child: Text(l.unarchive)),
          ),
      ],
    ]);
  }
}

Future<void> _edit(BuildContext context, WidgetRef ref, {required CategoryKind kind, Category? existing}) {
  final l = AppLocalizations.of(context);
  final prefs = ref.read(prefsProvider);
  final repo = ref.read(repoProvider);
  final all = ref.read(categoriesProvider).value ?? const <Category>[];
  final hasChildren = existing != null && all.any((c) => c.parentId == existing.id);
  int? parent = existing?.parentId;
  final candidates = all.where((c) => c.parentId == null && !c.archived && c.kind == kind && c.id != existing?.id).toList();
  final shownName = existing == null ? '' : displayName(existing.name, existing.nameKey, prefs.lang);

  return showEntitySheet(
    context,
    EntitySheet(
      title: existing == null ? l.newCategory : l.editCategory,
      name: shownName,
      icon: existing?.icon ?? 'tag:regular',
      color: existing?.color ?? pickerPalette[0],
      onSave: (name, icon, color, changed) => repo.saveCategory(
        id: existing?.id, name: name, kind: kind, parentId: parent, icon: icon, color: color, renamed: existing == null || changed),
      extra: hasChildren
          ? null
          : (ctx, setState) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: DropdownButtonFormField<int?>(
                  initialValue: parent,
                  decoration: InputDecoration(labelText: l.parentCategory),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l.noParent)),
                    for (final c in candidates) DropdownMenuItem(value: c.id, child: Text(displayName(c.name, c.nameKey, prefs.lang))),
                  ],
                  onChanged: (v) => setState(() => parent = v),
                ),
              ),
      footer: existing == null
          ? const []
          : [
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(appIcon('git-merge')),
                    label: Text(l.mergeInto),
                    onPressed: () async {
                      final nav = Navigator.of(context);
                      final target = await _pickMergeTarget(context, ref, existing, kind);
                      if (target != null) {
                        await repo.mergeCategory(existing.id, target);
                        nav.pop();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(appIcon('archive')),
                    label: Text(l.archive),
                    onPressed: () async {
                      final nav = Navigator.of(context);
                      await repo.archiveCategory(existing.id, true);
                      nav.pop();
                    },
                  ),
                ),
              ]),
            ],
    ),
  );
}

Future<int?> _pickMergeTarget(BuildContext context, WidgetRef ref, Category from, CategoryKind kind) {
  final l = AppLocalizations.of(context);
  final prefs = ref.read(prefsProvider);
  final all = (ref.read(categoriesProvider).value ?? const <Category>[]).where((c) => !c.archived && c.kind == kind && c.id != from.id && c.parentId != from.id).toList();
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => ListView(children: [
      Padding(padding: const EdgeInsets.all(16), child: Text(l.mergeInto, style: Theme.of(ctx).textTheme.titleLarge)),
      for (final c in all)
        ListTile(
          contentPadding: EdgeInsetsDirectional.only(start: c.parentId == null ? 16 : 40, end: 16),
          leading: IconAvatar(c.icon, c.color, size: 36),
          title: Text(displayName(c.name, c.nameKey, prefs.lang)),
          onTap: () async {
            final ok = await showDialog<bool>(
              context: ctx,
              builder: (d) => AlertDialog(
                content: Text(l.mergeConfirm(displayName(c.name, c.nameKey, prefs.lang))),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(d, false), child: Text(l.cancel)),
                  FilledButton(onPressed: () => Navigator.pop(d, true), child: Text(l.merge)),
                ],
              ),
            );
            if (ok == true && ctx.mounted) Navigator.pop(ctx, c.id);
          },
        ),
    ]),
  );
}

// ---- tags -----------------------------------------------------------------------------

class TagsScreen extends ConsumerWidget {
  const TagsScreen({super.key});

  Future<void> _edit(BuildContext context, WidgetRef ref, [Tag? t]) {
    final l = AppLocalizations.of(context);
    final prefs = ref.read(prefsProvider);
    final repo = ref.read(repoProvider);
    return showEntitySheet(
      context,
      EntitySheet(
        title: t == null ? l.newTag : l.editTag,
        name: t == null ? '' : displayName(t.name, t.nameKey, prefs.lang),
        icon: t?.icon ?? 'hash:regular',
        color: t?.color ?? pickerPalette[4],
        onSave: (n, i, c, changed) => repo.saveTag(id: t?.id, name: n, icon: i, color: c, renamed: t == null || changed),
        footer: t == null
            ? const []
            : [
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: Icon(appIcon('trash'), color: Theme.of(context).colorScheme.error),
                  label: Text(l.delete, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  onPressed: () async {
                    final nav = Navigator.of(context);
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (d) => AlertDialog(
                        content: Text(l.deleteTagConfirm),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(d, false), child: Text(l.cancel)),
                          FilledButton(onPressed: () => Navigator.pop(d, true), child: Text(l.delete)),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await repo.deleteTag(t.id);
                      nav.pop();
                    }
                  },
                ),
              ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final tags = ref.watch(tagsProvider).value ?? const <Tag>[];
    return Scaffold(
      appBar: AppBar(title: Text(l.manageTags)),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _edit(context, ref), icon: Icon(appIcon('plus')), label: Text(l.newTag)),
      body: ListView(padding: const EdgeInsets.only(bottom: 96), children: [
        for (final t in tags)
          ListTile(
            leading: IconAvatar(t.icon, t.color),
            title: Text(displayName(t.name, t.nameKey, prefs.lang)),
            trailing: Icon(appIcon('pencil-simple'), color: context.money.muted),
            onTap: () => _edit(context, ref, t),
          ),
      ]),
    );
  }
}

// ---- accounts -------------------------------------------------------------------------

/// Add or edit an account. Bank accounts carry the number printed in their SMS,
/// so new messages are filed under the right account.
Future<void> editAccount(BuildContext context, WidgetRef ref, [Account? a]) {
  final l = AppLocalizations.of(context);
  final prefs = ref.read(prefsProvider);
  final repo = ref.read(repoProvider);
  final unit = prefs.toman ? 10 : 1;
  final opening = TextEditingController(text: a == null || a.openingBalance == 0 ? '' : formatMoney(a.openingBalance ~/ unit));
  final number = TextEditingController(text: a?.number ?? '');
  var kind = a?.kind ?? AccountKind.bank;
  int? bankId = a?.bankId;
  String? error;
  final isNew = a == null;
  return showEntitySheet(
    context,
    EntitySheet(
      title: isNew ? l.newAccount : l.editAccount,
      name: a?.name ?? '',
      icon: a?.icon ?? 'bank:regular',
      color: a?.color ?? pickerPalette[(ref.read(accountsProvider).value?.length ?? 0) % pickerPalette.length],
      onSave: (n, i, c, _) async {
        final num = number.text.trim();
        if (kind == AccountKind.bank && num.isNotEmpty && await repo.accountNumberTaken(num, exceptId: a?.id)) {
          error = l.accountNumberTaken;
          throw StateError('number taken'); // keeps the sheet open (see below)
        }
        await repo.saveAccount(
          id: a?.id, name: n, icon: i, color: c, kind: kind,
          bankId: kind == AccountKind.bank ? bankId : null,
          number: kind == AccountKind.bank ? num : null,
          opening: (parseMoney(opening.text) ?? 0) * unit,
        );
      },
      extra: (ctx, setState) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (isNew)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: SegmentedButton<AccountKind>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: AccountKind.bank, label: Text(l.accountKindBank), icon: Icon(appIcon('bank'))),
                ButtonSegment(value: AccountKind.cash, label: Text(l.accountKindCash), icon: Icon(appIcon('wallet'))),
              ],
              selected: {kind},
              onSelectionChanged: (s) => setState(() => kind = s.first),
            ),
          ),
        if (kind == AccountKind.bank) ...[
          FutureBuilder(
            future: ref.read(dbProvider).select(ref.read(dbProvider).banks).get(),
            builder: (c, s) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: DropdownButtonFormField<int?>(
                initialValue: bankId,
                isExpanded: true,
                decoration: InputDecoration(labelText: l.accountBank),
                items: [
                  DropdownMenuItem(value: null, child: Text(l.builderOtherBank)),
                  for (final b in s.data ?? const <Bank>[]) DropdownMenuItem(value: b.id, child: Text(prefs.persian ? b.nameFa : b.nameEn)),
                ],
                onChanged: (v) => setState(() => bankId = v),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextField(
              controller: number,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(labelText: l.accountNumber, helperText: l.accountNumberHint, helperMaxLines: 3, errorText: error),
              onChanged: (_) => setState(() => error = null),
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: TextField(
            controller: opening,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            inputFormatters: [MoneyInputFormatter()],
            decoration: InputDecoration(labelText: l.openingBalance, suffixText: prefs.toman ? l.toman : l.rial),
          ),
        ),
      ]),
      footer: isNew
          ? const []
          : [
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: Icon(appIcon('archive')),
                label: Text(l.archiveAccount),
                onPressed: () async {
                  final nav = Navigator.of(context);
                  await repo.archiveAccount(a.id, true);
                  nav.pop();
                },
              ),
            ],
    ),
  );
}

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final list = ref.watch(accountBalancesProvider).value ?? const <AccountBalance>[];
    final banks = ref.watch(banksProvider).value ?? const <Bank>[];
    final active = list.where((e) => !e.account.archived).toList();
    final archived = list.where((e) => e.account.archived).toList();

    Widget tile(AccountBalance e) {
      final a = e.account;
      final bank = banks.where((b) => b.id == a.bankId).firstOrNull;
      final sub = [if (bank != null) (prefs.persian ? bank.nameFa : bank.nameEn), if (a.number != null) a.number!].join(' · ');
      return ListTile(
        minVerticalPadding: 10,
        leading: IconAvatar(a.icon, a.color),
        title: Text(a.name),
        subtitle: sub.isEmpty ? null : Text(sub, textDirection: TextDirection.ltr, textAlign: TextAlign.start),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          InkWell(onTap: () => showBalanceSheet(context, ref, e), child: Padding(padding: const EdgeInsets.all(8), child: Text(prefs.money(e.balance), textDirection: TextDirection.ltr, style: Theme.of(context).textTheme.titleSmall))),
          IconButton(tooltip: l.edit, icon: Icon(appIcon('pencil-simple'), color: context.money.muted), onPressed: () => editAccount(context, ref, a)),
        ]),
        onTap: () => push(context, TransactionsScreen(initial: TxFilter(accountId: a.id), title: a.name)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.manageAccounts)),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => editAccount(context, ref), icon: Icon(appIcon('plus')), label: Text(l.newAccount)),
      body: ListView(padding: const EdgeInsets.only(bottom: 96), children: [
        for (final e in active) tile(e),
        if (archived.isNotEmpty) ...[
          Padding(padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 4), child: Text(l.archivedAccounts, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: context.money.muted))),
          for (final e in archived)
            ListTile(
              leading: IconAvatar(e.account.icon, e.account.color),
              title: Text(e.account.name),
              trailing: TextButton(onPressed: () => ref.read(repoProvider).archiveAccount(e.account.id, false), child: Text(l.unarchive)),
            ),
        ],
      ]),
    );
  }
}
