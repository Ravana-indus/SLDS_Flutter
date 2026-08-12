import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
        MaterialApp(theme: SldsTheme.light(), home: Scaffold(body: child)),
      );

  testWidgets('renders title and every error message', (tester) async {
    await pump(
      tester,
      const SldsErrorSummary(
        errors: [
          SldsErrorSummaryItem('Enter your NIC Number correctly'),
          SldsErrorSummaryItem('Enter you Birth date correctly'),
        ],
      ),
    );

    expect(find.text('There is a problem'), findsOneWidget);
    expect(find.text('Enter your NIC Number correctly'), findsOneWidget);
    expect(find.text('Enter you Birth date correctly'), findsOneWidget);
  });

  testWidgets('renders nothing when there are no errors', (tester) async {
    await pump(tester, const SldsErrorSummary(errors: []));
    expect(find.byType(SldsErrorSummary), findsOneWidget);
    expect(find.text('There is a problem'), findsNothing);
  });

  testWidgets('tapping an error invokes its onTap', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsErrorSummary(
        errors: [SldsErrorSummaryItem('Enter your NIC Number correctly', onTap: () => tapped = true)],
      ),
    );

    await tester.tap(find.text('Enter your NIC Number correctly'));
    expect(tapped, isTrue);
  });
}
