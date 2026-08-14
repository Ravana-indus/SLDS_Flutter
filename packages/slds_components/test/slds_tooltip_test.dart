import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
      home: Scaffold(body: child),
    ),
  );

  testWidgets('title-only renders the compact pill, no description/footer', (
    tester,
  ) async {
    await pump(tester, const SldsTooltip(title: 'Title'));

    expect(find.text('Title'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets(
    'title + description renders the full card without a footer when unset',
    (tester) async {
      await pump(
        tester,
        const SldsTooltip(
          title: 'Tooltip Title',
          description: 'Enter the description text',
        ),
      );

      expect(find.text('Tooltip Title'), findsOneWidget);
      expect(find.text('Enter the description text'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
    },
  );

  testWidgets(
    'renders step label, action button and close button when all set',
    (tester) async {
      var actioned = false;
      var closed = false;
      await pump(
        tester,
        SldsTooltip(
          title: 'Tooltip Title',
          description: 'Enter the description text',
          stepLabel: '1 of 5',
          actionLabel: 'Action',
          onAction: () => actioned = true,
          onClose: () => closed = true,
        ),
      );

      expect(find.text('1 of 5'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);

      await tester.tap(find.text('Action'));
      expect(actioned, isTrue);

      await tester.tap(find.byIcon(Icons.close));
      expect(closed, isTrue);
    },
  );

  testWidgets('tail sits above the card by default, below when asked', (
    tester,
  ) async {
    await pump(tester, const SldsTooltip(title: 'Title'));
    expect(
      tester.getCenter(find.byType(CustomPaint).last).dy,
      lessThan(tester.getCenter(find.text('Title')).dy),
    );

    await pump(
      tester,
      const SldsTooltip(title: 'Title', tailSide: SldsTooltipTailSide.bottom),
    );
    expect(
      tester.getCenter(find.byType(CustomPaint).last).dy,
      greaterThan(tester.getCenter(find.text('Title')).dy),
    );
  });

  testWidgets('compact pill tail stays over the pill, not the parent', (
    tester,
  ) async {
    await pump(
      tester,
      const SizedBox(
        width: 400,
        child: Align(
          alignment: Alignment.centerLeft,
          child: SldsTooltip(
            title: 'Title',
            tailAlignment: SldsTooltipTailAlignment.center,
          ),
        ),
      ),
    );

    final pill = tester.getRect(find.byType(SldsTooltip));
    final tailX = tester.getCenter(find.byType(CustomPaint).last).dx;
    expect(tailX, greaterThan(pill.left));
    expect(tailX, lessThan(pill.right));
  });

  testWidgets('full card fills the available width', (tester) async {
    await pump(
      tester,
      const SizedBox(
        width: 300,
        child: SldsTooltip(title: 'Title', description: 'Description'),
      ),
    );
    expect(tester.getSize(find.byType(SldsTooltip)).width, 300);
  });
}
