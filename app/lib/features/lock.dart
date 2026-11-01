import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../services/lock.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/widgets.dart' show MutedText;

/// Numeric keypad with PIN dots. Calls [onComplete] when [length] digits are in.
class PinPad extends ConsumerStatefulWidget {
  const PinPad({super.key, required this.title, required this.onComplete, this.length = 4, this.error, this.extra, this.disabled = false});
  final String title;
  final int length;
  final String? error;
  final bool disabled;
  final Widget? extra; // bottom-left key (e.g. fingerprint)
  final Future<void> Function(String pin) onComplete;

  @override
  ConsumerState<PinPad> createState() => PinPadState();
}

class PinPadState extends ConsumerState<PinPad> with SingleTickerProviderStateMixin {
  String _pin = '';
  late final _shake = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));

  void clear() => setState(() => _pin = '');

  Future<void> shake() async {
    HapticFeedback.heavyImpact();
    await _shake.forward(from: 0);
    clear();
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  void _tap(String d) {
    if (widget.disabled || _pin.length >= widget.length) return;
    HapticFeedback.selectionClick();
    setState(() => _pin += d);
    if (_pin.length == widget.length) widget.onComplete(_pin);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(prefsProvider);
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    Widget key(String d) => Semantics(
          button: true,
          label: d,
          child: SizedBox(
            width: 76,
            height: 76,
            child: Material(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => _tap(d),
                child: Center(child: Text(prefs.digits(d), style: t.headlineMedium?.copyWith(fontFeatures: tabular))),
              ),
            ),
          ),
        );

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(widget.title, style: t.titleLarge, textAlign: TextAlign.center),
      const SizedBox(height: 24),
      AnimatedBuilder(
        animation: _shake,
        builder: (_, child) => Transform.translate(offset: Offset(math.sin(_shake.value * 6 * math.pi) * 12 * (1 - _shake.value), 0), child: child),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var i = 0; i < widget.length; i++)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < _pin.length ? scheme.primary : Colors.transparent,
                border: Border.all(color: widget.error != null ? scheme.error : scheme.primary, width: 2),
              ),
            ),
        ]),
      ),
      SizedBox(height: 32, child: Center(child: widget.error == null ? null : Text(widget.error!, style: TextStyle(color: scheme.error)))),
      const SizedBox(height: 8),
      Directionality(
        textDirection: TextDirection.ltr,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final row in const [['1', '2', '3'], ['4', '5', '6'], ['7', '8', '9']])
            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisSize: MainAxisSize.min, children: [for (final d in row) Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: key(d))])),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: SizedBox(width: 76, height: 76, child: widget.extra)),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: key('0')),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: 76,
                  height: 76,
                  child: IconButton(
                    tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                    onPressed: _pin.isEmpty ? null : () => setState(() => _pin = _pin.substring(0, _pin.length - 1)),
                    icon: Icon(appIcon('backspace'), size: 28),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    ]);
  }
}

/// True while the lock screen covers the app. Routes opened from notifications wait for it.
final appLocked = ValueNotifier<bool>(true);

/// Shows [child] and covers it with a PIN screen while locked.
class LockGate extends ConsumerStatefulWidget {
  const LockGate({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate> with WidgetsBindingObserver {
  bool _locked = true;
  bool _decided = false;
  DateTime? _leftAt;
  int _fails = 0;
  DateTime? _blockedUntil;
  String? _error;
  final _pad = GlobalKey<PinPadState>();
  bool _bioTried = false;
  bool _bioBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Map<String, String> get _s => ref.read(settingsMapProvider).value ?? const {};
  bool get _enabled => _s['lock_enabled'] == 'true';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) _leftAt = DateTime.now();
    // The prompt is cancelled when the app pauses (e.g. while a notification launch settles); ask again once visible.
    if (state == AppLifecycleState.resumed && _locked && _decided && _s['lock_bio'] == 'true') _bio();
    if (state == AppLifecycleState.resumed && _enabled && _leftAt != null) {
      final secs = int.tryParse(_s['lock_timeout'] ?? '') ?? 60;
      if (DateTime.now().difference(_leftAt!).inSeconds >= secs && !_locked) {
        setState(() {
          _locked = true;
          _bioTried = false;
          _error = null;
        });
      }
    }
  }

  Future<void> _bio() async {
    if (_bioBusy) return;
    _bioBusy = true;
    final l = AppLocalizations.of(context);
    try {
      if (await biometricUnlock(l.lockBioReason) && mounted) setState(() => _locked = false);
    } finally {
      _bioBusy = false;
    }
  }

  Future<void> _check(String pin) async {
    final l = AppLocalizations.of(context);
    if (_blockedUntil != null && DateTime.now().isBefore(_blockedUntil!)) return;
    if (await verifyPin(pin)) {
      if (mounted) setState(() {
        _locked = false;
        _fails = 0;
        _error = null;
      });
      return;
    }
    _fails++;
    if (_fails >= 5) {
      _blockedUntil = DateTime.now().add(const Duration(seconds: 30));
      _fails = 0;
      _error = l.lockTooMany(30);
    } else {
      _error = l.lockWrongPin;
    }
    setState(() {});
    await _pad.currentState?.shake();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsMapProvider);
    if (!_decided && settings.hasValue) {
      _decided = true;
      _locked = settings.value!['lock_enabled'] == 'true';
    }
    final show = _locked && (!_decided || _enabled || settings.value?['lock_enabled'] == 'true');
    final bio = _s['lock_bio'] == 'true';
    if (show && _decided && bio && !_bioTried) {
      _bioTried = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _bio());
    }
    if (appLocked.value != show) WidgetsBinding.instance.addPostFrameCallback((_) => appLocked.value = show);
    final blocked = _blockedUntil != null && DateTime.now().isBefore(_blockedUntil!);
    return Stack(children: [
      ExcludeSemantics(excluding: show, child: widget.child),
      if (!_decided) Positioned.fill(child: ColoredBox(color: Theme.of(context).scaffoldBackgroundColor)),
      if (show && _decided)
        Positioned.fill(
          child: PopScope(
            canPop: false,
            child: Scaffold(
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(appIcon('lock-simple:duotone'), size: 56, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 16),
                      PinPad(
                        key: _pad,
                        title: l.lockEnterPin,
                        length: int.tryParse(_s['lock_len'] ?? '') ?? 4,
                        error: _error,
                        disabled: blocked,
                        onComplete: _check,
                        extra: bio ? IconButton(tooltip: l.lockUseBio, onPressed: _bio, icon: Icon(appIcon('fingerprint'), size: 32)) : null,
                      ),
                      const SizedBox(height: 8),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 32), child: Text(l.lockForgot, textAlign: TextAlign.center, style: context.mutedStyle)),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}
