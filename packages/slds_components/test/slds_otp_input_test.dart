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

  testWidgets('renders `length` boxes, defaulting to 6', (tester) async {
    await pump(tester, const SldsOtpInput());
    expect(find.byType(TextField), findsNWidgets(6));
  });

  testWidgets('length can be overridden', (tester) async {
    await pump(tester, const SldsOtpInput(length: 4));
    expect(find.byType(TextField), findsNWidgets(4));
  });

  testWidgets('typing a digit advances focus to the next box', (tester) async {
    await pump(tester, const SldsOtpInput(length: 4));
    final fields = find.byType(TextField);

    await tester.enterText(fields.at(0), '7');
    await tester.pump();

    expect(tester.widget<TextField>(fields.at(1)).focusNode!.hasFocus, isTrue);
  });

  testWidgets('onChanged fires with the joined code as digits are entered', (
    tester,
  ) async {
    String? value;
    await pump(tester, SldsOtpInput(length: 4, onChanged: (v) => value = v));
    final fields = find.byType(TextField);

    await tester.enterText(fields.at(0), '1');
    await tester.pump();
    expect(value, '1');

    await tester.enterText(fields.at(1), '2');
    await tester.pump();
    expect(value, '12');
  });

  testWidgets('onCompleted fires once all boxes are filled', (tester) async {
    String? completed;
    await pump(
      tester,
      SldsOtpInput(length: 4, onCompleted: (v) => completed = v),
    );
    final fields = find.byType(TextField);

    for (var i = 0; i < 4; i++) {
      await tester.enterText(fields.at(i), '$i');
      await tester.pump();
    }

    expect(completed, '0123');
  });

  testWidgets('pasting the full code distributes across all boxes', (
    tester,
  ) async {
    String? value;
    await pump(tester, SldsOtpInput(length: 4, onChanged: (v) => value = v));

    await tester.enterText(find.byType(TextField).first, '1234');
    await tester.pump();

    expect(value, '1234');
  });

  testWidgets(
    'error state colors every box border red but keeps digits black',
    (tester) async {
      await pump(tester, const SldsOtpInput(length: 4, errorText: 'Error'));
      final theme = SldsTheme.light;

      for (final field in tester.widgetList<TextField>(
        find.byType(TextField),
      )) {
        final border = field.decoration!.enabledBorder! as OutlineInputBorder;
        expect(border.borderSide.color, theme.colorScheme.error);
        expect(field.style?.color, theme.colorScheme.onSurface);
      }
    },
  );

  testWidgets('size controls box dimensions, defaulting to large (56x80)', (
    tester,
  ) async {
    await pump(tester, const SldsOtpInput(length: 2));
    var box = tester.widget<SizedBox>(find.byType(SizedBox).first);
    expect(box.width, 56);
    expect(box.height, 80);

    await pump(
      tester,
      const SldsOtpInput(length: 2, size: SldsOtpInputSize.small),
    );
    box = tester.widget<SizedBox>(find.byType(SizedBox).first);
    expect(box.width, 44);
    expect(box.height, 52);
  });

  testWidgets('success state colors every box border green', (tester) async {
    await pump(tester, const SldsOtpInput(length: 4, success: true));

    for (final field in tester.widgetList<TextField>(find.byType(TextField))) {
      final border = field.decoration!.enabledBorder! as OutlineInputBorder;
      expect(border.borderSide.color, SldsColorTokens.light().success);
    }
  });

  testWidgets('focused empty box shows a gold border and cursor', (
    tester,
  ) async {
    await pump(tester, const SldsOtpInput(length: 4));
    final theme = SldsTheme.light;

    await tester.tap(find.byType(TextField).first);
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField).first);
    final border = field.decoration!.enabledBorder! as OutlineInputBorder;
    expect(border.borderSide.color, theme.colorScheme.primary);
    expect(field.cursorColor, theme.colorScheme.primary);
  });

  testWidgets('focus does not override error/success coloring', (tester) async {
    await pump(tester, const SldsOtpInput(length: 4, errorText: 'Error'));
    final theme = SldsTheme.light;

    await tester.tap(find.byType(TextField).first);
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField).first);
    final border = field.decoration!.enabledBorder! as OutlineInputBorder;
    expect(border.borderSide.color, theme.colorScheme.error);
  });

  testWidgets('disabled boxes cannot be edited', (tester) async {
    await pump(tester, const SldsOtpInput(length: 4, enabled: false));

    for (final field in tester.widgetList<TextField>(find.byType(TextField))) {
      expect(field.enabled, isFalse);
    }
  });

  testWidgets('every size renders its Figma box, radius and digit size', (
    tester,
  ) async {
    // Pinned against Figma node 515:803. The box grows across the size ramp
    // but the radius and the numeral do not — both were previously derived
    // from the box width, so neither matched at any size but large.
    const d = SldsDimensionTokens.standard;
    const expected = {
      SldsOtpInputSize.small: Size(44, 52),
      SldsOtpInputSize.medium: Size(48, 60),
      SldsOtpInputSize.large: Size(56, 80),
    };

    for (final entry in expected.entries) {
      await pump(tester, SldsOtpInput(length: 2, size: entry.key));

      final box = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(
        Size(box.width!, box.height!),
        entry.value,
        reason: '${entry.key} box',
      );

      final field = tester.widget<TextField>(find.byType(TextField).first);
      final border = field.decoration!.enabledBorder! as OutlineInputBorder;
      expect(
        border.borderRadius,
        BorderRadius.circular(d.radius2xl),
        reason: '${entry.key} radius',
      );
      expect(
        border.borderSide.width,
        d.controlBorderWidth,
        reason: '${entry.key} border width',
      );
      expect(
        field.style?.fontSize,
        SldsRawTypographyTokens.standard.heading1.fontSize,
        reason: '${entry.key} digit size',
      );
    }
  });

  testWidgets('colours resolve from SLDS tokens, not the Material scheme', (
    tester,
  ) async {
    // The success state used a literal Colors.green, which tracks no theme.
    // Every state must come from the palette so dark and high-contrast work.
    final light = SldsColorTokens.light();

    await pump(tester, const SldsOtpInput(length: 2));
    var field = tester.widget<TextField>(find.byType(TextField).first);
    var border = field.decoration!.enabledBorder! as OutlineInputBorder;
    expect(border.borderSide.color, light.inputBorderDefault);

    await pump(tester, const SldsOtpInput(length: 2, enabled: false));
    field = tester.widget<TextField>(find.byType(TextField).first);
    border = field.decoration!.enabledBorder! as OutlineInputBorder;
    expect(border.borderSide.color, light.disabledBorder);

  });

  testWidgets('the palette follows the ambient theme into dark mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SldsTheme.dark,
        localizationsDelegates: SldsLocalizations.localizationsDelegates,
        supportedLocales: SldsLocalizations.supportedLocales,
        home: const Scaffold(body: SldsOtpInput(length: 2, success: true)),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField).first);
    final border = field.decoration!.enabledBorder! as OutlineInputBorder;
    expect(border.borderSide.color, SldsColorTokens.dark().success);
  });
}
