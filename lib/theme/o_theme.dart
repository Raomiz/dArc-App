import 'package:flutter/material.dart';

/// Dennis-locked ō tokens. Joshua does not pick fonts or colours.
///
/// Day 2 field is a living wash — jade → baby blue → near-white air.
/// Purpose, Intention, and Commit stay as accents on that air.
/// Not obsidian vault. Not grey dark-mode chrome. Not `#050505`.
abstract final class OColors {
  /// Living wash — jade `#2f6f5e`.
  static const Color fieldJade = Color(0xFF2F6F5E);

  /// Living wash — soft baby blue `#A8D4E8`.
  static const Color fieldBlue = Color(0xFFA8D4E8);

  /// Living wash — near-white air `#F7FBFD`.
  static const Color fieldAir = Color(0xFFF7FBFD);

  /// Scaffold / field end. Air, not a vault.
  static const Color ground = fieldAir;

  /// Light airy cards on the field.
  static const Color surface = Color(0xFFFFFFFF);

  /// Soft blue-white ridges, chips, fields.
  static const Color ridge = Color(0xFFE4F2F7);

  /// Deep ink on air — not grey dark-mode chrome.
  static const Color ink = Color(0xFF241428);

  /// Secondary text on the field.
  static const Color muted = Color(0xFF5A6B74);

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

  /// Light cream on purple / jade accents.
  static const Color paper = Color(0xFFF7FBFD);

  static const Color stub = Color(0xFFC47B3A);
  static const Color outline = Color(0xFFB7D3DF);

  // Stable aliases — same locks, older call sites.
  static const Color night = fieldAir;
  static const Color field = fieldAir;
  static const Color byzantine = purpose;
  static const Color byzantineDeep = purposeDeep;
  static const Color jade = intention;
  static const Color jadeSoft = intentionLit;
  static const Color gold = commit;
  static const Color goldSoft = commitSoft;
}

/// Type: Inter as the UI sans — real strings, never Ahem blocks in proofs.
/// Purpose title 22–24sp; Intention 16–17sp; body mist; Commit tracked medium.
abstract final class OType {
  static const String uiSans = 'Inter';

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

  /// Purpose title — ~23sp Byzantine-weight.
  static const TextStyle purposeTitle = TextStyle(
    fontFamily: uiSans,
    fontSize: 23,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.18,
    color: OColors.purposeDeep,
  );

  /// Intention title — ~16.5sp on the stage.
  static const TextStyle intentionTitle = TextStyle(
    fontFamily: uiSans,
    fontSize: 16.5,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: OColors.ink,
  );

  /// Body mist — secondary copy on the field.
  static const TextStyle bodyMist = TextStyle(
    fontFamily: uiSans,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: OColors.muted,
  );

  /// Commit label — tracked medium on gold. Not a shouty caption.
  static const TextStyle commit = TextStyle(
    fontFamily: uiSans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    height: 1.1,
    color: OColors.ink,
  );

  /// Soft Byzantine bloom on the expanded Purpose stage.
  static const Color purposeBloom = Color.fromRGBO(112, 41, 99, 0.22);

  static const Duration stageSettle = Duration(milliseconds: 480);
  static const Duration commitPress = Duration(milliseconds: 100);
  static const double stageSettleFrom = 1.04;
  static const double commitPressScale = 0.97;
  static const double satelliteBlur = 8;
}

ThemeData buildOTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: OColors.commit,
    onPrimary: OColors.ink,
    secondary: OColors.intention,
    onSecondary: OColors.paper,
    tertiary: OColors.purpose,
    onTertiary: OColors.paper,
    error: Color(0xFFCF6679),
    onError: OColors.paper,
    surface: OColors.surface,
    onSurface: OColors.ink,
    surfaceContainerHighest: OColors.ridge,
    outline: OColors.outline,
    outlineVariant: OColors.fieldBlue,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: scheme,
    scaffoldBackgroundColor: OColors.fieldAir,
    fontFamily: OType.uiSans,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: OColors.ink,
      displayColor: OColors.ink,
      fontFamily: OType.uiSans,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: OColors.ink,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: OType.uiSans,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: OColors.ink,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: OColors.commit,
      foregroundColor: OColors.purposeDeep,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      disabledElevation: 0,
      shape: StadiumBorder(),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: OColors.surface.withValues(alpha: 0.86),
      hintStyle: const TextStyle(color: OColors.muted),
      labelStyle: const TextStyle(color: OColors.muted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: OColors.commit, width: 1.2),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: OColors.ridge,
      disabledColor: OColors.ridge,
      selectedColor: OColors.fieldBlue,
      secondarySelectedColor: OColors.fieldBlue,
      labelStyle: const TextStyle(color: OColors.ink, fontFamily: OType.uiSans),
      secondaryLabelStyle: const TextStyle(
        color: OColors.ink,
        fontFamily: OType.uiSans,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: OColors.surface,
      contentTextStyle: const TextStyle(color: OColors.ink),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
