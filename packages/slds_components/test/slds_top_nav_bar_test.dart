import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light,
      home: Scaffold(body: field),
    ),
  );

  testWidgets('renders the title, back chevron, and menu icon', (tester) async {
    await pump(
      tester,
      SldsTopNavBar(title: 'Page Title', onBack: () {}, onMenu: () {}),
    );

    expect(find.text('Page Title'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });

  testWidgets('tapping back invokes onBack', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsTopNavBar(title: 'Page Title', onBack: () => tapped = true),
    );

    await tester.tap(find.byIcon(Icons.chevron_left));
    expect(tapped, isTrue);
  });

  testWidgets('tapping menu invokes onMenu', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsTopNavBar(title: 'Page Title', onMenu: () => tapped = true),
    );

    await tester.tap(find.byIcon(Icons.menu));
    expect(tapped, isTrue);
  });

  testWidgets('onBack null hides the back icon entirely', (tester) async {
    await pump(tester, const SldsTopNavBar(title: 'Page Title'));
    expect(find.byIcon(Icons.chevron_left), findsNothing);
  });

  testWidgets('onMenu null hides the menu icon entirely', (tester) async {
    await pump(tester, const SldsTopNavBar(title: 'Page Title'));
    expect(find.byIcon(Icons.menu), findsNothing);
  });

  testWidgets('.progress renders totalSteps segments instead of a title', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsTopNavBar.progress(totalSteps: 6, currentStep: 3),
    );

    expect(find.text('Page Title'), findsNothing);
    final containers = tester.widgetList<Container>(
      find.descendant(
        of: find.byType(Row).last,
        matching: find.byType(Container),
      ),
    );
    expect(containers.length, greaterThanOrEqualTo(6));
  });

  testWidgets(
    '.progress: segments before currentStep are filled with the accent',
    (tester) async {
      await pump(
        tester,
        const SldsTopNavBar.progress(totalSteps: 4, currentStep: 2),
      );

      final segments = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(Row).last,
              matching: find.byType(Container),
            ),
          )
          .where((c) => c.decoration is BoxDecoration)
          .toList();

      final theme = SldsColorTokens.light();
      final filled = segments.where(
        (c) =>
            (c.decoration! as BoxDecoration).color ==
            theme.buttonPrimaryBackground,
      );
      expect(filled.length, 2);
    },
  );

  testWidgets('dark style renders a solid black background', (tester) async {
    await pump(
      tester,
      const SldsTopNavBar(title: 'Page Title', style: SldsTopNavBarStyle.dark),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, Colors.black);
  });

  testWidgets('light style (default) renders a surface background', (
    tester,
  ) async {
    await pump(tester, const SldsTopNavBar(title: 'Page Title'));

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, SldsColorTokens.light().surfaceCard);
  });
}
