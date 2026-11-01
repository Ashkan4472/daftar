import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../services/lock.dart';
import '../state.dart';
import '../ui/widgets.dart';
import 'lock.dart';

/// Choose a PIN (twice). Returns the PIN, or null if the user backs out.
class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  int _len = 4;
  String? _first, _error;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            if (_first == null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: const [ButtonSegment(value: 4, label: Text('4')), ButtonSegment(value: 6, label: Text('6'))],
                  selected: {_len},
                  onSelectionChanged: (s) => setState(() => _len = s.first),
                ),
              ),
            PinPad(
              key: ValueKey('$_len${_first == null}'),
              length: _len,
              title: _first == null ? l.lockSetPin : l.lockRepeatPin,
              error: _error,
              onComplete: (pin) async {
                if (_first == null) {
                  setState(() {
                    _first = pin;
                    _error = null;
                  });
                } else if (pin == _first) {
                  Navigator.pop(context, pin);
                } else {
                  setState(() {
                    _first = null;
                    _error = l.lockMismatch;
                  });
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}

Future<bool> _confirmPin(BuildContext context) async {
  final l = AppLocalizations.of(context);
  final len = int.tryParse((await _lenSetting(context)) ?? '') ?? 4;
  if (!context.mounted) return false;
  final res = await Navigator.of(context).push<bool>(MaterialPageRoute(
    builder: (ctx) => Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: PinPad(
            length: len,
            title: l.lockEnterPin,
            onComplete: (pin) async {
              if (await verifyPin(pin)) {
                if (ctx.mounted) Navigator.pop(ctx, true);
              }
            },
          ),
        ),
      ),
    ),
  ));
  return res == true;
}

Future<String?> _lenSetting(BuildContext context) async {
  final c = ProviderScope.containerOf(context);
  return c.read(repoProvider).setting('lock_len');
}

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  bool _bioAvailable = false;

  @override
  void initState() {
    super.initState();
    biometricsAvailable().then((v) => mounted ? setState(() => _bioAvailable = v) : null);
  }

  Future<void> _savePin(String pin) async {
    final repo = ref.read(repoProvider);
    await savePin(pin);
    await repo.putSetting('lock_len', '${pin.length}');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = ref.watch(settingsMapProvider).value ?? const <String, String>{};
    final repo = ref.read(repoProvider);
    final enabled = s['lock_enabled'] == 'true';
    final timeout = int.tryParse(s['lock_timeout'] ?? '') ?? 60;
    const system = MethodChannel('daftar/system');

    return Scaffold(
      appBar: AppBar(title: Text(l.securityTitle)),
      body: ListView(children: [
        SwitchListTile(
          secondary: Icon(appIcon('lock-key')),
          title: Text(l.lockEnable),
          subtitle: Text(l.lockEnableHint),
          value: enabled,
          onChanged: (v) async {
            if (v) {
              final pin = await Navigator.of(context).push<String>(MaterialPageRoute(builder: (_) => const PinSetupScreen()));
              if (pin != null) {
                await _savePin(pin);
                await repo.putSetting('lock_enabled', 'true');
              }
            } else if (await _confirmPin(context)) {
              await clearPin();
              await repo.putSetting('lock_enabled', 'false');
              await repo.putSetting('lock_bio', 'false');
            }
          },
        ),
        if (enabled) ...[
          if (_bioAvailable)
            SwitchListTile(
              secondary: Icon(appIcon('fingerprint')),
              title: Text(l.lockBiometric),
              value: s['lock_bio'] == 'true',
              onChanged: (v) => repo.putSetting('lock_bio', '$v'),
            ),
          ListTile(
            leading: Icon(appIcon('password')),
            title: Text(l.lockChangePin),
            onTap: () async {
              if (!await _confirmPin(context) || !context.mounted) return;
              final pin = await Navigator.of(context).push<String>(MaterialPageRoute(builder: (_) => const PinSetupScreen()));
              if (pin != null) await _savePin(pin);
            },
          ),
          SectionHeader(l.lockTimeout),
          for (final (secs, label) in [(0, l.lockImmediately), (60, l.lockAfter1), (300, l.lockAfter5)])
            RadioListTile<int>(
              title: Text(label),
              value: secs,
              groupValue: timeout,
              onChanged: (v) => repo.putSetting('lock_timeout', '$v'),
            ),
        ],
        const Divider(),
        SwitchListTile(
          secondary: Icon(appIcon('eye-slash')),
          title: Text(l.lockHideScreen),
          value: s['secure_screen'] == 'true',
          onChanged: (v) async {
            await repo.putSetting('secure_screen', '$v');
            await system.invokeMethod('setSecure', {'secure': v});
          },
        ),
      ]),
    );
  }
}
