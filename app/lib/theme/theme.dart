import 'package:flutter/material.dart';

/// Semantic money colors. Always paired with a sign or arrow, never alone.
@immutable
class MoneyColors extends ThemeExtension<MoneyColors> {
  const MoneyColors({
    required this.income,
    required this.expense,
    required this.transfer,
    required this.warning,
    required this.muted,
  });

  final Color income, expense, transfer, warning, muted;

  Color forAmount(int amount) => amount < 0 ? expense : income;

  @override
  MoneyColors copyWith() => this;

  @override
  MoneyColors lerp(MoneyColors? other, double t) => other == null
      ? this
      : MoneyColors(
          income: Color.lerp(income, other.income, t)!,
          expense: Color.lerp(expense, other.expense, t)!,
          transfer: Color.lerp(transfer, other.transfer, t)!,
          warning: Color.lerp(warning, other.warning, t)!,
          muted: Color.lerp(muted, other.muted, t)!,
        );
}

extension MoneyColorsX on BuildContext {
  MoneyColors get money => Theme.of(this).extension<MoneyColors>()!;
}

ThemeData buildTheme(Brightness b) {
  final dark = b == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF1E40AF),
    brightness: b,
    primary: dark ? const Color(0xFF3B82F6) : const Color(0xFF1E40AF),
    surface: dark ? const Color(0xFF101A34) : const Color(0xFFFFFFFF),
    error: dark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
  );
  final border = dark ? const Color(0x14FFFFFF) : const Color(0xFFE2E8F0);
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Vazirmatn',
    scaffoldBackgroundColor: dark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
    dividerColor: border,
  );
  // Vazirmatn on every style (Latin and Persian), including components that
  // read primaryTextTheme or build their own TextStyle from the theme.
  const f = 'Vazirmatn';
  // Material adds tracking to most styles; it spaces out Persian letters and digits.
  TextTheme flat(TextTheme t) => t.copyWith(
        displayLarge: t.displayLarge?.copyWith(letterSpacing: 0),
        displayMedium: t.displayMedium?.copyWith(letterSpacing: 0),
        displaySmall: t.displaySmall?.copyWith(letterSpacing: 0),
        headlineLarge: t.headlineLarge?.copyWith(letterSpacing: 0),
        headlineMedium: t.headlineMedium?.copyWith(letterSpacing: 0),
        headlineSmall: t.headlineSmall?.copyWith(letterSpacing: 0),
        titleLarge: t.titleLarge?.copyWith(letterSpacing: 0),
        titleMedium: t.titleMedium?.copyWith(letterSpacing: 0),
        titleSmall: t.titleSmall?.copyWith(letterSpacing: 0),
        bodyLarge: t.bodyLarge?.copyWith(letterSpacing: 0),
        bodyMedium: t.bodyMedium?.copyWith(letterSpacing: 0),
        bodySmall: t.bodySmall?.copyWith(letterSpacing: 0),
        labelLarge: t.labelLarge?.copyWith(letterSpacing: 0),
        labelMedium: t.labelMedium?.copyWith(letterSpacing: 0),
        labelSmall: t.labelSmall?.copyWith(letterSpacing: 0),
      );
  return base.copyWith(
    textTheme: flat(base.textTheme.apply(fontFamily: f)),
    primaryTextTheme: flat(base.primaryTextTheme.apply(fontFamily: f)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0x0DFFFFFF) : const Color(0xFFF1F5F9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: const Size(48, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(color: border),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: border),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: base.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primary.withValues(alpha: 0.14),
    ),
    extensions: [
      MoneyColors(
        income: dark ? const Color(0xFF34D399) : const Color(0xFF059669),
        expense: dark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
        transfer: dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        warning: dark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
        muted: dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
      ),
    ],
  );
}

/// Proportional digits: Persian digits look gapped when forced to equal width.
const tabular = <FontFeature>[FontFeature.proportionalFigures()];
