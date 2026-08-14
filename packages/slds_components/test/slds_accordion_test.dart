import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  const items = [
    SldsAccordionItem(title: 'Section A', body: Text('Body A')),
    SldsAccordionItem(title: 'Section B', body: Text('Body B')),
  ];

  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );

  testWidgets('all items collapsed by default', (tester) async {
    await pump(tester, const SldsAccordion(items: items));

    expect(find.text('Section A'), findsOneWidget);
    expect(find.text('Body A'), findsNothing);
    expect(find.text('Body B'), findsNothing);
  });

  testWidgets('initiallyExpanded opens the given indices', (tester) async {
    await pump(
      tester,
      const SldsAccordion(items: items, initiallyExpanded: {1}),
    );

    expect(find.text('Body A'), findsNothing);
    expect(find.text('Body B'), findsOneWidget);
  });

  testWidgets(
    'tapping a header toggles just that item, others stay independent',
    (tester) async {
      await pump(tester, const SldsAccordion(items: items));

      await tester.tap(find.text('Section A'));
      await tester.pumpAndSettle();
      expect(find.text('Body A'), findsOneWidget);
      expect(find.text('Body B'), findsNothing);

      await tester.tap(find.text('Section B'));
      await tester.pumpAndSettle();
      expect(find.text('Body A'), findsOneWidget);
      expect(find.text('Body B'), findsOneWidget);

      await tester.tap(find.text('Section A'));
      await tester.pumpAndSettle();
      expect(find.text('Body A'), findsNothing);
      expect(find.text('Body B'), findsOneWidget);
    },
  );
}
