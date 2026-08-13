import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  const items = [
    SldsTabStripItem(label: 'Overview'),
    SldsTabStripItem(label: 'Details', count: 2),
  ];

  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
        MaterialApp(theme: SldsTheme.light(), home: Scaffold(body: child)),
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

  testWidgets('the selected tab is marked selected for accessibility', (tester) async {
    await pump(
      tester,
      SldsTabStrip(items: items, currentIndex: 1, onTap: (_) {}),
    );

    final detailsTab = find.byWidgetPredicate(
      (w) => w is Semantics && w.properties.label == 'Details',
    );
    expect(
      tester.getSemantics(detailsTab),
      matchesSemantics(isButton: true, isSelected: true, hasSelectedState: true, label: 'Details'),
    );
  });
}
