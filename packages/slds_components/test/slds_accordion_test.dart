import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  const items = [
    SldsAccordionItem(title: 'Section A', body: Text('Body A')),
    SldsAccordionItem(title: 'Section B', body: Text('Body B')),
  ];

  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
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

  testWidgets('title and content colours match Figma (#35, #36)', (
    tester,
  ) async {
    await pump(tester, const SldsAccordion(items: items));
    await tester.tap(find.text('Section A'));
    await tester.pumpAndSettle();

    TextStyle painted(String text) =>
        tester.renderObject<RenderParagraph>(find.text(text)).text.style!;
    // Figma Text/Primary, Mobile/Body 1.
    expect(painted('Section A').color, const Color(0xFF17171A));
    // Figma Text/Secondary, Desktop/Body 2 — inherited by a plain Text body.
    expect(painted('Body A').color, const Color(0xFF676767));
    expect(painted('Body A').fontSize, 14);
  });
}
