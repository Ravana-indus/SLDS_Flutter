import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget fab) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light,
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      home: Scaffold(body: fab),
    ),
  );

  testWidgets('primary and destructive variants render filled', (tester) async {
    await pump(tester, SldsFab(icon: Icons.add, onPressed: () {}));
    final primary = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(primary.backgroundColor, isNot(Colors.transparent));

    await pump(
      tester,
      SldsFab(
        icon: Icons.delete,
        variant: SldsButtonVariant.destructive,
        onPressed: () {},
      ),
    );
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('secondary variant renders outlined on surface', (tester) async {
    await pump(
      tester,
      SldsFab(
        icon: Icons.add,
        variant: SldsButtonVariant.secondary,
        onPressed: () {},
      ),
    );
    final fab = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(fab.backgroundColor, SldsTheme.light.colorScheme.surface);
  });

  testWidgets('badgeCount shows a numeric badge', (tester) async {
    await pump(
      tester,
      SldsFab(icon: Icons.add, badgeCount: 3, onPressed: () {}),
    );
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('loading state shows a spinner and blocks taps', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsFab(icon: Icons.add, isLoading: true, onPressed: () => tapped = true),
    );

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton), warnIfMissed: false);
    expect(tapped, isFalse);
  });

  testWidgets('null onPressed disables the button', (tester) async {
    await pump(tester, const SldsFab(icon: Icons.add, onPressed: null));
    final fab = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(fab.onPressed, isNull);
  });

  testWidgets('hover and press use the Figma tokens, with no ripple', (
    tester,
  ) async {
    final colors = SldsColorTokens.light();
    final expected = {
      SldsButtonVariant.primary: (
        colors.buttonPrimaryHover,
        colors.buttonPrimaryPressed,
      ),
      SldsButtonVariant.secondary: (
        colors.buttonSecondaryHover,
        colors.buttonSecondaryPressed,
      ),
      SldsButtonVariant.destructive: (
        colors.buttonDestructiveHover,
        colors.buttonDestructivePressed,
      ),
    };
    for (final MapEntry(key: variant, value: (hover, pressed))
        in expected.entries) {
      await pump(
        tester,
        SldsFab(icon: Icons.add, variant: variant, onPressed: () {}),
      );
      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.hoverColor, hover, reason: '$variant hover');
      expect(fab.splashColor, Colors.transparent, reason: '$variant ripple');
      expect(fab.hoverElevation, fab.elevation, reason: '$variant lift');
      expect(fab.highlightElevation, fab.elevation, reason: '$variant lift');
      expect(
        Theme.of(
          tester.element(find.byType(FloatingActionButton)),
        ).highlightColor,
        pressed,
        reason: '$variant pressed',
      );
    }
  });

  // Figma FAB State=Loading (light 248:1851, dark 248:8456): the variant's
  // fill stays, and the spinner takes the variant's foreground (#222, #223).
  testWidgets('loading keeps each variant colours (#222, #223)', (
    tester,
  ) async {
    for (final (theme, variant, fill, mark) in [
      (SldsTheme.light, SldsButtonVariant.primary, 0xFFFFC700, 0xFF17171A),
      (SldsTheme.light, SldsButtonVariant.secondary, 0xFFFFFFFF, 0xFF17171A),
      (SldsTheme.light, SldsButtonVariant.destructive, 0xFFD32F2F, 0xFFFFFFFF),
      (SldsTheme.dark, SldsButtonVariant.primary, 0xFFFFC700, 0xFF17171A),
      (SldsTheme.dark, SldsButtonVariant.secondary, 0xFF444444, 0xFFFFFFFF),
      (SldsTheme.dark, SldsButtonVariant.destructive, 0xFFD32F2F, 0xFFFFFFFF),
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          localizationsDelegates: SldsLocalizations.localizationsDelegates,
          supportedLocales: SldsLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: SldsFab(
                icon: Icons.add,
                variant: variant,
                isLoading: true,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.backgroundColor, Color(fill), reason: '$theme $variant');
      expect(
        tester
            .widget<CupertinoActivityIndicator>(
              find.byType(CupertinoActivityIndicator),
            )
            .color,
        Color(mark),
        reason: '$theme $variant',
      );
    }
  });
}
