import 'package:flutter/material.dart';

/// House colour — night, gold, Byzantine purple, jade.
///
/// #050505 for night. Gold is ō. Purple is Purpose. Jade is Commit / Intention.
abstract final class OColors {
  static const night = Color(0xFF050505);
  static const field = Color(0xFF121014);
  static const ridge = Color(0xFF1C1824);
  static const byzantine = Color(0xFF7A3BA8);
  static const byzantineDeep = Color(0xFF4A1F6B);
  static const jade = Color(0xFF2F8B6D);
  static const jadeSoft = Color(0xFF3FA882);
  static const gold = Color(0xFFD4AF37);
  static const goldSoft = Color(0xFFE4C96A);
  static const paper = Color(0xFFF4EFE4);
  static const muted = Color(0xFF9A91A8);
  static const stub = Color(0xFFC47B3A);
}

ThemeData buildOTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: OColors.gold,
    onPrimary: OColors.night,
    secondary: OColors.jade,
    onSecondary: OColors.night,
    tertiary: OColors.byzantine,
    onTertiary: OColors.paper,
    error: Color(0xFFCF6679),
    onError: OColors.night,
    surface: OColors.field,
    onSurface: OColors.paper,
    surfaceContainerHighest: OColors.ridge,
    outline: Color(0xFF3D3450),
    outlineVariant: Color(0xFF2A2438),
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: OColors.night,
    fontFamily: 'sans-serif',
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: OColors.paper,
      displayColor: OColors.paper,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: OColors.paper,
      centerTitle: false,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: OColors.jade,
      foregroundColor: OColors.night,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: OColors.ridge,
      hintStyle: const TextStyle(color: OColors.muted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: OColors.gold, width: 1.2),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: OColors.ridge,
      contentTextStyle: const TextStyle(color: OColors.paper),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
