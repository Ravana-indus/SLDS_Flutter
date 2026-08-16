import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';
import 'package:slds_tokens/slds_tokens.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field, {double width = 400}) =>
      tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: SldsLocalizations.localizationsDelegates,
          supportedLocales: SldsLocalizations.supportedLocales,
          theme: SldsTheme.light,
          home: Scaffold(
            body: SizedBox(width: width, child: field),
          ),
        ),
      );

  testWidgets('renders label, required marker, and country code', (
    tester,
  ) async {
    await pump(tester, const SldsMobileNumberInput(label: 'Mobile Number'));

    expect(find.textContaining('Mobile Number'), findsOneWidget);
    expect(find.text('*'), findsOneWidget);
    expect(find.text('+94'), findsOneWidget);
  });

  testWidgets('required=false hides the marker', (tester) async {
    await pump(
      tester,
      const SldsMobileNumberInput(label: 'Mobile Number', required: false),
    );
    expect(find.text('*'), findsNothing);
  });

  testWidgets('country code can be overridden', (tester) async {
    await pump(
      tester,
      const SldsMobileNumberInput(label: 'Mobile Number', countryCode: '+91'),
    );
    expect(find.text('+91'), findsOneWidget);
  });

  testWidgets(
    'shows helper text by default, error text when errorText is set',
    (tester) async {
      await pump(
        tester,
        const SldsMobileNumberInput(
          label: 'Mobile Number',
          helperText: 'Help Text',
        ),
      );
      expect(find.text('Help Text'), findsOneWidget);

      await pump(
        tester,
        const SldsMobileNumberInput(
          label: 'Mobile Number',
          helperText: 'Help Text',
          errorText: 'Bad number',
          visualState: SldsMobileNumberInputState.error,
        ),
      );
      expect(find.text('Bad number'), findsOneWidget);
      expect(find.text('Help Text'), findsNothing);
    },
  );

  testWidgets('typing invokes onChanged', (tester) async {
    String? value;
    await pump(
      tester,
      SldsMobileNumberInput(
        label: 'Mobile Number',
        onChanged: (v) => value = v,
      ),
    );

    await tester.enterText(find.byType(TextFormField), '771234567');
    expect(value, '771234567');
  });

  testWidgets('non-digit input is stripped by the default formatter', (
    tester,
  ) async {
    await pump(tester, const SldsMobileNumberInput(label: 'Mobile Number'));

    await tester.enterText(find.byType(TextFormField), '77a1b2c3');
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, '77123');
    expect(field.controller!.text.contains(RegExp('[a-z]')), isFalse);
  });

  testWidgets('enabled=false disables the field', (tester) async {
    await pump(
      tester,
      const SldsMobileNumberInput(label: 'Mobile Number', enabled: false),
    );
    final field = tester.widget<TextFormField>(find.byType(TextFormField));
    expect(field.enabled, isFalse);
  });

  testWidgets(
    'visualState=disabled disables the field even when enabled=true',
    (tester) async {
      await pump(
        tester,
        const SldsMobileNumberInput(
          label: 'Mobile Number',
          visualState: SldsMobileNumberInputState.disabled,
        ),
      );
      final field = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(field.enabled, isFalse);
    },
  );

  testWidgets(
    'gaining focus resolves to the focused visual state (gold border)',
    (tester) async {
      await pump(tester, const SldsMobileNumberInput(label: 'Mobile Number'));

      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = animatedContainer.decoration! as BoxDecoration;
      expect(
        (decoration.border! as Border).top.color,
        SldsColorTokens.light().inputBorderFocused,
      );
    },
  );

  testWidgets('field geometry matches the Figma spec in every state', (
    tester,
  ) async {
    // Pinned against Figma node 510:3072: a 52px box with a 12px radius and
    // a plain 1px border whose colour — never its width — carries the state.
    const d = SldsDimensionTokens.standard;

    for (final state in SldsMobileNumberInputState.values) {
      await pump(
        tester,
        SldsMobileNumberInput(
          label: 'Mobile Number',
          errorText: state == SldsMobileNumberInputState.error ? 'Bad' : null,
          visualState: state,
        ),
      );

      final box = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = box.decoration! as BoxDecoration;

      expect(
        tester.getSize(find.byType(AnimatedContainer)).height,
        d.inputHeight,
        reason: '$state height',
      );
      expect(
        decoration.borderRadius,
        BorderRadius.circular(d.radius2xl),
        reason: '$state radius',
      );
      expect(
        (decoration.border! as Border).top.width,
        d.controlBorderWidth,
        reason: '$state border width',
      );
    }
  });

  testWidgets('the label is set in Body 2', (tester) async {
    // Figma labels the field in Body 2 (14px), not the 16px fieldLabel token.
    await pump(tester, const SldsMobileNumberInput(label: 'Mobile Number'));

    final label = tester.widget<Text>(find.text('Mobile Number'));
    expect(
      label.style?.fontSize,
      SldsRawTypographyTokens.standard.body2.fontSize,
    );
  });

  testWidgets('countryFlag widget renders inside the prefix', (tester) async {
    await pump(
      tester,
      const SldsMobileNumberInput(
        label: 'Mobile Number',
        countryFlag: Text('🇱🇰'),
      ),
    );
    expect(find.text('🇱🇰'), findsOneWidget);
  });

  testWidgets('onCountryPressed makes the prefix tappable', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsMobileNumberInput(
        label: 'Mobile Number',
        onCountryPressed: () => tapped = true,
      ),
    );

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    expect(tapped, isTrue);
  });

  testWidgets('trailing widget renders in its own slot', (tester) async {
    await pump(
      tester,
      const SldsMobileNumberInput(
        label: 'Mobile Number',
        trailing: Icon(Icons.close),
      ),
    );
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('width clamps to the available parent width', (tester) async {
    await pump(
      tester,
      const SldsMobileNumberInput(label: 'Mobile Number', width: 1000),
      width: 300,
    );

    final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
    final matched = sizedBoxes.where((b) => b.width == 300);
    expect(matched, isNotEmpty);
  });
}
