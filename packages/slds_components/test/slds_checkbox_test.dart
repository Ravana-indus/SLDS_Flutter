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

  testWidgets('unchecked shows no icon', (tester) async {
    await pump(tester, SldsCheckbox(value: false, onChanged: (_) {}));
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('checked shows a check icon', (tester) async {
    await pump(tester, SldsCheckbox(value: true, onChanged: (_) {}));
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('indeterminate shows a dash, not a check', (tester) async {
    await pump(tester, SldsCheckbox(value: null, onChanged: (_) {}));
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('tapping unchecked calls onChanged(true)', (tester) async {
    bool? result;
    await pump(
      tester,
      SldsCheckbox(value: false, onChanged: (v) => result = v),
    );

    await tester.tap(find.byType(SldsCheckbox));
    expect(result, isTrue);
  });

  testWidgets('tapping checked calls onChanged(false)', (tester) async {
    bool? result;
    await pump(tester, SldsCheckbox(value: true, onChanged: (v) => result = v));

    await tester.tap(find.byType(SldsCheckbox));
    expect(result, isFalse);
  });

  testWidgets('disabled checkbox does not respond to taps', (tester) async {
    var called = false;
    await pump(
      tester,
      SldsCheckbox(
        value: false,
        enabled: false,
        onChanged: (_) => called = true,
      ),
    );

    await tester.tap(find.byType(SldsCheckbox));
    expect(called, isFalse);
  });

  testWidgets('null onChanged is treated as disabled', (tester) async {
    await pump(tester, const SldsCheckbox(value: false, onChanged: null));
    await tester.tap(find.byType(SldsCheckbox)); // must not throw
  });

  testWidgets('size controls box dimensions, defaulting to large (24x24)', (
    tester,
  ) async {
    await pump(tester, SldsCheckbox(value: false, onChanged: (_) {}));
    var box = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(SldsCheckbox),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(box.constraints?.maxWidth, 24);

    await pump(
      tester,
      SldsCheckbox(
        value: false,
        onChanged: (_) {},
        size: SldsCheckboxSize.small,
      ),
    );
    box = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(SldsCheckbox),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(box.constraints?.maxWidth, 16); // Figma Size=Default (#145).
  });

  // Figma Checkbox (542:442).
  BoxDecoration box(WidgetTester tester) =>
      tester
              .widget<AnimatedContainer>(find.byType(AnimatedContainer))
              .decoration!
          as BoxDecoration;

  testWidgets('Large is 24px and Small 16px (#144, #145)', (tester) async {
    for (final (size, edge) in [
      (SldsCheckboxSize.large, 24.0),
      (SldsCheckboxSize.small, 16.0),
    ]) {
      for (final value in [false, true, null]) {
        for (final enabled in [true, false]) {
          await pump(
            tester,
            SldsCheckbox(
              value: value,
              size: size,
              enabled: enabled,
              onChanged: (_) {},
            ),
          );
          expect(
            tester.getSize(find.byType(AnimatedContainer)),
            Size(edge, edge),
            reason: '$size value=$value enabled=$enabled',
          );
          expect(box(tester).borderRadius, BorderRadius.circular(2));
        }
      }
    }
  });

  testWidgets('checked and indeterminate marks are #FDFDFD (#146)', (
    tester,
  ) async {
    await pump(tester, SldsCheckbox(value: true, onChanged: (_) {}));
    expect(box(tester).color, const Color(0xFFFFC700));
    expect(
      tester.widget<Icon>(find.byIcon(Icons.check)).color,
      const Color(0xFFFDFDFD),
    );

    await pump(tester, SldsCheckbox(value: null, onChanged: (_) {}));
    final dash = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(AnimatedContainer),
            matching: find.byType(Container),
          )
          .last,
    );
    expect(dash.color, const Color(0xFFFDFDFD));
  });

  testWidgets('unchecked is #F7F7F7 with a #BCBCBC border (#147)', (
    tester,
  ) async {
    for (final size in SldsCheckboxSize.values) {
      await pump(
        tester,
        SldsCheckbox(value: false, size: size, onChanged: (_) {}),
      );
      final d = box(tester);
      expect(d.color, const Color(0xFFF7F7F7));
      final side = (d.border! as Border).top;
      expect(side.color, const Color(0xFFBCBCBC));
      expect(side.width, size == SldsCheckboxSize.large ? 1.5 : 1);
    }
  });
}
