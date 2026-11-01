import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../services/notifier.dart';
import '../state.dart';
import '../ui/widgets.dart';
import 'import_sms.dart';
import 'security_screen.dart';
import '../services/lock.dart';

/// First launch: language, then three optional permissions, then import.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _sms = false, _notif = false;

  Widget _step(String icon, String title, String hint, bool done, VoidCallback onTap) => Card(
        child: ListTile(
          minVerticalPadding: 14,
          leading: IconAvatar(done ? 'check-circle:fill' : icon, done ? 0xFF059669 : 0xFF1E40AF),
          title: Text(title),
          subtitle: Text(hint),
          trailing: done ? null : Icon(appIcon(Directionality.of(context) == TextDirection.rtl ? 'caret-left' : 'caret-right'), size: 18),
          onTap: done ? null : onTap,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final lockOn = ref.watch(settingsMapProvider).value?['lock_enabled'] == 'true';
    final repo = ref.read(repoProvider);
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(24), children: [
          const SizedBox(height: 16),
          Center(child: ClipRRect(borderRadius: BorderRadius.circular(22), child: Image.asset('assets/brand/logo.png', width: 96, height: 96))),
          const SizedBox(height: 24),
          Text(l.welcomeTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(l.welcomeHint, style: context.mutedStyle, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Center(
            child: SegmentedButton<String>(
              showSelectedIcon: false,
              segments: const [ButtonSegment(value: 'en', label: Text('English')), ButtonSegment(value: 'fa', label: Text('فارسی'))],
              selected: {prefs.lang},
              onSelectionChanged: (s) => ref.read(prefsProvider.notifier).setLang(s.first),
            ),
          ),
          const SizedBox(height: 24),
          _step('chat-text', l.welcomeSms, l.welcomeSmsHint, _sms, () async {
            final ok = await const MethodChannel('daftar/system').invokeMethod<bool>('requestSmsPermission') ?? false;
            if (mounted) setState(() => _sms = ok);
          }),
          const SizedBox(height: 8),
          _step('bell-ringing', l.welcomeNotif, l.welcomeNotifHint, _notif, () async {
            final ok = await requestNotificationPermission();
            if (mounted) setState(() => _notif = ok);
          }),
          const SizedBox(height: 8),
          _step('lock-key', l.welcomeLock, l.welcomeLockHint, lockOn, () async {
            final pin = await Navigator.of(context).push<String>(MaterialPageRoute(builder: (_) => const PinSetupScreen()));
            if (pin != null) {
              await savePin(pin);
              await repo.putSetting('lock_len', '${pin.length}');
              await repo.putSetting('lock_enabled', 'true');
            }
          }),
        ]),
      ),
      bottomNavigationBar: BottomBar(
        child: FilledButton(
          onPressed: () async {
            await repo.putSetting('onboarded', 'true');
            if (context.mounted) push(context, const ImportSmsScreen());
          },
          child: Text(l.welcomeStart),
        ),
      ),
    );
  }
}
