import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../services/notifier.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/widgets.dart';
import 'backup_screen.dart';
import 'recurring.dart';
import 'security_screen.dart';
import 'template_builder.dart';

/// Extra settings rows (security, backup, ...) beyond the basics.
List<Widget> moreSettingsItems(BuildContext context, Widget Function(String icon, String title, Widget page, {String? subtitle}) item) {
  final l = AppLocalizations.of(context);
  return [
    item('lock-key', l.securityTitle, const SecurityScreen()),
    item('cloud-arrow-down', l.backupTitle, const BackupScreen()),
    item('bell', l.notifSettings, const NotificationSettingsScreen()),
    item('repeat', l.recurringTitle, const RecurringScreen()),
  ];
}

void openTemplateBuilder(BuildContext context, RawSmsRow sms) => push(context, TemplateBuilderScreen(sms));

const _system = MethodChannel('daftar/system');

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  bool? _battery;

  @override
  void initState() {
    super.initState();
    _checkBattery();
  }

  Future<void> _checkBattery() async {
    final v = await _system.invokeMethod<bool>('isIgnoringBatteryOptimizations');
    if (mounted) setState(() => _battery = v);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsMapProvider).value ?? const <String, String>{};
    final repo = ref.read(repoProvider);
    bool on(String k) => settings[k] != 'false';
    Widget sw(String key, String title, {String? subtitle, void Function(bool)? also}) => SwitchListTile(
          title: Text(title),
          subtitle: subtitle == null ? null : Text(subtitle),
          value: on(key),
          onChanged: (v) {
            repo.putSetting(key, '$v');
            also?.call(v);
          },
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.notifSettings)),
      body: ListView(children: [
        ListTile(
          leading: Icon(appIcon('bell-ringing')),
          title: Text(l.notifPermission),
          subtitle: Text(l.notifPermissionHint),
          onTap: requestNotificationPermission,
        ),
        FutureBuilder(
          future: exactAlarmsAllowed(),
          builder: (c, s) => s.data == true
              ? const SizedBox.shrink()
              : ListTile(leading: Icon(appIcon('alarm')), title: Text(l.exactAlarmHint), onTap: requestExactAlarms),
        ),
        const Divider(),
        sw('live_sync', l.autoSync, subtitle: l.autoSyncHint, also: (v) => _system.invokeMethod('setLiveSync', {'enabled': v})),
        if (_battery == false)
          ListTile(
            leading: Icon(appIcon('battery-warning'), color: context.money.warning),
            title: Text(l.batteryHint),
            trailing: TextButton(onPressed: () async { await _system.invokeMethod('openBatterySettings'); _checkBattery(); }, child: Text(l.openBatterySettings)),
          ),
        const Divider(),
        sw('notif_capture', l.notifTypeCapture),
        sw('notif_budget', l.notifTypeBudget),
        sw('notif_leak', l.notifTypeLeak),
        sw('notif_summary', l.notifTypeSummary),
        sw('notif_transfer', l.notifTypeTransfer),
      ]),
    );
  }
}
