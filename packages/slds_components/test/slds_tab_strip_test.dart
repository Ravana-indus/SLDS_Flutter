import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  const items = [
    SldsTabStripItem(label: 'Overview'),
    SldsTabStripItem(label: 'Details', count: 2),
  ];

  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
      home: Scaffold(body: child),
    ),
  );

  testWidgets('renders every tab label and count', (tester) async {
    await pump(
      tester,
      SldsTabStrip(items: items, currentIndex: 0, onTap: (_) {}),
    );

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Details'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('tapping a tab reports its index', (tester) async {
    int? tapped;
    await pump(
      tester,
      SldsTabStrip(items: items, currentIndex: 0, onTap: (i) => tapped = i),
    );

    await tester.tap(find.text('Details'));
    expect(tapped, 1);
  });

  testWidgets('the selected tab is marked selected for accessibility', (
    tester,
  ) async {
    await pump(
      tester,
      SldsTabStrip(items: items, currentIndex: 1, onTap: (_) {}),
    );

    final detailsTab = find.byWidgetPredicate(
      (w) => w is Semantics && w.properties.label == 'Details',
    );
    expect(
      tester.getSemantics(detailsTab),
      matchesSemantics(
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        label: 'Details',
      ),
    );
  });

  testWidgets('unselected tabs show the radio indicator, selected does not', (
    tester,
  ) async {
    await pump(
      tester,
      SldsTabStrip(items: items, currentIndex: 0, onTap: (_) {}),
    );

    // Overview is selected (index 0) so it gets no indicator; Details is
    // unselected and defaults to a leading indicator.
    expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
  });

  testWidgets('indicatorLeading places the radio after the label instead', (
    tester,
  ) async {
    await pump(
      tester,
      SldsTabStrip(
        items: const [
          SldsTabStripItem(label: 'Overview', indicatorLeading: false),
        ],
        currentIndex: -1,
        onTap: (_) {},
      ),
    );

    final row = tester.widget<Row>(
      find
          .descendant(of: find.byType(InkWell), matching: find.byType(Row))
          .first,
    );
    final iconIndex = row.children.indexWhere((w) => w is Icon);
    final textIndex = row.children.indexWhere((w) => w is Flexible);
    expect(iconIndex, greaterThan(textIndex));
  });
}
