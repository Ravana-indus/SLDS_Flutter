import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
      home: Scaffold(body: field),
    ),
  );

  testWidgets('shows the Sri Lanka flag SVG and +94 by default', (
    tester,
  ) async {
    await pump(tester, const SldsPhoneField());
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.text('+94'), findsOneWidget);
  });

  testWidgets('country code can be overridden', (tester) async {
    await pump(tester, const SldsPhoneField(countryCode: '+91'));
    expect(find.text('+91'), findsOneWidget);
  });

  testWidgets('emoji fallback is used when countryFlagAsset is null', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsPhoneField(
        countryFlag: '🇮🇳',
        countryFlagAsset: null,
        countryCode: '+91',
      ),
    );
    expect(find.text('🇮🇳'), findsOneWidget);
    expect(find.byType(SvgPicture), findsNothing);
  });

  testWidgets('typed digits group as 2-3-4 while non-digits are stripped', (
    tester,
  ) async {
    await pump(tester, const SldsPhoneField());

    await tester.enterText(find.byType(TextField), 'abc771234567xyz');
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, '77 123 4567');
  });

  testWidgets('input is capped at 9 digits', (tester) async {
    await pump(tester, const SldsPhoneField());

    await tester.enterText(find.byType(TextField), '771234567890');
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, '77 123 4567');
  });

  testWidgets('clear button appears once text is entered and clears it', (
    tester,
  ) async {
    await pump(tester, const SldsPhoneField());
    expect(find.byIcon(Icons.close), findsNothing);

    await tester.enterText(find.byType(TextField), '771234567');
    await tester.pump();
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(find.byIcon(Icons.close), findsNothing);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, isEmpty);
  });

  testWidgets('showValid replaces the clear button with a green checkmark', (
    tester,
  ) async {
    await pump(tester, const SldsPhoneField(showValid: true));
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('error text renders', (tester) async {
    await pump(tester, const SldsPhoneField(errorText: 'Error Text'));
    expect(find.text('Error Text'), findsOneWidget);
  });

  testWidgets('error state colors the dial code and chevron red', (
    tester,
  ) async {
    await pump(tester, const SldsPhoneField(errorText: 'Error Text'));

    final theme = SldsTheme.light();
    final codeText = tester.widget<Text>(find.text('+94'));
    expect(codeText.style?.color, theme.colorScheme.error);

    final chevron = tester.widget<Icon>(find.byIcon(Icons.keyboard_arrow_down));
    expect(chevron.color, theme.colorScheme.error);
  });

  testWidgets('disabled state dims the dial code and chevron', (tester) async {
    await pump(tester, const SldsPhoneField(enabled: false));

    final theme = SldsTheme.light();
    final expected = theme.colorScheme.onSurface.withValues(
      alpha: SldsColors.disabledOpacity,
    );
    final codeText = tester.widget<Text>(find.text('+94'));
    expect(codeText.style?.color, expected);
  });

  testWidgets('shows no divider between the prefix and the number', (
    tester,
  ) async {
    await pump(tester, const SldsPhoneField());
    final divider = find.byWidgetPredicate(
      (w) => w is Container && w.constraints?.maxWidth == 1,
    );
    expect(divider, findsNothing);
  });

  testWidgets('shows a decorative chevron after the dial code', (tester) async {
    await pump(tester, const SldsPhoneField());
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
  });

  testWidgets('falls back to the emoji when the flag asset fails to load', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsPhoneField(countryFlagAsset: 'assets/flags/does_not_exist.png'),
    );
    await tester.pump(); // let the failed image resolve its error callback
    expect(find.text('🇱🇰'), findsOneWidget);
  });

  testWidgets('a raster asset renders via Image, not SvgPicture', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsPhoneField(
        countryFlag: '🇮🇳',
        countryFlagAsset: 'assets/flags/does_not_exist.png',
        countryFlagAssetIsPackaged:
            false, // app-owned asset, not this package's
      ),
    );
    expect(find.byType(SvgPicture), findsNothing);
    expect(find.byType(Image), findsOneWidget);
  });
}
