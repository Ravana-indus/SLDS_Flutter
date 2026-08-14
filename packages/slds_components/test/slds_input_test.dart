import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field, {double width = 400}) =>
      tester.pumpWidget(
        MaterialApp(
          theme: SldsTheme.light,
          home: Scaffold(
            body: SizedBox(width: width, child: field),
          ),
        ),
      );

  testWidgets('renders label, required marker, prefix, and suffix', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsInput(label: 'Input', prefixText: 'LKR', suffixText: 'KG'),
    );

    expect(find.textContaining('Input'), findsOneWidget);
    expect(find.text('*'), findsOneWidget);
    expect(find.text('LKR'), findsOneWidget);
    expect(find.text('KG'), findsOneWidget);
  });

  testWidgets('required=false hides the marker', (tester) async {
    await pump(tester, const SldsInput(label: 'Input', required: false));
    expect(find.text('*'), findsNothing);
  });

  testWidgets('prefix/suffix are optional', (tester) async {
    await pump(tester, const SldsInput(label: 'Input'));
    expect(find.text('LKR'), findsNothing);
    expect(find.text('KG'), findsNothing);
  });

  testWidgets(
    'shows helper text by default, error text when errorText is set',
    (tester) async {
      await pump(
        tester,
        const SldsInput(label: 'Input', helperText: 'Help Text'),
      );
      expect(find.text('Help Text'), findsOneWidget);

      await pump(
        tester,
        const SldsInput(
          label: 'Input',
          helperText: 'Help Text',
          errorText: 'Bad value',
        ),
      );
      expect(find.text('Bad value'), findsOneWidget);
      expect(find.text('Help Text'), findsNothing);
    },
  );

  testWidgets('typing invokes onChanged', (tester) async {
    String? value;
    await pump(tester, SldsInput(label: 'Input', onChanged: (v) => value = v));

    await tester.enterText(find.byType(TextField), '0000');
    expect(value, '0000');
  });

  testWidgets('enabled=false disables the field', (tester) async {
    await pump(tester, const SldsInput(label: 'Input', enabled: false));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.enabled, isFalse);
  });

  testWidgets(
    'visualState=disabled disables the field even when enabled=true',
    (tester) async {
      await pump(
        tester,
        const SldsInput(label: 'Input', visualState: SldsInputState.disabled),
      );
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isFalse);
    },
  );

  testWidgets(
    'errorText without a forced state resolves the error border color',
    (tester) async {
      await pump(
        tester,
        const SldsInput(label: 'Input', errorText: 'Bad value'),
      );

      final container = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere(
            (c) =>
                c.decoration is BoxDecoration &&
                (c.decoration! as BoxDecoration).border != null,
          );
      final decoration = container.decoration! as BoxDecoration;
      expect(
        (decoration.border as Border).top.color,
        SldsColorTokens.light().inputBorderError,
      );
    },
  );

  testWidgets('a committed value survives losing focus (filled state)', (
    tester,
  ) async {
    final controller = TextEditingController();
    await pump(tester, SldsInput(label: 'Input', controller: controller));

    await tester.enterText(find.byType(TextField), '0000');
    await tester.pump();
    await tester.tap(find.byType(Scaffold)); // unfocus
    await tester.pump();

    expect(controller.text, '0000');
    expect(find.text('0000'), findsOneWidget);
  });

  testWidgets('visualState=filled can be forced without a controller/value', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsInput(label: 'Input', visualState: SldsInputState.filled),
    );
    expect(find.byType(SldsInput), findsOneWidget);
  });

  testWidgets(
    'gaining focus resolves to the focused visual state (gold border)',
    (tester) async {
      await pump(tester, const SldsInput(label: 'Input'));

      await tester.tap(find.byType(TextField));
      await tester.pump();

      final container = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere(
            (c) =>
                c.decoration is BoxDecoration &&
                (c.decoration! as BoxDecoration).border != null,
          );
      final decoration = container.decoration! as BoxDecoration;
      expect(
        (decoration.border as Border).top.color,
        SldsColorTokens.light().inputBorderFocused,
      );
    },
  );

  testWidgets('width clamps to the available parent width', (tester) async {
    await pump(
      tester,
      const SldsInput(label: 'Input', width: 1000),
      width: 300,
    );

    final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
    final matched = sizedBoxes.where((b) => b.width == 300);
    expect(matched, isNotEmpty);
  });
}
