import 'package:flutter/material.dart';

/// Dennis-locked ō tokens. Joshua does not pick fonts or colours.
///
/// Ground is an obsidian vault (`#0c0712`), not flat dark-mode grey
/// and not the retired `#050505` night.
abstract final class OColors {
  /// Obsidian vault ground — `#0c0712`.
  static const Color ground = Color(0xFF0C0712);

  /// Surfaces step up from the vault — `#160b1e`.
  static const Color surface = Color(0xFF160B1E);

  /// One more vault step for chips, fields, ridges.
  static const Color ridge = Color(0xFF221433);

  /// Purpose — Byzantine `#702963`.
  static const Color purpose = Color(0xFF702963);

  /// Purpose deep — `#3a1540`.
  static const Color purposeDeep = Color(0xFF3A1540);

  /// Intention — jade `#2f6f5e`.
  static const Color intention = Color(0xFF2F6F5E);

  /// Intention lit — `#7dba9a`.
  static const Color intentionLit = Color(0xFF7DBA9A);

  /// Commit gold threshold — `#c9a227`.
  static const Color commit = Color(0xFFC9A227);

  /// Commit soft — `#e6d08a`.
  static const Color commitSoft = Color(0xFFE6D08A);

  static const Color paper = Color(0xFFF4EFE4);
  static const Color muted = Color(0xFFA898B0);
  static const Color stub = Color(0xFFC47B3A);
  static const Color outline = Color(0xFF3A2450);

  // Stable aliases — same locks, older call sites.
  static const Color night = ground;
  static const Color field = surface;
  static const Color byzantine = purpose;
  static const Color byzantineDeep = purposeDeep;
  static const Color jade = intention;
  static const Color jadeSoft = intentionLit;
  static const Color gold = commit;
  static const Color goldSoft = commitSoft;
}

/// Type: system UI sans for dense chrome; whisper tracked labels;
/// big contrast on Commit.
abstract final class OType {
  static const String uiSans = 'sans-serif';

  static const TextStyle chrome = TextStyle(
    fontFamily: uiSans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.05,
    height: 1.35,
  );

  /// Whisper tracked labels (PURPOSE, INTENTION, session chrome).
  static const TextStyle whisper = TextStyle(
    fontFamily: uiSans,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.4,
    height: 1.2,
  );

  /// Dark vault ink on Commit gold — crossing a threshold, not a caption.
  static const TextStyle commit = TextStyle(
    fontFamily: uiSans,
    fontSize: 17,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.7,
    height: 1.1,
    color: OColors.ground,
  );
}

ThemeData buildOTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: OColors.commit,
    onPrimary: OColors.ground,
    secondary: OColors.intention,
    onSecondary: OColors.ground,
    tertiary: OColors.purpose,
    onTertiary: OColors.paper,
    error: Color(0xFFCF6679),
    onError: OColors.ground,
    surface: OColors.surface,
    onSurface: OColors.paper,
    surfaceContainerHighest: OColors.ridge,
    outline: OColors.outline,
    outlineVariant: OColors.purposeDeep,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: OColors.ground,
    fontFamily: OType.uiSans,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: OColors.paper,
      displayColor: OColors.paper,
      fontFamily: OType.uiSans,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: OColors.paper,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: OType.uiSans,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: OColors.paper,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: OColors.purpose,
      foregroundColor: OColors.paper,
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
        borderSide: const BorderSide(color: OColors.commit, width: 1.2),
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
