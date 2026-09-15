import 'package:darc_o/theme/o_theme.dart';
import 'package:darc_o/widgets/commit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Dennis-locked field and accent tokens are exact hex', () {
    expect(OColors.fieldJade, const Color(0xFF2F6F5E));
    expect(OColors.fieldBlue, const Color(0xFFA8D4E8));
    expect(OColors.fieldAir, const Color(0xFFF7FBFD));
    expect(OColors.ground, OColors.fieldAir);
    expect(OColors.surface, const Color(0xFFFFFFFF));

    expect(OColors.purpose, const Color(0xFF702963));
    expect(OColors.purposeDeep, const Color(0xFF3A1540));
    expect(OColors.intention, const Color(0xFF2F6F5E));
    expect(OColors.intentionLit, const Color(0xFF7DBA9A));
    expect(OColors.commit, const Color(0xFFC9A227));
    expect(OColors.commitSoft, const Color(0xFFE6D08A));

    expect(OColors.night, OColors.fieldAir);
    expect(OColors.field, OColors.fieldAir);
    expect(OColors.byzantine, OColors.purpose);
    expect(OColors.jade, OColors.intention);
    expect(OColors.gold, OColors.commit);

    expect(OColors.fieldAir, isNot(const Color(0xFF0C0712)));
    expect(OColors.fieldAir, isNot(const Color(0xFF050505)));
    expect(OColors.fieldAir, isNot(const Color(0xFF121212)));
    expect(OColors.surface, isNot(const Color(0xFF160B1E)));
  });

  test('theme seats living field and token roles', () {
    final theme = buildOTheme();
    expect(theme.brightness, Brightness.light);
    expect(theme.scaffoldBackgroundColor, OColors.fieldAir);
    expect(theme.colorScheme.primary, OColors.commit);
    expect(theme.colorScheme.secondary, OColors.intention);
    expect(theme.colorScheme.tertiary, OColors.purpose);
    expect(theme.colorScheme.surface, OColors.surface);
    expect(theme.colorScheme.onSurface, OColors.ink);
    expect(theme.textTheme.bodyMedium?.fontFamily, OType.uiSans);
  });

  test('whisper labels are tracked; Commit type is high contrast ink on gold', () {
    expect(OType.whisper.letterSpacing, greaterThan(2));
    expect(OType.whisper.fontFamily, OType.uiSans);
    expect(OType.commit.color, OColors.ink);
    expect(OType.commit.fontWeight, FontWeight.w800);
    expect(OType.commit.fontSize, greaterThan(OType.whisper.fontSize!));
  });

  testWidgets('Commit button is gold threshold, not a bland submit', (tester) async {
    var pressed = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildOTheme(),
        home: Scaffold(
          backgroundColor: OColors.fieldAir,
          body: CommitButton(
            label: 'Commit this intention',
            onPressed: () => pressed++,
          ),
        ),
      ),
    );

    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(CommitButton),
        matching: find.byType(Material),
      ),
    );
    expect(material.color, OColors.commit);
    expect(find.text('Commit this intention'), findsOneWidget);

    await tester.tap(find.text('Commit this intention'));
    await tester.pumpAndSettle();
    expect(pressed, 1);
  });
}
