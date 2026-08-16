import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';
import 'package:slds_tokens/slds_tokens.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: field),
    ),
  );

  testWidgets('starts obscured, showing the hidden-state icon', (tester) async {
    await pump(tester, const SldsPasswordField());

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);
    // Figma pairs Show Password=False with EyeSlash: the glyph depicts the
    // field's current state, while the tooltip names the action.
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });

  testWidgets('tapping the eye icon reveals the password', (tester) async {
    await pump(tester, const SldsPasswordField());

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isFalse);
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('tapping again re-obscures the password', (tester) async {
    await pump(tester, const SldsPasswordField());

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);
  });

  testWidgets('disabled field cannot toggle visibility', (tester) async {
    await pump(tester, const SldsPasswordField(enabled: false));

    final iconButton = tester.widget<IconButton>(find.byType(IconButton));
    expect(iconButton.onPressed, isNull);
  });

  testWidgets('error text shows and typing invokes onChanged', (tester) async {
    String? value;
    await pump(
      tester,
      SldsPasswordField(errorText: 'Error Text', onChanged: (v) => value = v),
    );

    expect(find.text('Error Text'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'DGH347847#');
    expect(value, 'DGH347847#');
  });

  testWidgets('the value keeps its Body 1 size in both states', (
    tester,
  ) async {
    // Figma sets the value in Body 1 whether obscured or not, so revealing a
    // password must not reflow the field.
    const expected = SldsRawTypographyTokens.standard;
    await pump(tester, const SldsPasswordField());

    double? sizeNow() =>
        tester.widget<TextField>(find.byType(TextField)).style?.fontSize;

    expect(sizeNow(), expected.body1.fontSize);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    expect(sizeNow(), expected.body1.fontSize);
  });

  testWidgets('the toggle is named, and the name tracks the action', (
    tester,
  ) async {
    // The toggle is icon-only, so the tooltip is its accessible name. It
    // names what tapping does, which is the inverse of the glyph.
    await pump(tester, const SldsPasswordField());

    IconButton toggle() =>
        tester.widget<IconButton>(find.byType(IconButton));

    expect(toggle().tooltip, isNotNull);
    final whenHidden = toggle().tooltip;

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    expect(toggle().tooltip, isNotNull);
    expect(toggle().tooltip, isNot(whenHidden));
  });
}
