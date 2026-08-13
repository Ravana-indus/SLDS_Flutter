import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget list) => tester.pumpWidget(
        MaterialApp(theme: SldsTheme.light(), home: Scaffold(body: list)),
      );

  const steps = [
    SldsProcessStep(
      title: 'Prepare documents',
      description: 'Gather all required identification and supporting files',
      status: SldsProcessStepStatus.done,
    ),
    SldsProcessStep(
      title: 'Verification in progress',
      description: 'Our team reviews your documents',
      status: SldsProcessStepStatus.current,
    ),
    SldsProcessStep(
      title: 'Receive approval',
      description: 'Notification sent via email and SMS',
    ),
  ];

  testWidgets('renders every step title, description and 1-based number', (tester) async {
    await pump(tester, const SldsProcessList(steps: steps));

    expect(find.text('Prepare documents'), findsOneWidget);
    expect(find.text('Gather all required identification and supporting files'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('done/current/upcoming badges use distinct colors', (tester) async {
    await pump(tester, const SldsProcessList(steps: steps));

    final colors = SldsColorTokens.light();

    Color badgeColorFor(String number) {
      final container = tester.widget<Container>(
        find.ancestor(of: find.text(number), matching: find.byType(Container)).first,
      );
      return (container.decoration as BoxDecoration).color!;
    }

    expect(badgeColorFor('1'), colors.badgeApprovedBackground); // done
    expect(badgeColorFor('2'), colors.badgePendingBackground); // current
    expect(badgeColorFor('3'), colors.disabledBackground); // upcoming
  });

  testWidgets('draws a divider between steps but not before the first', (tester) async {
    await pump(tester, const SldsProcessList(steps: steps));

    expect(find.byType(Divider), findsNWidgets(steps.length - 1));
  });

  testWidgets('width clamps to the available parent width', (tester) async {
    await pump(
      tester,
      SizedBox(
        width: 200,
        child: SingleChildScrollView(child: SldsProcessList(steps: steps, width: 480)),
      ),
    );

    final size = tester.getSize(find.byType(SldsProcessList));
    expect(size.width, 200);
  });

  testWidgets('exposes step number, title and description as combined semantics', (tester) async {
    await pump(tester, const SldsProcessList(steps: steps));

    expect(
      find.bySemanticsLabel(
        'Step 1: Prepare documents. Gather all required identification and supporting files',
      ),
      findsOneWidget,
    );
  });
}
