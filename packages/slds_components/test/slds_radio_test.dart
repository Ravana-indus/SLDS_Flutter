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

  testWidgets('tapping an unselected radio calls onChanged with its value', (
    tester,
  ) async {
    String? selected;
    await pump(
      tester,
      SldsRadio<String>(
        value: 'a',
        groupValue: 'b',
        onChanged: (v) => selected = v,
      ),
    );

    await tester.tap(find.byType(SldsRadio<String>));
    expect(selected, 'a');
  });

  testWidgets('tapping the already-selected radio does not re-fire onChanged', (
    tester,
  ) async {
    var callCount = 0;
    await pump(
      tester,
      SldsRadio<String>(
        value: 'a',
        groupValue: 'a',
        onChanged: (_) => callCount++,
      ),
    );

    await tester.tap(find.byType(SldsRadio<String>));
    expect(callCount, 0);
  });

  testWidgets('disabled radio does not respond to taps', (tester) async {
    var called = false;
    await pump(
      tester,
      SldsRadio<String>(
        value: 'a',
        groupValue: 'b',
        enabled: false,
        onChanged: (_) => called = true,
      ),
    );

    await tester.tap(find.byType(SldsRadio<String>));
    expect(called, isFalse);
  });

  testWidgets('null onChanged is treated as disabled', (tester) async {
    await pump(
      tester,
      const SldsRadio<String>(value: 'a', groupValue: 'b', onChanged: null),
    );
    await tester.tap(find.byType(SldsRadio<String>)); // must not throw
  });

  testWidgets('size controls circle dimensions, defaulting to large (24x24)', (
    tester,
  ) async {
    await pump(
      tester,
      SldsRadio<String>(value: 'a', groupValue: 'a', onChanged: (_) {}),
    );
    var box = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(SldsRadio<String>),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(box.constraints?.maxWidth, 24);

    await pump(
      tester,
      SldsRadio<String>(
        value: 'a',
        groupValue: 'a',
        onChanged: (_) {},
        size: SldsRadioSize.small,
      ),
    );
    box = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(SldsRadio<String>),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(box.constraints?.maxWidth, 20);
  });

  // Figma Radio (541:307): a 1px ring; resting #FFFFFF with a #BCBCBC ring
  // (#224); disabled #DDDDDD with a #BCBCBC ring and dot (#225).
  testWidgets('ring, fill and dot match Figma (#224, #225)', (tester) async {
    BoxDecoration ring() => tester
        .widgetList<Container>(
          find.descendant(
            of: find.byType(SldsRadio<int>),
            matching: find.byType(Container),
          ),
        )
        .map((c) => c.decoration)
        .whereType<BoxDecoration>()
        .firstWhere((d) => d.border != null && d.color != null);
    Color? dot() =>
        (tester
                    .widget<AnimatedContainer>(find.byType(AnimatedContainer))
                    .decoration!
                as BoxDecoration)
            .color;

    await pump(
      tester,
      SldsRadio<int>(value: 1, groupValue: 2, onChanged: (_) {}),
    );
    var d = ring();
    expect(d.color, const Color(0xFFFFFFFF));
    expect((d.border! as Border).top.color, const Color(0xFFBCBCBC));
    expect((d.border! as Border).top.width, 1);

    await pump(
      tester,
      const SldsRadio<int>(value: 1, groupValue: 1, onChanged: null),
    );
    await tester.pumpAndSettle();
    d = ring();
    expect(d.color, const Color(0xFFDDDDDD));
    expect((d.border! as Border).top.color, const Color(0xFFBCBCBC));
    expect(dot(), const Color(0xFFBCBCBC));
  });
}
