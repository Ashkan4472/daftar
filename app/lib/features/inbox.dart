import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../state.dart';
import '../theme/theme.dart';
import '../ui/format.dart';
import '../ui/widgets.dart';
import 'routes.dart';

final inboxProvider = StreamProvider<List<InboxItem>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.inboxItems)..orderBy([(i) => OrderingTerm.desc(i.createdAt), (i) => OrderingTerm.desc(i.id)])..limit(150)).watch();
});

final unreadCountProvider = Provider<int>((ref) => (ref.watch(inboxProvider).value ?? const <InboxItem>[]).where((i) => !i.read).length);

String _icon(String kind) => switch (kind) {
      'capture' => 'chat-text',
      'reminder' => 'bell-ringing',
      'budget' => 'target',
      'leak' => 'drop-half-bottom',
      'summary' => 'chart-pie-slice',
      'transfer' => 'arrows-left-right',
      _ => 'bell',
    };

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final items = ref.watch(inboxProvider).value ?? const <InboxItem>[];
    final db = ref.read(dbProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.inbox), actions: [
        if (items.any((i) => !i.read))
          TextButton(onPressed: () => (db.update(db.inboxItems)).write(const InboxItemsCompanion(read: Value(true))), child: Text(l.markAllRead)),
      ]),
      body: items.isEmpty
          ? EmptyState(icon: 'bell', title: l.inboxEmpty)
          : ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final it = items[i];
                return ListTile(
                  minVerticalPadding: 12,
                  leading: Badge(isLabelVisible: !it.read, smallSize: 10, child: Icon(appIcon(_icon(it.kind)), color: it.read ? context.money.muted : Theme.of(context).colorScheme.primary)),
                  title: Text(it.title, style: TextStyle(fontWeight: it.read ? FontWeight.w400 : FontWeight.w600)),
                  subtitle: Text('${it.body.isEmpty ? '' : '${it.body}\n'}${fmtDate(prefs, it.createdAt)} · ${fmtTime(prefs, it.createdAt)}'),
                  isThreeLine: it.body.isNotEmpty,
                  onTap: () {
                    (db.update(db.inboxItems)..where((x) => x.id.equals(it.id))).write(const InboxItemsCompanion(read: Value(true)));
                    routePayload(context, ref, it.payload);
                  },
                );
              },
            ),
    );
  }
}
