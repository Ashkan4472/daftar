import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../icons/app_icon.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../state.dart';
import '../ui/format.dart';
import '../ui/widgets.dart';

/// One-line note under an account balance: where the number came from.
String balanceCaption(AppLocalizations l, Prefs prefs, AccountBalance b) {
  final at = b.asOf;
  if (at == null) return l.balanceComputed;
  final when = '${fmtDayMonth(prefs, at)} ${fmtTime(prefs, at)}';
  return b.source == BalanceSource.manual ? l.balanceSetByYou(when) : l.balanceFromSms(when);
}

/// Set the account's real balance when SMS do not show it (or not yet).
Future<void> showBalanceSheet(BuildContext context, WidgetRef ref, AccountBalance ab) {
  final l = AppLocalizations.of(context);
  final prefs = ref.read(prefsProvider);
  final repo = ref.read(repoProvider);
  final unit = prefs.toman ? 10 : 1;
  final amount = TextEditingController(text: formatMoney(ab.balance.abs() ~/ unit));
  var negative = ab.balance < 0;
  var at = DateTime.now();
  String? error;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => SheetFrame(
        action: FilledButton(
          onPressed: () async {
            final v = parseMoney(amount.text);
            if (v == null) {
              setState(() => error = l.amountRequired);
              return;
            }
            final nav = Navigator.of(ctx);
            await repo.setBalance(ab.account.id, (negative ? -1 : 1) * v * unit, at);
            nav.pop();
          },
          child: Text(l.save),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            IconAvatar(ab.account.icon, ab.account.color, size: 40),
            const SizedBox(width: 12),
            Expanded(child: Text('${l.balanceUpdateTitle}\n${ab.account.name}', style: Theme.of(ctx).textTheme.titleMedium)),
          ]),
          const SizedBox(height: 16),
          TextField(
            controller: amount,
            autofocus: true,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            inputFormatters: [MoneyInputFormatter()],
            style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            decoration: InputDecoration(labelText: l.balance, suffixText: prefs.toman ? l.toman : l.rial, errorText: error),
            onChanged: (_) => setState(() => error = null),
          ),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.balanceNegative), value: negative, onChanged: (v) => setState(() => negative = v)),
          OutlinedButton.icon(
            icon: Icon(appIcon('calendar-blank')),
            label: Text('${l.balanceAsOf}  ${fmtDate(prefs, at)} · ${fmtTime(prefs, at)}'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: () async {
              final j = await showPersianDatePicker(context: ctx, initialDate: Jalali.fromDateTime(at), firstDate: Jalali(1390), lastDate: Jalali.now().addDays(1));
              if (j == null || !ctx.mounted) return;
              final t = await showTimePicker(context: ctx, initialTime: TimeOfDay.fromDateTime(at));
              final d = j.toDateTime();
              setState(() => at = DateTime(d.year, d.month, d.day, t?.hour ?? at.hour, t?.minute ?? at.minute));
            },
          ),
          const SizedBox(height: 12),
          Text(l.balanceSetHint, style: ctx.mutedStyle),
          if (ab.source == BalanceSource.manual)
            TextButton.icon(
              icon: Icon(appIcon('arrow-counter-clockwise')),
              label: Text(l.balanceClear),
              onPressed: () async {
                final nav = Navigator.of(ctx);
                await repo.setBalance(ab.account.id, null, null);
                nav.pop();
              },
            ),
        ]),
      ),
    ),
  );
}
