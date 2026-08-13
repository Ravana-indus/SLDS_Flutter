import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
        MaterialApp(theme: SldsTheme.light(), home: Scaffold(body: child)),
      );

  testWidgets('renders one segment per totalSteps', (tester) async {
    await pump(tester, const SldsStepIndicator(totalSteps: 6, currentStep: 3));
    expect(find.byType(Container), findsNWidgets(6));
  });

  testWidgets('fills the first currentStep segments with the accent color', (tester) async {
    await pump(tester, const SldsStepIndicator(totalSteps: 4, currentStep: 2));

    final colors = SldsColorTokens.light();
    final containers = tester.widgetList<Container>(find.byType(Container)).toList();
    final decorations = containers.map((c) => (c.decoration! as BoxDecoration).color).toList();

    expect(decorations[0], colors.buttonPrimaryBackground);
    expect(decorations[1], colors.buttonPrimaryBackground);
    expect(decorations[2], colors.borderDefault);
    expect(decorations[3], colors.borderDefault);
  });

  testWidgets('fills the available width', (tester) async {
    await pump(
      tester,
      const SizedBox(width: 300, child: SldsStepIndicator(totalSteps: 4, currentStep: 1)),
    );
    expect(tester.getSize(find.byType(SldsStepIndicator)).width, 300);
  });
}
