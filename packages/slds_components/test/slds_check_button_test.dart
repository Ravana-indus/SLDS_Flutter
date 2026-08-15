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

  testWidgets('renders the label', (tester) async {
    await pump(
      tester,
      SldsCheckButton(label: 'Option One', selected: false, onChanged: (_) {}),
    );
    expect(find.text('Option One'), findsOneWidget);
  });

  testWidgets('tapping unselected calls onChanged(true)', (tester) async {
    bool? result;
    await pump(
      tester,
      SldsCheckButton(
        label: 'Option One',
        selected: false,
        onChanged: (v) => result = v,
      ),
    );

    await tester.tap(find.byType(SldsCheckButton));
    expect(result, isTrue);
  });

  testWidgets('tapping selected calls onChanged(false)', (tester) async {
    bool? result;
    await pump(
      tester,
      SldsCheckButton(
        label: 'Option One',
        selected: true,
        onChanged: (v) => result = v,
      ),
    );

    await tester.tap(find.byType(SldsCheckButton));
    expect(result, isFalse);
  });

  testWidgets('selected renders filled with the accent background', (
    tester,
  ) async {
    await pump(
      tester,
      SldsCheckButton(label: 'Option One', selected: true, onChanged: (_) {}),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, SldsColorTokens.light().buttonPrimaryBackground);
  });

  testWidgets('unselected renders with a plain surface background', (
    tester,
  ) async {
    await pump(
      tester,
      SldsCheckButton(label: 'Option One', selected: false, onChanged: (_) {}),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, SldsColorTokens.light().surfaceCard);
  });

  testWidgets('disabled does not respond to taps', (tester) async {
    var called = false;
    await pump(
      tester,
      SldsCheckButton(
        label: 'Option One',
        selected: false,
        enabled: false,
        onChanged: (_) => called = true,
      ),
    );

    await tester.tap(find.byType(SldsCheckButton));
    expect(called, isFalse);
  });

  testWidgets('null onChanged is treated as non-interactive', (tester) async {
    await pump(
      tester,
      const SldsCheckButton(label: 'Option One', selected: false),
    );
    await tester.tap(find.byType(SldsCheckButton)); // must not throw
  });
}
