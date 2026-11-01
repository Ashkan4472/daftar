import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../l10n/app_localizations.dart';
import '../services/csv_io.dart';
import '../state.dart';
import '../repo.dart';
import '../ui/widgets.dart';

/// Match CSV columns to fields, preview, import. Daftar exports are mapped automatically.
class CsvMapScreen extends ConsumerStatefulWidget {
  const CsvMapScreen(this.rows, {super.key});
  final List<List<String>> rows; // first row is the header

  @override
  ConsumerState<CsvMapScreen> createState() => _CsvMapScreenState();
}

class _CsvMapScreenState extends ConsumerState<CsvMapScreen> {
  late final CsvMapping _m = CsvMapping.fromHeader(widget.rows.first) ?? _guess();
  bool _busy = false;

  CsvMapping _guess() {
    int? find(List<String> names) {
      for (var i = 0; i < widget.rows.first.length; i++) {
        final h = widget.rows.first[i].toLowerCase();
        if (names.any(h.contains)) return i;
      }
      return null;
    }

    return CsvMapping(
      date: find(['date', 'تاریخ']), time: find(['time', 'ساعت']), amount: find(['amount', 'مبلغ']),
      note: find(['note', 'desc', 'شرح', 'توضیح']), category: find(['category', 'دسته']),
      account: find(['account', 'حساب']), tags: find(['tag', 'برچسب']),
    );
  }

  Widget _dropdown(String label, int? value, void Function(int?) set) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<int?>(
        initialValue: value != null && value >= 0 ? value : null,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: [
          DropdownMenuItem(value: null, child: Text(l.csvNone)),
          for (var i = 0; i < widget.rows.first.length; i++) DropdownMenuItem(value: i, child: Text(widget.rows.first[i].isEmpty ? '#${i + 1}' : widget.rows.first[i])),
        ],
        onChanged: (v) => setState(() => set(v)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final body = widget.rows.skip(1).toList();
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final ready = _m.date != null && _m.amount != null;
    return Scaffold(
      appBar: AppBar(title: Text(l.csvMapTitle)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _dropdown(l.csvColDate, _m.date, (v) => _m.date = v),
        _dropdown(l.csvColTime, _m.time, (v) => _m.time = v),
        _dropdown(l.csvColAmount, _m.amount, (v) => _m.amount = v),
        _dropdown(l.csvColNote, _m.note, (v) => _m.note = v),
        _dropdown(l.csvColCategory, _m.category, (v) => _m.category = v),
        _dropdown(l.csvColAccount, _m.account, (v) => _m.account = v),
        _dropdown(l.csvColTags, _m.tags, (v) => _m.tags = v),
        DropdownButtonFormField<int?>(
          initialValue: _m.defaultAccountId,
          decoration: InputDecoration(labelText: l.csvAccountDefault),
          items: [for (final a in accounts) DropdownMenuItem(value: a.id, child: Text(a.name))],
          onChanged: (v) => setState(() => _m.defaultAccountId = v),
        ),
        SwitchListTile(contentPadding: EdgeInsets.zero, title: Text('${l.csvAmountUnit} ${l.toman}'), value: _m.amountInToman, onChanged: (v) => setState(() => _m.amountInToman = v)),
        SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.csvInvertSign), value: _m.invertSign, onChanged: (v) => setState(() => _m.invertSign = v)),
        SectionHeader(l.csvPreview),
        Card(
          child: Column(children: [
            for (final r in body.take(3))
              ListTile(
                dense: true,
                title: Text(r.take(6).join('  ·  '), maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
          ]),
        ),
        if (!ready) Padding(padding: const EdgeInsets.only(top: 8), child: Text(l.csvNeedDate, style: context.mutedStyle)),
      ]),
      bottomNavigationBar: BottomBar(
        child: FilledButton(
          onPressed: !ready || _busy
              ? null
              : () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final nav = Navigator.of(context);
                  setState(() => _busy = true);
                  final res = await importCsvRows(ref.read(dbProvider), body, _m);
                  messenger.showSnackBar(SnackBar(content: Text(prefs.digits(l.csvImported(res.added, res.skipped)))));
                  nav.pop();
                },
          child: Text(prefs.digits(l.csvImportRows(body.length))),
        ),
      ),
    );
  }
}
