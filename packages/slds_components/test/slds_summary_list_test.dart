import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget list) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
      home: Scaffold(body: list),
    ),
  );

  const rows = [
    SldsSummaryRow(label: 'Application ID', value: 'APP-2026-001234'),
    SldsSummaryRow(label: 'Submitted date', value: '28th June 2026'),
    SldsSummaryRow(
      label: 'Current status',
      value: 'In Review',
      badgeStatus: SldsSummaryBadgeStatus.inReview,
    ),
  ];

  testWidgets('renders every label and plain-text value', (tester) async {
    await pump(tester, const SldsSummaryList(rows: rows));

    expect(find.text('Application ID'), findsOneWidget);
    expect(find.text('APP-2026-001234'), findsOneWidget);
    expect(find.text('Submitted date'), findsOneWidget);
    expect(find.text('28th June 2026'), findsOneWidget);
  });

  testWidgets('renders a status row value as a badge with the right colors', (
    tester,
  ) async {
    await pump(tester, const SldsSummaryList(rows: rows));

    final colors = SldsColorTokens.light();
    final badgeText = tester.widget<Text>(find.text('In Review'));
    expect(badgeText.style?.color, colors.badgeInReviewText);

    final badgeContainer = tester.widget<Container>(
      find
          .ancestor(
            of: find.text('In Review'),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(
      (badgeContainer.decoration as BoxDecoration).color,
      colors.badgeInReviewBackground,
    );
  });

  testWidgets('draws a divider between rows but not before the first', (
    tester,
  ) async {
    await pump(tester, const SldsSummaryList(rows: rows));

    expect(find.byType(Divider), findsNWidgets(rows.length - 1));
  });

  testWidgets('width clamps to the available parent width', (tester) async {
    await pump(
      tester,
      const SizedBox(
        width: 200,
        child: SldsSummaryList(rows: rows, width: 400),
      ),
    );

    final size = tester.getSize(find.byType(SldsSummaryList));
    expect(size.width, 200);
  });

  testWidgets('exposes label:value as combined semantics per row', (
    tester,
  ) async {
    await pump(tester, const SldsSummaryList(rows: rows));

    expect(
      find.bySemanticsLabel('Application ID: APP-2026-001234'),
      findsOneWidget,
    );
  });
}
