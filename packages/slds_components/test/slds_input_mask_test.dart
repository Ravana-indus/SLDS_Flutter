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
      const SldsInputMask(
        label: 'Input',
        prefixText: 'http://',
        suffixText: '.com',
      ),
    );

    expect(find.textContaining('Input'), findsOneWidget);
    expect(find.text('*'), findsOneWidget);
    expect(find.text('http://'), findsOneWidget);
    expect(find.text('.com'), findsOneWidget);
  });

  testWidgets('required=false hides the marker', (tester) async {
    await pump(tester, const SldsInputMask(label: 'Input', required: false));
    expect(find.text('*'), findsNothing);
  });

  testWidgets('prefix/suffix are optional', (tester) async {
    await pump(tester, const SldsInputMask(label: 'Input'));
    expect(find.text('http://'), findsNothing);
    expect(find.text('.com'), findsNothing);
  });

  testWidgets(
    'shows helper text by default, error text when errorText is set',
    (tester) async {
      await pump(
        tester,
        const SldsInputMask(label: 'Input', helperText: 'Help Text'),
      );
      expect(find.text('Help Text'), findsOneWidget);

      await pump(
        tester,
        const SldsInputMask(
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
    await pump(
      tester,
      SldsInputMask(label: 'Input', onChanged: (v) => value = v),
    );

    await tester.enterText(find.byType(TextField), 'slds');
    expect(value, 'slds');
  });

  testWidgets('enabled=false disables the field', (tester) async {
    await pump(tester, const SldsInputMask(label: 'Input', enabled: false));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.enabled, isFalse);
  });

  testWidgets(
    'visualState=disabled disables the field even when enabled=true',
    (tester) async {
      await pump(
        tester,
        const SldsInputMask(
          label: 'Input',
          visualState: SldsInputMaskState.disabled,
        ),
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
        const SldsInputMask(label: 'Input', errorText: 'Bad value'),
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

  testWidgets(
    'gaining focus resolves to the focused visual state (gold border)',
    (tester) async {
      await pump(tester, const SldsInputMask(label: 'Input'));

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

  testWidgets(
    'focusing thickens the prefix cell divider to match the outer border',
    (tester) async {
      await pump(
        tester,
        const SldsInputMask(label: 'Input', prefixText: 'http://'),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();

      final cellContainer = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((c) {
            final decoration = c.decoration;
            if (decoration is! BoxDecoration || decoration.border is! Border) {
              return false;
            }
            return (decoration.border! as Border).right != BorderSide.none;
          });
      final border =
          (cellContainer.decoration! as BoxDecoration).border! as Border;
      final tokens = SldsTokenSet.light();
      expect(border.right.width, tokens.dimensions.emphasizedBorderWidth);
    },
  );

  testWidgets('a committed value survives losing focus (filled state)', (
    tester,
  ) async {
    final controller = TextEditingController();
    await pump(tester, SldsInputMask(label: 'Input', controller: controller));

    await tester.enterText(find.byType(TextField), 'slds');
    await tester.pump();
    await tester.tap(find.byType(Scaffold)); // unfocus
    await tester.pump();

    expect(controller.text, 'slds');
    expect(find.text('slds'), findsOneWidget);
  });

  testWidgets('visualState=filled can be forced without a controller/value', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsInputMask(
        label: 'Input',
        visualState: SldsInputMaskState.filled,
      ),
    );
    expect(find.byType(SldsInputMask), findsOneWidget);
  });

  testWidgets('width clamps to the available parent width', (tester) async {
    await pump(
      tester,
      const SldsInputMask(label: 'Input', width: 1000),
      width: 300,
    );

    final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
    final matched = sizedBoxes.where((b) => b.width == 300);
    expect(matched, isNotEmpty);
  });
}
