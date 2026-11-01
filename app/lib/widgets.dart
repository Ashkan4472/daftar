import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'icons/app_icon.dart';
import 'state.dart';
import 'theme/theme.dart';

/// Signed, colored amount. Sign is always shown so color is never the only cue.
class Amount extends ConsumerWidget {
  const Amount(this.value, {super.key, this.style, this.neutral = false});
  final int value;
  final TextStyle? style;

  /// Transfers: gray, still signed.
  final bool neutral;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(prefsProvider);
    final color = neutral ? context.money.transfer : context.money.forAmount(value);
    return Text(
      prefs.money(value, signed: true),
      textDirection: TextDirection.ltr,
      style: (style ?? Theme.of(context).textTheme.titleMedium)!
          .copyWith(color: color, fontFeatures: tabular, fontWeight: FontWeight.w600),
    );
  }
}

/// Round tinted avatar with a Phosphor icon.
class IconAvatar extends StatelessWidget {
  const IconAvatar(this.icon, this.color, {super.key, this.size = 40});
  final String icon;
  final int color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = Color(color);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: c.withValues(alpha: 0.14), shape: BoxShape.circle),
      child: Icon(appIcon(icon), color: c, size: size * 0.55),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, this.hint, this.action});
  final String icon;
  final String title;
  final String? hint;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(appIcon(icon), size: 56, color: context.money.muted),
          const SizedBox(height: 16),
          Text(title, style: t.titleMedium, textAlign: TextAlign.center),
          if (hint != null) ...[
            const SizedBox(height: 8),
            Text(hint!, style: t.bodyMedium?.copyWith(color: context.money.muted), textAlign: TextAlign.center),
          ],
          if (action != null) ...[const SizedBox(height: 24), action!],
        ]),
      ),
    );
  }
}
