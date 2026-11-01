import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../services/backup.dart';
import '../services/csv_io.dart';
import '../state.dart';
import '../ui/format.dart';
import '../ui/widgets.dart';
import 'csv_map.dart';

String _stamp() {
  final n = DateTime.now();
  String t(int v) => v.toString().padLeft(2, '0');
  return '${n.year}${t(n.month)}${t(n.day)}-${t(n.hour)}${t(n.minute)}';
}

/// Lets the user save the bytes to a file or share them.
Future<void> deliver(BuildContext context, Uint8List bytes, String name, String mime) async {
  final l = AppLocalizations.of(context);
  final choice = await showModalBottomSheet<String>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(leading: Icon(appIcon('floppy-disk')), title: Text(l.backupSave), onTap: () => Navigator.pop(ctx, 'save')),
        ListTile(leading: Icon(appIcon('share-network')), title: Text(l.backupShare), onTap: () => Navigator.pop(ctx, 'share')),
      ]),
    ),
  );
  if (choice == null) return;
  if (choice == 'save') {
    final uri = await FilePicker.saveFile(fileName: name, bytes: bytes, mimeType: mime);
    if (uri != null && context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.backupSaved)));
  } else {
    final f = File(p.join((await getTemporaryDirectory()).path, name));
    await f.writeAsBytes(bytes);
    await SharePlus.instance.share(ShareParams(files: [XFile(f.path, mimeType: mime)]));
  }
}

Future<String?> _askPassword(BuildContext context, {required bool confirm}) {
  final l = AppLocalizations.of(context);
  final a = TextEditingController(), b = TextEditingController();
  String? error;
  return showDialog<String>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(l.backupPassword),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (confirm) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(l.backupPasswordHint)),
            TextField(controller: a, obscureText: true, autofocus: true, decoration: InputDecoration(labelText: l.backupPassword)),
            if (confirm) ...[
              const SizedBox(height: 12),
              TextField(controller: b, obscureText: true, decoration: InputDecoration(labelText: l.backupPasswordAgain, errorText: error)),
            ],
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(
            onPressed: () {
              if (confirm && a.text.length < 6) return setState(() => error = l.passwordShort);
              if (confirm && a.text != b.text) return setState(() => error = l.passwordMismatch);
              if (a.text.isEmpty) return;
              Navigator.pop(ctx, a.text);
            },
            child: Text(l.save),
          ),
        ],
      ),
    ),
  );
}

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;
  String _range = 'all'; // all | month | custom
  Jalali _from = Jalali.now().withDay(1), _to = Jalali.now();

  Future<void> _run(Future<void> Function() job) async {
    setState(() => _busy = true);
    try {
      await job();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _backup() async {
    final pw = await _askPassword(context, confirm: true);
    if (pw == null || !mounted) return;
    await _run(() async {
      final bytes = await createBackup(ref.read(dbProvider), pw);
      if (mounted) await deliver(context, bytes, 'daftar-${_stamp()}.daftar', 'application/octet-stream');
    });
  }

  Future<void> _restore() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final f = await FilePicker.pickFile();
    if (f == null || f.path == null || !mounted) return;
    final pw = await _askPassword(context, confirm: false);
    if (pw == null || !mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(appIcon('warning'), color: Theme.of(context).colorScheme.error),
        content: Text(l.restoreConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.backupRestore)),
        ],
      ),
    );
    if (ok != true) return;
    await _run(() async {
      try {
        await restoreBackup(ref, await File(f.path!).readAsBytes(), pw);
        messenger.showSnackBar(SnackBar(content: Text(l.restoreDone)));
      } on BackupError catch (e) {
        messenger.showSnackBar(SnackBar(content: Text(e.message.startsWith('Not a') ? l.restoreWrongFile : l.restoreFailed(e.message))));
      }
    });
  }

  Future<void> _export() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ym = jalaliYm(DateTime.now());
    final f = switch (_range) {
      'month' => TxFilter(ym: ym),
      'custom' => TxFilter(from: _from.toDateTime(), to: _to.addDays(1).toDateTime()),
      _ => const TxFilter(),
    };
    await _run(() async {
      final (csv, n) = await exportTransactions(ref.read(dbProvider), f);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(ref.read(prefsProvider).digits(l.exportDone(n)))));
      await deliver(context, Uint8List.fromList(utf8.encode(csv)), 'daftar-${_stamp()}.csv', 'text/csv');
    });
  }

  Future<void> _import() async {
    final f = await FilePicker.pickFile();
    if (f == null || f.path == null || !mounted) return;
    final text = utf8.decode(await File(f.path!).readAsBytes(), allowMalformed: true);
    final rows = parseCsv(text);
    if (rows.length < 2 || !mounted) return;
    push(context, CsvMapScreen(rows));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final last = int.tryParse(ref.watch(settingsMapProvider).value?['last_backup'] ?? '');
    return Scaffold(
      appBar: AppBar(title: Text(l.backupTitle)),
      body: Stack(children: [
        ListView(padding: const EdgeInsets.all(16), children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [Icon(appIcon('lock-key')), const SizedBox(width: 12), Expanded(child: Text(l.backupCreate, style: Theme.of(context).textTheme.titleMedium))]),
                const SizedBox(height: 8),
                Text(l.backupCreateHint, style: context.mutedStyle),
                const SizedBox(height: 4),
                Text(last == null ? l.backupNever : l.backupLast(fmtDate(prefs, DateTime.fromMillisecondsSinceEpoch(last))), style: context.mutedStyle),
                const SizedBox(height: 12),
                FilledButton.icon(onPressed: _busy ? null : _backup, icon: Icon(appIcon('download-simple')), label: Text(l.backupCreate)),
                const SizedBox(height: 8),
                OutlinedButton.icon(onPressed: _busy ? null : _restore, icon: Icon(appIcon('upload-simple')), label: Text(l.backupRestore), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52))),
                Padding(padding: const EdgeInsets.only(top: 4), child: Text(l.backupRestoreHint, style: context.mutedStyle)),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [Icon(appIcon('file-csv')), const SizedBox(width: 12), Expanded(child: Text(l.exportCsv, style: Theme.of(context).textTheme.titleMedium))]),
                const SizedBox(height: 8),
                Text(l.exportCsvHint, style: context.mutedStyle),
                const SizedBox(height: 12),
                Wrap(spacing: 8, children: [
                  ChoiceChip(label: Text(l.exportAll), selected: _range == 'all', onSelected: (_) => setState(() => _range = 'all')),
                  ChoiceChip(label: Text(l.exportThisMonth), selected: _range == 'month', onSelected: (_) => setState(() => _range = 'month')),
                  ChoiceChip(
                    label: Text(_range == 'custom' ? '${fmtDayMonth(prefs, _from.toDateTime())} → ${fmtDayMonth(prefs, _to.toDateTime())}' : l.exportCustom),
                    selected: _range == 'custom',
                    onSelected: (_) async {
                      final r = await showPersianDateRangePicker(
                        context: context,
                        initialDateRange: JalaliRange(start: _from, end: _to),
                        initialDate: _to,
                        firstDate: Jalali(1390),
                        lastDate: Jalali.now().addDays(1),
                      );
                      if (r != null) {
                        setState(() {
                          _from = r.start;
                          _to = r.end;
                          _range = 'custom';
                        });
                      }
                    },
                  ),
                ]),
                const SizedBox(height: 12),
                FilledButton.icon(onPressed: _busy ? null : _export, icon: Icon(appIcon('export')), label: Text(l.exportCsv)),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [Icon(appIcon('file-arrow-down')), const SizedBox(width: 12), Expanded(child: Text(l.importCsv, style: Theme.of(context).textTheme.titleMedium))]),
                const SizedBox(height: 8),
                Text(l.importCsvHint, style: context.mutedStyle),
                const SizedBox(height: 12),
                OutlinedButton.icon(onPressed: _busy ? null : _import, icon: Icon(appIcon('folder-open')), label: Text(l.importCsv), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52))),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Text(l.cliHint, style: context.mutedStyle),
        ]),
        if (_busy)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black38,
              child: Center(
                child: Card(
                  child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const CircularProgressIndicator(), const SizedBox(height: 16), Text(l.backupWorking)])),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
