import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/format.dart';
import '../ui/widgets.dart';
import 'import_sms.dart';
import 'manage.dart';
import 'more_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final n = ref.read(prefsProvider.notifier);

    Widget item(String icon, String title, Widget page, {String? subtitle}) => ListTile(
          minVerticalPadding: 12,
          leading: Icon(appIcon(icon)),
          title: Text(title),
          subtitle: subtitle == null ? null : Text(subtitle),
          trailing: Icon(appIcon(Directionality.of(context) == TextDirection.rtl ? 'caret-left' : 'caret-right'), size: 18, color: context.money.muted),
          onTap: () => push(context, page),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(padding: const EdgeInsets.only(bottom: 32), children: [
        SectionHeaderPadded(l.settingsGeneral),
        ListTile(
          leading: Icon(appIcon('translate')),
          title: Text(l.language),
          trailing: SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [ButtonSegment(value: 'en', label: Text('English')), ButtonSegment(value: 'fa', label: Text('فارسی'))],
            selected: {prefs.lang},
            onSelectionChanged: (s) => n.setLang(s.first),
          ),
        ),
        ListTile(
          leading: Icon(appIcon('circle-half')),
          title: Text(l.themeTitle),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: ThemeMode.system, label: Text(l.themeSystem)),
                ButtonSegment(value: ThemeMode.light, label: Text(l.themeLight)),
                ButtonSegment(value: ThemeMode.dark, label: Text(l.themeDark)),
              ],
              selected: {prefs.theme},
              onSelectionChanged: (s) => n.setTheme(s.first),
            ),
          ),
        ),
        SwitchListTile(
          secondary: Icon(appIcon('coins')),
          title: Text(l.showToman),
          value: prefs.toman,
          onChanged: n.setToman,
        ),
        SectionHeaderPadded(l.settingsOrganize),
        item('squares-four', l.manageCategories, const CategoriesScreen()),
        item('hash', l.manageTags, const TagsScreen()),
        item('wallet', l.manageAccounts, const AccountsScreen()),
        SectionHeaderPadded(l.settingsData),
        item('download-simple', l.importSms, const ImportSmsScreen()),
        item('chat-text', l.unmatchedSms, const UnmatchedSmsScreen()),
        item('trash', l.trash, const TrashScreen()),
        SectionHeaderPadded('${l.securityTitle} · ${l.backupTitle}'),
        ...moreSettingsItems(context, item),
        SectionHeaderPadded(l.settingsAbout),
        ListTile(leading: Icon(appIcon('lock-key')), title: Text(l.aboutText)),
      ]),
    );
  }
}

class SectionHeaderPadded extends StatelessWidget {
  const SectionHeaderPadded(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 4),
        child: Text(title, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
      );
}

class TrashScreen extends ConsumerStatefulWidget {
  const TrashScreen({super.key});

  @override
  ConsumerState<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends ConsumerState<TrashScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(repoProvider).purgeTrash();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final db = ref.watch(dbProvider);
    final repo = ref.read(repoProvider);
    final stream = (db.select(db.transactions)
          ..where((t) => t.deletedAt.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.deletedAt)])
          ..limit(200))
        .watch();
    return Scaffold(
      appBar: AppBar(title: Text(l.trash)),
      body: StreamBuilder(
        stream: stream,
        builder: (context, snap) {
          final rows = snap.data ?? const <Transaction>[];
          if (rows.isEmpty) return EmptyState(icon: 'trash', title: l.trashEmpty, hint: l.trashHint);
          return ListView(children: [
            Padding(padding: const EdgeInsets.all(16), child: Text(l.trashHint, style: context.mutedStyle)),
            for (final t in rows)
              ListTile(
                title: Amount(t.amount, style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text('${fmtDate(prefs, t.occurredAt)} · ${fmtTime(prefs, t.occurredAt)}'),
                trailing: TextButton.icon(
                  icon: Icon(appIcon('arrow-counter-clockwise')),
                  label: Text(l.restore),
                  onPressed: () => repo.restore([t.id]),
                ),
              ),
          ]);
        },
      ),
    );
  }
}

class UnmatchedSmsScreen extends ConsumerWidget {
  const UnmatchedSmsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final db = ref.watch(dbProvider);
    final stream = (db.select(db.rawSms)
          ..where((r) => r.status.equals(SmsStatus.unmatched.name))
          ..orderBy([(r) => OrderingTerm.desc(r.receivedAt)])
          ..limit(300))
        .watch();
    return Scaffold(
      appBar: AppBar(title: Text(l.unmatchedSms)),
      body: StreamBuilder(
        stream: stream,
        builder: (context, snap) {
          final rows = snap.data ?? const <RawSmsRow>[];
          if (rows.isEmpty) return EmptyState(icon: 'check-circle:duotone', title: l.unmatchedEmpty);
          return ListView(padding: const EdgeInsets.all(16), children: [
            Text(l.unmatchedHint, style: context.mutedStyle),
            const SizedBox(height: 12),
            for (final r in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${r.address} · ${fmtDate(prefs, r.receivedAt)}', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 8),
                      SelectableText(r.body),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, children: [
                        FilledButton.tonalIcon(
                          icon: Icon(appIcon('magic-wand')),
                          label: Text(l.teachFormat),
                          onPressed: () => openTemplateBuilder(context, r),
                        ),
                        TextButton(
                          onPressed: () => (db.update(db.rawSms)..where((x) => x.id.equals(r.id))).write(const RawSmsCompanion(status: Value(SmsStatus.ignored))),
                          child: Text(l.ignoreMessage),
                        ),
                        TextButton(
                          onPressed: () async {
                            await db.into(db.smsSenders).insert(SmsSendersCompanion.insert(address: r.address, ignored: const Value(true)),
                                onConflict: DoUpdate((_) => const SmsSendersCompanion(ignored: Value(true)), target: [db.smsSenders.address]));
                            await (db.update(db.rawSms)..where((x) => x.address.equals(r.address) & x.status.equals(SmsStatus.unmatched.name)))
                                .write(const RawSmsCompanion(status: Value(SmsStatus.ignored)));
                            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.senderIgnored)));
                          },
                          child: Text(l.ignoreSender),
                        ),
                      ]),
                    ]),
                  ),
                ),
              ),
          ]);
        },
      ),
    );
  }
}
