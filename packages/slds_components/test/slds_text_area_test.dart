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

  testWidgets('renders label, required marker, hint, and 0/max counter', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsTextArea(
        label: 'Description',
        isRequired: true,
        hintText: 'Description placeholder',
      ),
    );

    expect(find.textContaining('Description'), findsWidgets);
    expect(find.textContaining('*'), findsOneWidget);
    expect(find.text('Description placeholder'), findsOneWidget);
    expect(find.text('0/300'), findsOneWidget);
  });

  testWidgets('counter updates as the user types', (tester) async {
    await pump(tester, const SldsTextArea(label: 'Description'));

    await tester.enterText(find.byType(TextFormField), 'Hello');
    await tester.pump();

    expect(find.text('5/300'), findsOneWidget);
  });

  testWidgets('input is capped at maxLength', (tester) async {
    await pump(tester, const SldsTextArea(label: 'Description', maxLength: 5));

    await tester.enterText(find.byType(TextFormField), 'abcdefgh');
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, 'abcde');
    expect(find.text('5/5'), findsOneWidget);
  });

  testWidgets('counter is hidden when maxLength is null', (tester) async {
    await pump(
      tester,
      const SldsTextArea(label: 'Description', maxLength: null),
    );
    expect(find.textContaining('/'), findsNothing);
  });

  testWidgets('shows help text when there is no error', (tester) async {
    await pump(
      tester,
      const SldsTextArea(label: 'Description', helpText: 'Help Text'),
    );
    expect(find.text('Help Text'), findsOneWidget);
  });

  testWidgets('error text replaces help text and colors the border red', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsTextArea(
        label: 'Description',
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
    await pump(
      tester,
      const SldsTextArea(label: 'Description', enabled: false),
    );
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.enabled, isFalse);
  });

  testWidgets('typing invokes onChanged', (tester) async {
    String? value;
    await pump(
      tester,
      SldsTextArea(label: 'Description', onChanged: (v) => value = v),
    );

    await tester.enterText(find.byType(TextFormField), 'hello world');
    expect(value, 'hello world');
  });

  testWidgets('accepts multiple lines of input', (tester) async {
    await pump(tester, const SldsTextArea(label: 'Description'));
    final field = tester.widget<TextField>(find.byType(TextField));
    // Null means unbounded in Flutter: the box grows with the content
    // rather than capping at a line count the spec never states.
    expect(field.maxLines, isNull);

    await tester.enterText(find.byType(TextFormField), 'one\ntwo\nthree');
    await tester.pump();
    expect(find.text('one\ntwo\nthree'), findsOneWidget);
  });

  testWidgets('maxLines caps growth when the caller sets it', (tester) async {
    await pump(
      tester,
      const SldsTextArea(label: 'Description', maxLines: 4),
    );
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.maxLines, 4);
  });

  group('Figma fidelity', () {
    testWidgets('borders resolve from input tokens, not the Material scheme', (
      tester,
    ) async {
      final light = SldsColorTokens.light();

      OutlineInputBorder borderOf(WidgetTester t) =>
          t.widget<TextField>(find.byType(TextField)).decoration!.enabledBorder!
              as OutlineInputBorder;

      await pump(tester, const SldsTextArea(label: 'Description'));
      expect(borderOf(tester).borderSide.color, light.inputBorderDefault);

      await pump(
        tester,
        const SldsTextArea(label: 'Description', errorText: 'Error Text'),
      );
      expect(borderOf(tester).borderSide.color, light.inputBorderError);

      await pump(
        tester,
        const SldsTextArea(label: 'Description', enabled: false),
      );
      expect(borderOf(tester).borderSide.color, light.disabledBorder);
    });

    testWidgets('focusing switches the border to the focus token', (
      tester,
    ) async {
      await pump(tester, const SldsTextArea(label: 'Description'));

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      final border =
          tester
                  .widget<TextField>(find.byType(TextField))
                  .decoration!
                  .enabledBorder!
              as OutlineInputBorder;
      expect(
        border.borderSide.color,
        SldsColorTokens.light().inputBorderFocused,
      );
    });

    testWidgets('uses the 12px radius and the 1.6px stroke in every state', (
      tester,
    ) async {
      const dimensions = SldsDimensionTokens.standard;

      for (final widget in [
        const SldsTextArea(label: 'Description'),
        const SldsTextArea(label: 'Description', errorText: 'Error'),
        const SldsTextArea(label: 'Description', enabled: false),
      ]) {
        await pump(tester, widget);
        final border =
            tester
                    .widget<TextField>(find.byType(TextField))
                    .decoration!
                    .enabledBorder!
                as OutlineInputBorder;
        expect(
          border.borderRadius,
          BorderRadius.circular(dimensions.radius2xl),
        );
        expect(
          border.borderSide.width,
          dimensions.inputDisabledBorderWidth,
        );
      }
    });

    testWidgets('the box starts at the spec height and grows past it', (
      tester,
    ) async {
      const dimensions = SldsDimensionTokens.standard;
      await pump(tester, const SldsTextArea(label: 'Description'));

      final decoration = tester
          .widget<TextField>(find.byType(TextField))
          .decoration!;
      expect(decoration.constraints!.minHeight, dimensions.textAreaHeight);

      final before = tester.getSize(find.byType(TextField)).height;
      expect(before, greaterThanOrEqualTo(dimensions.textAreaHeight));

      await tester.enterText(
        find.byType(TextFormField),
        List.filled(12, 'a line of text').join('\n'),
      );
      await tester.pumpAndSettle();

      // The spec height is a floor, not a clamp — long content grows the box
      // instead of clipping.
      expect(
        tester.getSize(find.byType(TextField)).height,
        greaterThan(before),
      );
    });

    testWidgets('the counter sits inside the box, above the helper text', (
      tester,
    ) async {
      await pump(
        tester,
        const SldsTextArea(label: 'Description', helpText: 'Help Text'),
      );

      final box = tester.getRect(find.byType(TextField));
      final counter = tester.getRect(find.text('0/300'));
      final helper = tester.getRect(find.text('Help Text'));

      // Inside the field's own bounds, bottom-right.
      expect(counter.bottom, lessThanOrEqualTo(box.bottom));
      expect(counter.right, lessThanOrEqualTo(box.right));
      expect(counter.left, greaterThan(box.center.dx));
      // And clear of the helper line, which stays below the box.
      expect(helper.top, greaterThanOrEqualTo(box.bottom));
    });

    testWidgets('the counter turns red in the error state', (tester) async {
      await pump(tester, const SldsTextArea(label: 'Description'));
      var counter = tester.widget<Text>(find.text('0/300'));
      expect(counter.style!.color, SldsColorTokens.light().inputHelper);

      await pump(
        tester,
        const SldsTextArea(label: 'Description', errorText: 'Error Text'),
      );
      counter = tester.widget<Text>(find.text('0/300'));
      expect(counter.style!.color, SldsColorTokens.light().error);
    });

    testWidgets('label is Body 2 and dims wholesale when disabled', (
      tester,
    ) async {
      const typography = SldsTypographyTokens.standard;
      final light = SldsColorTokens.light();

      await pump(
        tester,
        const SldsTextArea(label: 'Description', isRequired: true),
      );
      var label = tester.widget<Text>(find.textContaining('Description'));
      expect(label.textSpan!.style!.fontSize, typography.body2.fontSize);
      expect(label.textSpan!.style!.color, light.inputLabel);

      await pump(
        tester,
        const SldsTextArea(
          label: 'Description',
          isRequired: true,
          enabled: false,
        ),
      );
      label = tester.widget<Text>(find.textContaining('Description'));
      expect(label.textSpan!.style!.color, light.disabledForeground);
      // The asterisk greys with the rest of the label rather than staying red.
      final asterisk = (label.textSpan! as TextSpan).children!.last as TextSpan;
      expect(asterisk.style?.color, isNull);
    });

    testWidgets('disabled keeps the white fill rather than darkening it', (
      tester,
    ) async {
      await pump(
        tester,
        const SldsTextArea(label: 'Description', enabled: false),
      );

      final decoration = tester
          .widget<TextField>(find.byType(TextField))
          .decoration!;
      expect(decoration.fillColor, SldsColorTokens.light().surfaceCard);
    });
  });
}
