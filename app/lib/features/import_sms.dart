import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../l10n/app_localizations.dart';
import '../sms/importer.dart';
import '../state.dart';
import '../ui/widgets.dart';

class ImportSmsScreen extends ConsumerStatefulWidget {
  const ImportSmsScreen({super.key});

  @override
  ConsumerState<ImportSmsScreen> createState() => _ImportSmsScreenState();
}

class _ImportSmsScreenState extends ConsumerState<ImportSmsScreen> {
  // Default: the current Jalali month up to today.
  late Jalali _from = Jalali.now().withDay(1);
  late Jalali _to = Jalali.now();
  bool _running = false, _cancel = false;
  int _done = 0, _total = 0;
  String? _message;
  bool _ok = false;

  Future<void> _pick() async {
    final r = await showPersianDateRangePicker(
      context: context,
      initialDateRange: JalaliRange(start: _from, end: _to),
      initialDate: _to,
      firstDate: Jalali(1390),
      lastDate: Jalali.now(),
    );
    if (r != null) {
      setState(() {
        _from = r.start;
        _to = r.end;
      });
    }
  }

  Future<void> _run() async {
    final l = AppLocalizations.of(context);
    final importer = SmsImporter(ref.read(dbProvider));
    if (!await importer.ensurePermission()) {
      setState(() {
        _message = l.smsPermissionDenied;
        _ok = false;
      });
      return;
    }
    setState(() {
      _running = true;
      _cancel = false;
      _done = 0;
      _total = 0;
      _message = null;
    });
    try {
      final res = await importer.importRange(
        _from.toDateTime(),
        _to.addDays(1).toDateTime(), // inclusive end day
        onProgress: (d, t) {
          if (mounted) {
            setState(() {
              _done = d;
              _total = t;
            });
          }
        },
        isCancelled: () => _cancel,
      );
      _message = l.importDone(res.added, res.unmatched);
      _ok = true;
    } catch (e) {
      _message = '$e';
      _ok = false;
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  List<(String, Jalali, Jalali)> _presets(AppLocalizations l) {
    final now = Jalali.now();
    final first = now.withDay(1);
    final lastMonthEnd = first.addDays(-1);
    return [
      (l.presetThisMonth, first, now),
      (l.presetLastMonth, lastMonthEnd.withDay(1), lastMonthEnd),
      (l.preset3Months, first.addMonths(-2), now),
      (l.presetYear, Jalali(now.year, 1, 1), now),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    String fmt(Jalali j) => prefs.digits('${j.year}/${j.month.toString().padLeft(2, '0')}/${j.day.toString().padLeft(2, '0')}');
    return Scaffold(
      appBar: AppBar(title: Text(l.importSmsTitle)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(l.importHint, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final (label, from, to) in _presets(l))
            ActionChip(label: Text(label), onPressed: _running ? null : () => setState(() { _from = from; _to = to; })),
        ]),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            enabled: !_running,
            title: Text('${l.from} ${fmt(_from)}   ${l.to} ${fmt(_to)}'),
            trailing: const Icon(Icons.edit_calendar_outlined),
            onTap: _pick,
          ),
        ),
        if (_running) ...[
          const SizedBox(height: 24),
          LinearProgressIndicator(value: _total == 0 ? null : _done / _total),
          const SizedBox(height: 8),
          Text(prefs.digits(l.importProgress(_done, _total))),
        ],
        if (_message != null) ...[
          const SizedBox(height: 16),
          Text(prefs.digits(_message!)),
          if (_ok) ...[const SizedBox(height: 8), Text(l.importResultHint, style: Theme.of(context).textTheme.bodySmall)],
        ],
      ]),
      bottomNavigationBar: BottomBar(
        child: _running
            ? OutlinedButton(onPressed: () => _cancel = true, style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)), child: Text(l.cancel))
            : FilledButton(onPressed: _run, child: Text(l.startImport)),
      ),
    );
  }
}
