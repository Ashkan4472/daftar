import 'package:core/core.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../db/database.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../state.dart';
import '../theme/palette.dart';
import '../theme/theme.dart';
import '../ui/format.dart';
import '../ui/widgets.dart';
import 'manage.dart';
import 'people_data.dart';
import 'transactions.dart';
import 'tx_sheet.dart';
import '../repo.dart';

Future<void> editPerson(BuildContext context, WidgetRef ref, [Person? p]) {
  final l = AppLocalizations.of(context);
  final db = ref.read(dbProvider);
  final phone = TextEditingController(text: p?.phone ?? '');
  return showEntitySheet(
    context,
    EntitySheet(
      title: p == null ? l.newPerson : l.editPerson,
      name: p?.name ?? '',
      icon: p?.icon ?? 'user:regular',
      color: p?.color ?? pickerPalette[(DateTime.now().millisecond) % pickerPalette.length],
      extra: (ctx, _) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: TextField(controller: phone, keyboardType: TextInputType.phone, textDirection: TextDirection.ltr, decoration: InputDecoration(labelText: l.phone)),
      ),
      onSave: (n, i, c, _) async {
        final ph = phone.text.trim().isEmpty ? null : phone.text.trim();
        if (p == null) {
          await db.into(db.people).insert(PeopleCompanion.insert(name: n, icon: i, color: c, phone: Value(ph)));
        } else {
          await (db.update(db.people)..where((x) => x.id.equals(p.id))).write(PeopleCompanion(name: Value(n), icon: Value(i), color: Value(c), phone: Value(ph)));
        }
      },
    ),
  );
}

class PeopleScreen extends ConsumerWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final list = ref.watch(peopleBalancesProvider).value ?? const <PersonBalance>[];
    final owed = list.where((p) => p.balance > 0).fold(0, (a, p) => a + p.balance);
    final owe = list.where((p) => p.balance < 0).fold(0, (a, p) => a - p.balance);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l.tabPeople)),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => editPerson(context, ref), icon: Icon(appIcon('user-plus')), label: Text(l.newPerson)),
      body: list.isEmpty
          ? EmptyState(icon: 'users-three:duotone', title: l.noPeople, hint: l.noPeopleHint)
          : ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 96), children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Expanded(child: _Total(l.owedToYou, owed, context.money.income, 'arrow-down-left')),
                    Expanded(child: _Total(l.owedByYou, owe, context.money.expense, 'arrow-up-right')),
                  ]),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(children: [
                  for (final pb in list)
                    ListTile(
                      minVerticalPadding: 10,
                      leading: IconAvatar(pb.person.icon, pb.person.color),
                      title: Text(pb.person.name),
                      subtitle: Text(pb.balance == 0 ? l.allSettled : pb.balance > 0 ? l.owesYou : l.youOwe, style: context.mutedStyle),
                      trailing: pb.balance == 0
                          ? Icon(appIcon('check-circle'), color: context.money.muted)
                          : Text(prefs.money(pb.balance.abs()), textDirection: TextDirection.ltr,
                              style: t.titleSmall?.copyWith(color: pb.balance > 0 ? context.money.income : context.money.expense, fontFeatures: tabular)),
                      onTap: () => push(context, PersonScreen(pb.person.id)),
                    ),
                ]),
              ),
            ]),
    );
  }
}

class _Total extends ConsumerWidget {
  const _Total(this.label, this.value, this.color, this.icon);
  final String label, icon;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(prefsProvider);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(appIcon(icon), size: 16, color: color), const SizedBox(width: 4), Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: context.money.muted))]),
      FittedBox(fit: BoxFit.scaleDown, child: Text(prefs.money(value), textDirection: TextDirection.ltr, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w700, fontFeatures: tabular))),
    ]);
  }
}

class PersonScreen extends ConsumerWidget {
  const PersonScreen(this.id, {super.key});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final pb = (ref.watch(peopleBalancesProvider).value ?? const <PersonBalance>[]).where((p) => p.person.id == id).firstOrNull;
    final ledger = ref.watch(ledgerProvider(id)).value ?? const <LedgerEntry>[];
    final db = ref.read(dbProvider);
    if (pb == null) return const Scaffold();
    final bal = pb.balance;
    final color = bal == 0 ? context.money.muted : bal > 0 ? context.money.income : context.money.expense;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(pb.person.name), actions: [
        IconButton(tooltip: l.edit, icon: Icon(appIcon('pencil-simple')), onPressed: () => editPerson(context, ref, pb.person)),
        IconButton(
          tooltip: l.deletePerson,
          icon: Icon(appIcon('trash')),
          onPressed: () async {
            if (ledger.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.personHasHistory)));
              return;
            }
            final nav = Navigator.of(context);
            await (db.delete(db.people)..where((p) => p.id.equals(id))).go();
            nav.pop();
          },
        ),
      ]),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 32), children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              IconAvatar(pb.person.icon, pb.person.color, size: 64),
              const SizedBox(height: 12),
              Text(bal == 0 ? l.allSettled : bal > 0 ? l.owesYou : l.youOwe, style: t.labelLarge?.copyWith(color: color)),
              if (bal != 0)
                Text(prefs.money(bal.abs()), textDirection: TextDirection.ltr, style: t.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.w800, fontFeatures: tabular)),
              if (bal != 0) Text(prefs.toman ? l.toman : l.rial, style: context.mutedStyle),
              const SizedBox(height: 16),
              Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
                if (bal != 0) FilledButton.icon(onPressed: () => _settle(context, ref, pb), icon: Icon(appIcon('handshake')), label: Text(l.settleUp)),
                OutlinedButton.icon(onPressed: () => _manual(context, ref, id, 1), icon: Icon(appIcon('arrow-down-left')), label: Text(l.theyOweMe)),
                OutlinedButton.icon(onPressed: () => _manual(context, ref, id, -1), icon: Icon(appIcon('arrow-up-right')), label: Text(l.iOweThem)),
              ]),
            ]),
          ),
        ),
        SectionHeader(l.ledger),
        if (ledger.isEmpty)
          Card(child: Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(l.noLedger, style: context.mutedStyle))))
        else
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(children: [
              for (final e in ledger)
                ListTile(
                  leading: Icon(appIcon(e.isSplit ? 'users-three' : 'handshake'), color: context.money.muted),
                  title: Text(e.note.isNotEmpty ? e.note : (e.txNote?.isNotEmpty ?? false) ? e.txNote! : e.isSplit ? l.sharedExpense : l.settlementEntry),
                  subtitle: Text(fmtDate(prefs, e.at)),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(prefs.money(e.amount, signed: true), textDirection: TextDirection.ltr,
                        style: t.titleSmall?.copyWith(color: e.amount > 0 ? context.money.income : context.money.expense, fontFeatures: tabular)),
                    PopupMenuButton<String>(
                      tooltip: l.edit,
                      onSelected: (_) => e.isSplit
                          ? (db.delete(db.splits)..where((s) => s.id.equals(e.id))).go()
                          : (db.delete(db.settlements)..where((s) => s.id.equals(e.id))).go(),
                      itemBuilder: (_) => [PopupMenuItem(value: 'del', child: Text(l.deleteEntry))],
                    ),
                  ]),
                  onTap: e.txId == null ? null : () => showTxSheet(context, e.txId!),
                ),
            ]),
          ),
        SectionHeader(l.tabTransactions),
        OutlinedButton.icon(
          onPressed: () => push(context, TransactionsScreen(initial: TxFilter(personId: id), title: pb.person.name)),
          icon: Icon(appIcon('receipt')),
          label: Text(l.viewTransactions),
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        ),
      ]),
    );
  }
}

/// Adds a debt by hand: [dir] 1 = they owe me, -1 = I owe them.
Future<void> _manual(BuildContext context, WidgetRef ref, int personId, int dir) {
  final l = AppLocalizations.of(context);
  final prefs = ref.read(prefsProvider);
  final db = ref.read(dbProvider);
  final amount = TextEditingController();
  final note = TextEditingController();
  DateTime at = DateTime.now();
  String? error;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => SheetFrame(
        action: FilledButton(
          onPressed: () async {
            final v = parseMoney(amount.text);
            if (v == null || v == 0) {
              setState(() => error = l.amountRequired);
              return;
            }
            final nav = Navigator.of(ctx);
            await db.into(db.splits).insert(SplitsCompanion.insert(personId: personId, share: dir * v * (prefs.toman ? 10 : 1), occurredAt: at, note: Value(note.text.trim())));
            nav.pop();
          },
          child: Text(l.save),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          Text(dir > 0 ? l.theyOweMe : l.iOweThem, style: Theme.of(ctx).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: amount,
            autofocus: true,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            inputFormatters: [MoneyInputFormatter()],
            decoration: InputDecoration(labelText: l.amount, suffixText: prefs.toman ? l.toman : l.rial, errorText: error),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: Icon(appIcon('calendar-blank')),
            label: Text(fmtDate(prefs, at)),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: () async {
              final j = await showPersianDatePicker(context: ctx, initialDate: Jalali.fromDateTime(at), firstDate: Jalali(1390), lastDate: Jalali.now().addDays(1));
              if (j != null) setState(() => at = j.toDateTime());
            },
          ),
          const SizedBox(height: 12),
          TextField(controller: note, decoration: InputDecoration(hintText: l.addNote)),
        ]),
      ),
    ),
  );
}

Future<void> _settle(BuildContext context, WidgetRef ref, PersonBalance pb) {
  final l = AppLocalizations.of(context);
  final prefs = ref.read(prefsProvider);
  final db = ref.read(dbProvider);
  final unit = prefs.toman ? 10 : 1;
  final theyPay = pb.balance > 0;
  final amount = TextEditingController(text: formatMoney(pb.balance.abs() ~/ unit));
  final note = TextEditingController();
  DateTime at = DateTime.now();
  int? link;
  String? error;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => SheetFrame(
        action: FilledButton(
          onPressed: () async {
            final v = parseMoney(amount.text);
            if (v == null || v == 0) {
              setState(() => error = l.amountRequired);
              return;
            }
            final nav = Navigator.of(ctx);
            await db.into(db.settlements).insert(SettlementsCompanion.insert(
                  personId: pb.person.id,
                  amount: (theyPay ? 1 : -1) * v * unit,
                  occurredAt: at,
                  note: Value(note.text.trim()),
                  transactionId: Value(link),
                ));
            if (link != null) await ref.read(repoProvider).setExcluded(link!, true);
            nav.pop();
          },
          child: Text(l.save),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          Text('${l.settleUp} · ${pb.person.name}', style: Theme.of(ctx).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: amount,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            inputFormatters: [MoneyInputFormatter()],
            decoration: InputDecoration(labelText: l.amount, suffixText: prefs.toman ? l.toman : l.rial, errorText: error),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: Icon(appIcon('calendar-blank')),
            label: Text(fmtDate(prefs, at)),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: () async {
              final j = await showPersianDatePicker(context: ctx, initialDate: Jalali.fromDateTime(at), firstDate: Jalali(1390), lastDate: Jalali.now().addDays(1));
              if (j != null) setState(() => at = j.toDateTime());
            },
          ),
          if (theyPay) ...[
            const SizedBox(height: 12),
            FutureBuilder(
              future: (db.select(db.transactions)
                    ..where((t) => t.kind.equals(TxKind.income.name) & t.deletedAt.isNull() & t.excluded.equals(false))
                    ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])
                    ..limit(20))
                  .get(),
              builder: (ctx, snap) {
                final txs = snap.data ?? const <Transaction>[];
                if (txs.isEmpty) return const SizedBox.shrink();
                return DropdownButtonFormField<int?>(
                  initialValue: link,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l.linkDeposit, helperText: l.linkedHint),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l.noLink)),
                    for (final t in txs) DropdownMenuItem(value: t.id, child: Text('${prefs.money(t.amount, signed: true)} · ${fmtDayMonth(prefs, t.occurredAt)}', textDirection: TextDirection.ltr)),
                  ],
                  onChanged: (v) => setState(() => link = v),
                );
              },
            ),
          ],
          const SizedBox(height: 12),
          TextField(controller: note, decoration: InputDecoration(hintText: l.addNote)),
        ]),
      ),
    ),
  );
}
