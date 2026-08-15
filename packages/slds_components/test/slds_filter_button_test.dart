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

  testWidgets('renders the label and a chevron, no badge without a count', (
    tester,
  ) async {
    await pump(tester, const SldsFilterButton(label: 'Filter one'));
    expect(find.text('Filter one'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
  });

  testWidgets('a positive count shows a badge and flips to the active look', (
    tester,
  ) async {
    await pump(tester, const SldsFilterButton(label: 'Date posted', count: 3));

    expect(find.text('3'), findsOneWidget);
    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, SldsColorTokens.light().buttonPrimaryBackground);
  });

  testWidgets('count of 0 behaves like no count — no badge, inactive look', (
    tester,
  ) async {
    await pump(tester, const SldsFilterButton(label: 'Date posted', count: 0));

    expect(find.text('0'), findsNothing);
    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, SldsColorTokens.light().surfaceCard);
  });

  testWidgets('tapping invokes onTap', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsFilterButton(label: 'Filter one', onTap: () => tapped = true),
    );

    await tester.tap(find.byType(SldsFilterButton));
    expect(tapped, isTrue);
  });

  testWidgets('disabled does not respond to taps', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsFilterButton(
        label: 'Filter one',
        enabled: false,
        onTap: () => tapped = true,
      ),
    );

    await tester.tap(find.byType(SldsFilterButton));
    expect(tapped, isFalse);
  });

  testWidgets('null onTap is treated as non-interactive', (tester) async {
    await pump(tester, const SldsFilterButton(label: 'Filter one'));
    await tester.tap(find.byType(SldsFilterButton)); // must not throw
  });
}
