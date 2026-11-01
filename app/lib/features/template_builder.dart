import 'package:core/core.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../l10n/app_localizations.dart';
import '../sms/importer.dart';
import '../state.dart';
import '../ui/widgets.dart';

class TemplateBuilderScreen extends ConsumerStatefulWidget {
  const TemplateBuilderScreen(this.sms, {super.key});
  final RawSmsRow sms;

  @override
  ConsumerState<TemplateBuilderScreen> createState() => _TemplateBuilderScreenState();
}

class _TemplateBuilderScreenState extends ConsumerState<TemplateBuilderScreen> {
  late final String _text = normalizeSms(widget.sms.body);
  late final List<SmsToken> _toks = tokenizeSms(_text);
  final Map<int, TokenRole> _roles = {};
  final _pattern = TextEditingController();
  bool _manual = false;
  String? _error;
  int? _bankId;
  bool _saving = false;

  @override
  void dispose() {
    _pattern.dispose();
    super.dispose();
  }

  void _rebuild() {
    final r = buildTemplatePattern(_toks, _roles);
    _error = r.error;
    if (!_manual && r.pattern != null) _pattern.text = r.pattern!;
    if (r.pattern == null) _pattern.text = '';
  }

  SmsTemplate? get _template {
    final p = _pattern.text;
    if (p.isEmpty) return null;
    try {
      return SmsTemplate(id: 'user.preview', pattern: p, verified: true);
    } catch (_) {
      return null;
    }
  }

  ParsedSms? get _parsed => _template?.parse(_text, widget.sms.receivedAt);

  Future<void> _pick(int i) async {
    final l = AppLocalizations.of(context);
    final role = await showModalBottomSheet<Object>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(padding: const EdgeInsets.all(16), child: Text(_toks[i].text, style: Theme.of(ctx).textTheme.titleMedium)),
          for (final (r, label) in [(TokenRole.amount, l.roleAmount), (TokenRole.balance, l.roleBalance), (TokenRole.date, l.roleDate), (TokenRole.account, l.roleAccount), (TokenRole.word, l.roleWord)])
            ListTile(title: Text(label), onTap: () => Navigator.pop(ctx, r)),
          ListTile(title: Text(l.roleClear), onTap: () => Navigator.pop(ctx, 'clear')),
        ]),
      ),
    );
    if (role == null) return;
    setState(() {
      if (role == 'clear') {
        _roles.remove(i);
      } else {
        // one token per role, except words which may repeat
        final r = role as TokenRole;
        if (r != TokenRole.word && r != TokenRole.date) _roles.removeWhere((_, v) => v == r);
        _roles[i] = r;
      }
      _manual = false;
      _rebuild();
    });
  }

  Color _roleColor(TokenRole r) => switch (r) {
        TokenRole.amount => Colors.green,
        TokenRole.balance => Colors.blue,
        TokenRole.date => Colors.orange,
        TokenRole.account => Colors.purple,
        TokenRole.word => Colors.pink,
      };

  Future<int> _othersMatching(AppDb db, SmsTemplate t) async {
    final rows = await (db.select(db.rawSms)..where((r) => r.address.equals(widget.sms.address) & r.status.equals(SmsStatus.unmatched.name) & r.id.equals(widget.sms.id).not())).get();
    return rows.where((r) => t.parse(normalizeSms(r.body), r.receivedAt) != null).length;
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final db = ref.read(dbProvider);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    setState(() => _saving = true);
    final addr = widget.sms.address;
    await db.into(db.smsTemplates).insert(SmsTemplatesCompanion.insert(
          code: 'user.${DateTime.now().millisecondsSinceEpoch}', pattern: _pattern.text, sender: Value('^${RegExp.escape(addr)}\$'),
          bankId: Value(_bankId), sample: Value(widget.sms.body), verified: const Value(true), priority: const Value(10)));
    // Re-run this sender's unmatched messages through the new template.
    final rows = await (db.select(db.rawSms)..where((r) => r.address.equals(addr) & r.status.equals(SmsStatus.unmatched.name))).get();
    await (db.delete(db.rawSms)..where((r) => r.id.isIn(rows.map((r) => r.id)))).go();
    final importer = SmsImporter(db);
    final res = ImportResult();
    final touched = await importer.importMessages([for (final r in rows) SmsMessage(r.address, r.body, r.receivedAt)], res);
    for (final a in touched) {
      await importer.recomputeBalanceGaps(a);
    }
    messenger.showSnackBar(SnackBar(content: Text(ref.read(prefsProvider).digits(l.builderSaved(res.added)))));
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final db = ref.read(dbProvider);
    final t = Theme.of(context).textTheme;
    final parsed = _parsed;
    final hasPattern = _pattern.text.isNotEmpty;
    final lines = <int, List<int>>{};
    for (final (i, tok) in _toks.indexed) {
      lines.putIfAbsent(tok.line, () => []).add(i);
    }
    final needsDirection = hasPattern && !patternHasDirection(_pattern.text);

    return Scaffold(
      appBar: AppBar(title: Text(l.builderTitle)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(l.builderHint, style: context.mutedStyle),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (final line in lines.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Wrap(spacing: 6, runSpacing: 6, textDirection: TextDirection.rtl, children: [
                    for (final i in line)
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => _pick(i),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 40),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _roles[i] == null ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) : _roleColor(_roles[i]!).withValues(alpha: 0.18),
                            border: Border.all(color: _roles[i] == null ? Colors.transparent : _roleColor(_roles[i]!), width: 1.5),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(_toks[i].text, textDirection: TextDirection.ltr),
                            if (_roles[i] != null) ...[
                              const SizedBox(width: 6),
                              Text(switch (_roles[i]!) {
                                TokenRole.amount => l.roleAmount,
                                TokenRole.balance => l.roleBalance,
                                TokenRole.date => l.roleDate,
                                TokenRole.account => l.roleAccount,
                                TokenRole.word => l.roleWord,
                              }, style: t.labelSmall?.copyWith(color: _roleColor(_roles[i]!))),
                            ],
                          ]),
                        ),
                      ),
                  ]),
                ),
            ]),
          ),
        ),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text('“$_error”', style: TextStyle(color: Theme.of(context).colorScheme.error))),
        if (needsDirection) Padding(padding: const EdgeInsets.only(top: 8), child: Text(l.builderNeedAmount, style: TextStyle(color: Theme.of(context).colorScheme.error))),
        if (hasPattern && !needsDirection) ...[
          SectionHeader(l.builderPreview),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: parsed == null
                  ? Text(l.builderNoMatch, style: TextStyle(color: Theme.of(context).colorScheme.error))
                  : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Amount(parsed.amount, style: t.headlineSmall),
                      if (parsed.balance != null) Text('${l.balance}: ${prefs.money(parsed.balance!)}', style: context.mutedStyle),
                      Text('${parsed.occurredAt.year}-${parsed.occurredAt.month.toString().padLeft(2, '0')}-${parsed.occurredAt.day.toString().padLeft(2, '0')} ${parsed.occurredAt.hour.toString().padLeft(2, '0')}:${parsed.occurredAt.minute.toString().padLeft(2, '0')}', style: context.mutedStyle),
                      if (parsed.account != null) Text(parsed.account!, textDirection: TextDirection.ltr, style: context.mutedStyle),
                      FutureBuilder<int>(
                        future: _othersMatching(db, _template!),
                        builder: (c, s) => (s.data ?? 0) == 0 ? const SizedBox.shrink() : Padding(padding: const EdgeInsets.only(top: 8), child: Text(prefs.digits(l.builderMatches(s.data!)))),
                      ),
                    ]),
            ),
          ),
        ],
        const SizedBox(height: 8),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          shape: const Border(),
          collapsedShape: const Border(),
          title: Text(l.builderAdvanced),
          children: [
            TextField(
              controller: _pattern,
              minLines: 3,
              maxLines: 8,
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              onChanged: (_) => setState(() => _manual = true),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FutureBuilder(
          future: db.select(db.banks).get(),
          builder: (c, s) => DropdownButtonFormField<int?>(
            initialValue: _bankId,
            decoration: InputDecoration(labelText: l.builderBank),
            items: [
              DropdownMenuItem(value: null, child: Text(l.builderOtherBank)),
              for (final b in s.data ?? const <Bank>[]) DropdownMenuItem(value: b.id, child: Text(prefs.persian ? b.nameFa : b.nameEn)),
            ],
            onChanged: (v) => setState(() => _bankId = v),
          ),
        ),
      ]),
      bottomNavigationBar: BottomBar(
        child: FilledButton(onPressed: parsed == null || needsDirection || _saving ? null : _save, child: Text(l.builderSave)),
      ),
    );
  }
}
