import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: field),
    ),
  );

  testWidgets('renders label, required marker, and hint', (tester) async {
    await pump(
      tester,
      const SldsTextField(
        label: 'Email',
        isRequired: true,
        hintText: 'info@example.com',
      ),
    );

    expect(find.textContaining('Email'), findsOneWidget);
    expect(find.textContaining('*'), findsOneWidget);
    expect(find.text('info@example.com'), findsOneWidget);
  });

  testWidgets('shows help text when there is no error', (tester) async {
    await pump(
      tester,
      const SldsTextField(label: 'Email', helpText: 'Help Text'),
    );
    expect(find.text('Help Text'), findsOneWidget);
  });

  testWidgets('error text replaces help text and colors the border red', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsTextField(
        label: 'Email',
        helpText: 'Help Text',
        errorText: 'Error Text',
      ),
    );

    expect(find.text('Error Text'), findsOneWidget);
    expect(find.text('Help Text'), findsNothing);

    final field = tester.widget<TextField>(find.byType(TextField));
    final border = field.decoration!.enabledBorder! as OutlineInputBorder;
    expect(border.borderSide.color, SldsColorTokens.light().inputBorderError);
  });

  testWidgets('disabled field is not enabled', (tester) async {
    await pump(tester, const SldsTextField(label: 'Email', enabled: false));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.enabled, isFalse);
  });

  testWidgets('typing invokes onChanged', (tester) async {
    String? value;
    await pump(
      tester,
      SldsTextField(label: 'Email', onChanged: (v) => value = v),
    );

    await tester.enterText(find.byType(TextFormField), 'hello@slds.lk');
    expect(value, 'hello@slds.lk');
  });

  testWidgets('leading/trailing icons render when provided', (tester) async {
    await pump(
      tester,
      const SldsTextField(
        label: 'Email',
        leadingIcon: Icons.star_border,
        trailingIcon: Icons.info_outline,
      ),
    );

    expect(find.byIcon(Icons.star_border), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
  });

  testWidgets('info button renders and fires alongside the trailing icon', (
    tester,
  ) async {
    var pressed = false;
    await pump(
      tester,
      SldsTextField(
        label: 'Email',
        trailingIcon: Icons.star_border,
        trailingIconTooltip: 'Favourite',
        infoIcon: Icons.info,
        infoTooltip: 'About this field',
        onInfoPressed: () => pressed = true,
      ),
    );

    expect(find.byIcon(Icons.star_border), findsOneWidget);
    expect(find.byIcon(Icons.info), findsOneWidget);

    await tester.tap(find.byIcon(Icons.info));
    expect(pressed, isTrue);
  });

  group('focus', () {
    testWidgets('focusing thickens the border and widens the padding', (
      tester,
    ) async {
      await pump(tester, const SldsTextField(label: 'Email'));

      const dimensions = SldsDimensionTokens.standard;

      InputDecoration decoration() =>
          tester.widget<TextField>(find.byType(TextField)).decoration!;

      expect(
        (decoration().enabledBorder! as OutlineInputBorder).borderSide.width,
        dimensions.controlBorderWidth,
      );
      expect(
        decoration().contentPadding,
        EdgeInsetsDirectional.symmetric(
          horizontal: dimensions.space8,
          vertical: dimensions.space8,
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Only the focused stroke is emphasized — the resting one is unchanged.
      expect(
        (decoration().focusedBorder! as OutlineInputBorder).borderSide.width,
        dimensions.emphasizedBorderWidth,
      );
      expect(
        decoration().contentPadding,
        EdgeInsetsDirectional.symmetric(
          horizontal: dimensions.space12,
          vertical: dimensions.space8,
        ),
      );
    });

    testWidgets('an externally supplied focus node still drives the state', (
      tester,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);

      await pump(tester, SldsTextField(label: 'Email', focusNode: node));

      node.requestFocus();
      await tester.pumpAndSettle();

      final decoration = tester
          .widget<TextField>(find.byType(TextField))
          .decoration!;
      expect(
        decoration.contentPadding,
        EdgeInsetsDirectional.symmetric(
          horizontal: SldsDimensionTokens.standard.space12,
          vertical: SldsDimensionTokens.standard.space8,
        ),
      );
    });
  });

  group('compact', () {
    testWidgets('uses the shorter height and smaller radius', (tester) async {
      await pump(tester, const SldsTextField(label: 'Email', compact: true));

      const dimensions = SldsDimensionTokens.standard;
      final decoration = tester
          .widget<TextField>(find.byType(TextField))
          .decoration!;

      expect(
        decoration.constraints!.minHeight,
        dimensions.inputHeightCompact,
      );
      expect(
        (decoration.enabledBorder! as OutlineInputBorder).borderRadius,
        BorderRadius.circular(dimensions.radiusLg),
      );
    });

    testWidgets('sets both label and value in Caption 1', (tester) async {
      await pump(
        tester,
        const SldsTextField(
          label: 'Email',
          hintText: 'info@example.com',
          compact: true,
        ),
      );

      const typography = SldsTypographyTokens.standard;
      final field = tester.widget<TextField>(find.byType(TextField));

      expect(field.style!.fontSize, typography.caption1.fontSize);
      expect(
        field.decoration!.hintStyle!.fontSize,
        typography.caption1.fontSize,
      );

      final label = tester.widget<Text>(find.textContaining('Email'));
      expect(label.textSpan!.style!.fontSize, typography.caption1.fontSize);
    });

    testWidgets('standard density keeps Body 2 label and Body 1 value', (
      tester,
    ) async {
      await pump(
        tester,
        const SldsTextField(label: 'Email', hintText: 'info@example.com'),
      );

      const typography = SldsTypographyTokens.standard;
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.style!.fontSize, typography.body1.fontSize);

      final label = tester.widget<Text>(find.textContaining('Email'));
      expect(label.textSpan!.style!.fontSize, typography.body2.fontSize);
    });
  });

  testWidgets('disabled keeps the input background rather than darkening it', (
    tester,
  ) async {
    await pump(tester, const SldsTextField(label: 'Email', enabled: false));

    final decoration = tester
        .widget<TextField>(find.byType(TextField))
        .decoration!;
    expect(decoration.fillColor, SldsColorTokens.light().surfaceCard);
  });
}
