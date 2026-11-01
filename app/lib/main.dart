import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import 'db/database.dart';
import 'features/home.dart';
import 'features/lock.dart';
import 'features/onboarding.dart';
import 'features/people.dart';
import 'features/reports.dart';
import 'features/routes.dart';
import 'services/notifier.dart';
import 'services/sync.dart';
import 'repo.dart';
import 'features/transactions.dart';
import 'features/tx_sheet.dart';
import 'icons/app_icon.dart';
import 'l10n/app_localizations.dart';
import 'state.dart';
import 'theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: DaftarApp()));
}

/// Headless entrypoint run by the Android SyncWorker after a new SMS.
@pragma('vm:entry-point')
Future<void> backgroundSync() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDb();
  try {
    await syncSms(db);
  } catch (_) {
    // The worker retries on its next run; never leave the engine hanging.
  } finally {
    await db.close();
    await const MethodChannel('daftar/bg').invokeMethod('done');
  }
}

class DaftarApp extends ConsumerWidget {
  const DaftarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(prefsProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (c) => AppLocalizations.of(c).appName,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: prefs.theme,
      locale: prefs.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        PersianMaterialLocalizations.delegate,
        PersianCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const LockGate(child: Shell()),
    );
  }
}

class Shell extends ConsumerStatefulWidget {
  const Shell({super.key});

  @override
  ConsumerState<Shell> createState() => _ShellState();
}

class _ShellState extends ConsumerState<Shell> with WidgetsBindingObserver {
  static const _sms = MethodChannel('daftar/sms');
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notificationTaps.addListener(_onTap);
    _sms.setMethodCallHandler((call) async {
      // The background worker wrote to the DB from another isolate.
      if (call.method == 'synced') {
        final db = ref.read(dbProvider);
        db.markTablesUpdated(db.allTables);
      }
    });
    _boot();
  }

  Future<void> _boot() async {
    final db = ref.read(dbProvider);
    await initNotifications();
    final repo = ref.read(repoProvider);
    if (await repo.setting('installed_at') == null) await repo.putSetting('installed_at', '${DateTime.now().millisecondsSinceEpoch}');
    if (await repo.setting('live_sync') != 'false') {
      await const MethodChannel('daftar/system').invokeMethod('setLiveSync', {'enabled': true});
    }
    if (await repo.setting('secure_screen') == 'true') {
      await const MethodChannel('daftar/system').invokeMethod('setSecure', {'secure': true});
    }
    await syncReminders(db);
    await _sync();
    final launch = await launchPayload();
    if (mounted && launch != null) routePayload(context, ref, launch);
  }

  Future<void> _sync() async {
    if (_syncing) return;
    _syncing = true;
    try {
      await syncSms(ref.read(dbProvider));
    } catch (_) {
      // best effort; the periodic worker will try again
    } finally {
      _syncing = false;
    }
  }

  void _onTap() {
    final p = notificationTaps.value;
    if (p != null && mounted) routePayload(context, ref, p);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _sync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    notificationTaps.removeListener(_onTap);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tab = ref.watch(tabProvider);
    final settings = ref.watch(settingsMapProvider);
    if (!settings.hasValue) return const Scaffold();
    if (settings.value!['onboarded'] != 'true') return const OnboardingScreen();
    NavigationDestination dest(String icon, String label) => NavigationDestination(
          icon: Icon(appIcon(icon)),
          selectedIcon: Icon(appIcon('$icon:fill')),
          label: label,
        );
    return Scaffold(
      body: IndexedStack(index: tab, children: [
        const HomeScreen(),
        const TransactionsScreen(),
        const ReportsScreen(),
        const PeopleScreen(),
      ]),
      floatingActionButton: tab <= 1
          ? FloatingActionButton.extended(
              onPressed: () => showAddSheet(context),
              icon: Icon(appIcon('plus:bold')),
              label: Text(l.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: ref.read(tabProvider.notifier).go,
        destinations: [
          dest('house', l.tabHome),
          dest('receipt', l.tabTransactions),
          dest('chart-pie-slice', l.tabReports),
          dest('users', l.tabPeople),
        ],
      ),
    );
  }
}
