import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state.dart';
import '../ui/widgets.dart';
import 'budgets.dart';
import 'inbox.dart';
import 'leaks.dart';
import 'people.dart';
import 'recurring.dart';
import 'review.dart';
import 'tx_sheet.dart';

/// Opens the screen a notification or inbox item points at.
void routePayload(BuildContext context, WidgetRef ref, String? payload) {
  if (payload == null) return;
  final parts = payload.split(':');
  switch (parts.first) {
    case 'tx':
      final id = int.tryParse(parts.elementAtOrNull(1) ?? '');
      if (id != null) showTxSheet(context, id);
    case 'person':
      final id = int.tryParse(parts.elementAtOrNull(1) ?? '');
      if (id != null) push(context, PersonScreen(id));
    case 'review':
      push(context, const ReviewScreen());
    case 'reports':
      ref.read(tabProvider.notifier).go(2);
    case 'budgets':
      push(context, const BudgetsScreen());
    case 'leaks':
      push(context, const LeaksScreen());
    case 'recurring':
      push(context, const RecurringScreen());
    case 'transfers':
      ref.read(tabProvider.notifier).go(0);
    case 'inbox':
      push(context, const InboxScreen());
  }
}
