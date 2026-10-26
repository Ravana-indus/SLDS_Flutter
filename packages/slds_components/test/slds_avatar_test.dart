import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: child),
    ),
  );

  testWidgets('renders initials when given', (tester) async {
    await pump(tester, const SldsAvatar(initials: 'LK'));
    expect(find.text('LK'), findsOneWidget);
  });

  testWidgets('truncates initials to 2 characters', (tester) async {
    await pump(tester, const SldsAvatar(initials: 'ABCD'));
    expect(find.text('AB'), findsOneWidget);
  });

  testWidgets('falls back to the person icon when initials is null', (
    tester,
  ) async {
    await pump(tester, const SldsAvatar());
    // Figma's User glyph, painted rather than a Material icon (#201).
    expect(
      find.descendant(
        of: find.byType(SldsAvatar),
        matching: find.byType(CustomPaint),
      ),
      findsWidgets,
    );
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets('falls back to the person icon when initials is empty', (
    tester,
  ) async {
    await pump(tester, const SldsAvatar(initials: ''));
    // Figma's User glyph, painted rather than a Material icon (#201).
    expect(
      find.descendant(
        of: find.byType(SldsAvatar),
        matching: find.byType(CustomPaint),
      ),
      findsWidgets,
    );
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets('each size renders at its token diameter', (tester) async {
    const expected = {
      SldsAvatarSize.small: 24.0,
      SldsAvatarSize.medium: 32.0,
      SldsAvatarSize.large: 40.0,
      SldsAvatarSize.extraLarge: 48.0,
      SldsAvatarSize.huge: 56.0,
    };

    for (final entry in expected.entries) {
      await pump(tester, SldsAvatar(initials: 'LK', size: entry.key));
      expect(tester.getSize(find.byType(SldsAvatar)), Size.square(entry.value));
    }
  });

  // Figma Avatar (502:3768): initials #17171A, per-size type (#202); the
  // User glyph sized per Figma (#201).
  testWidgets('initials and glyph match Figma at every size (#201, #202)', (
    tester,
  ) async {
    const type = {
      SldsAvatarSize.small: (12.0, FontWeight.w400, 14.0, 16.0),
      SldsAvatarSize.medium: (16.0, FontWeight.w400, 24.0, 20.0),
      SldsAvatarSize.large: (18.0, FontWeight.w500, 24.0, 24.0),
      SldsAvatarSize.extraLarge: (24.0, FontWeight.w500, 30.0, 24.0),
      SldsAvatarSize.huge: (22.0, FontWeight.w700, 28.0, 28.0),
    };
    for (final MapEntry(key: size, value: (font, weight, line, glyph))
        in type.entries) {
      await pump(tester, SldsAvatar(initials: 'LK', size: size));
      final style = tester.widget<Text>(find.text('LK')).style!;
      expect(style.fontSize, font, reason: '$size');
      expect(style.fontWeight, weight, reason: '$size');
      expect(style.fontSize! * style.height!, closeTo(line, 0.01));
      expect(style.color, const Color(0xFF17171A), reason: '$size');

      await pump(tester, SldsAvatar(size: size));
      final paint = find.descendant(
        of: find.byType(SldsAvatar),
        matching: find.byType(CustomPaint),
      );
      expect(tester.getSize(paint.last), Size(glyph, glyph), reason: '$size');
    }
  });
}
