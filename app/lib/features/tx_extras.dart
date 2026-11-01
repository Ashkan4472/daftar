import 'package:core/core.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../state.dart';
import '../db/database.dart';
import '../repo.dart';
import '../ui/format.dart';
import '../ui/widgets.dart';
import 'people.dart';
import 'people_data.dart';
import 'reminders.dart';

/// SplitRow-with-people and reminder actions on a transaction's detail sheet.
class TxExtras extends ConsumerWidget {
  const TxExtras({super.key, required this.txId, required this.amount});
  final int txId, amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final splits =
        ref.watch(txSplitsProvider(txId)).value ?? const <(SplitRow, Person)>[];
    final db = ref.read(dbProvider);
    final total = splits.fold<int>(0, (a, s) => a + s.$1.share);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (amount < 0) ...[
          if (splits.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (s, p) in splits)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: IconAvatar(p.icon, p.color, size: 32),
                        title: Text(l.owesAmount(p.name, prefs.money(s.share))),
                      ),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l.myShare,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        Text(
                          prefs.money(amount.abs() - total),
                          textDirection: TextDirection.ltr,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (_) => SplitSheet(txId: txId, total: amount.abs()),
            ),
            icon: Icon(appIcon('users-three')),
            label: Text(splits.isEmpty ? l.splitWith : l.editSplit),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
          if (splits.isNotEmpty)
            TextButton(
              onPressed: () => (db.delete(
                db.splits,
              )..where((s) => s.transactionId.equals(txId))).go(),
              child: Text(l.removeSplit),
            ),
        ],
        const SizedBox(height: 8),
        ReminderButton(targetType: ReminderTarget.transaction, targetId: txId),
      ],
    );
  }
}

class SplitSheet extends ConsumerStatefulWidget {
  const SplitSheet({super.key, required this.txId, required this.total});
  final int txId, total; // total: positive Rial

  @override
  ConsumerState<SplitSheet> createState() => _SplitSheetState();
}

class _SplitSheetState extends ConsumerState<SplitSheet> {
  SplitMode _mode = SplitMode.equal;
  final Map<int, TextEditingController> _people =
      {}; // selected person -> input
  String? _error;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    final db = ref.read(dbProvider);
    (db.select(
      db.splits,
    )..where((s) => s.transactionId.equals(widget.txId))).get().then((rows) {
      if (!mounted) return;
      final unit = ref.read(prefsProvider).toman ? 10 : 1;
      setState(() {
        if (rows.isNotEmpty) _mode = SplitMode.exact;
        for (final r in rows) {
          _people[r.personId] = TextEditingController(
            text: formatMoney(r.share ~/ unit),
          );
        }
        _loaded = true;
      });
    });
  }

  @override
  void dispose() {
    for (final c in _people.values) {
      c.dispose();
    }
    super.dispose();
  }

  List<int>? _shares() {
    final unit = ref.read(prefsProvider).toman ? 10 : 1;
    final inputs = [
      for (final c in _people.values)
        (parseMoney(c.text) ?? 0) * (_mode == SplitMode.exact ? unit : 1),
    ];
    return splitShares(widget.total, _mode, inputs);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final people = ref.watch(peopleProvider).value ?? const <Person>[];
    final shares = _people.isEmpty ? null : _shares();
    final mine = shares == null
        ? null
        : widget.total - shares.fold<int>(0, (a, b) => a + b);
    final ids = _people.keys.toList();
    if (!_loaded)
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );

    return SheetFrame(
      action: FilledButton(
        onPressed: () async {
          if (_people.isEmpty) {
            setState(() => _error = l.pickPeople);
            return;
          }
          final s = _shares();
          if (s == null) return;
          final db = ref.read(dbProvider);
          final tx = await ref.read(repoProvider).get(widget.txId);
          final nav = Navigator.of(context);
          await db.transaction(() async {
            await (db.delete(
              db.splits,
            )..where((x) => x.transactionId.equals(widget.txId))).go();
            for (final (i, id) in ids.indexed) {
              if (s[i] > 0) {
                await db
                    .into(db.splits)
                    .insert(
                      SplitsCompanion.insert(
                        transactionId: Value(widget.txId),
                        personId: id,
                        share: s[i],
                        occurredAt: tx?.tx.occurredAt ?? DateTime.now(),
                      ),
                    );
              }
            }
          });
          nav.pop();
        },
        child: Text(l.save),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.splitWith, style: Theme.of(context).textTheme.titleLarge),
          Text(
            prefs.money(widget.total),
            textDirection: TextDirection.ltr,
            style: context.mutedStyle,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in people)
                FilterChip(
                  avatar: Icon(
                    appIcon(p.icon),
                    size: 18,
                    color: Color(p.color),
                  ),
                  label: Text(p.name),
                  selected: _people.containsKey(p.id),
                  showCheckmark: false,
                  onSelected: (on) => setState(() {
                    if (on) {
                      _people[p.id] = TextEditingController();
                    } else {
                      _people.remove(p.id)?.dispose();
                    }
                  }),
                ),
              ActionChip(
                avatar: Icon(appIcon('user-plus'), size: 18),
                label: Text(l.newPerson),
                onPressed: () => editPerson(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SegmentedButton<SplitMode>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: SplitMode.equal, label: Text(l.splitEqual)),
              ButtonSegment(
                value: SplitMode.percent,
                label: Text(l.splitPercent),
              ),
              ButtonSegment(value: SplitMode.exact, label: Text(l.splitExact)),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() => _mode = s.first),
          ),
          if (_mode != SplitMode.equal)
            for (final id in ids)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextField(
                  controller: _people[id],
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  inputFormatters: _mode == SplitMode.exact
                      ? [MoneyInputFormatter()]
                      : null,
                  decoration: InputDecoration(
                    labelText: people.firstWhere((p) => p.id == id).name,
                    suffixText: _mode == SplitMode.percent ? '%' : null,
                  ),
                  onChanged: (_) => setState(() => _error = null),
                ),
              ),
          const SizedBox(height: 16),
          if (mine != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.myShare,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  prefs.money(mine),
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            )
          else if (_people.isNotEmpty)
            Text(
              l.splitInvalid,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
    );
  }
}
