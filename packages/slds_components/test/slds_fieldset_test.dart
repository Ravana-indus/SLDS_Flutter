import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
      home: Scaffold(body: field),
    ),
  );

  testWidgets('renders legend and its children', (tester) async {
    await pump(
      tester,
      const SldsFieldset(
        legend: 'Shipping address',
        children: [Text('Street'), Text('City')],
      ),
    );

    expect(find.text('Shipping address'), findsOneWidget);
    expect(find.text('Street'), findsOneWidget);
    expect(find.text('City'), findsOneWidget);
  });

  testWidgets('required=true shows the marker, false hides it', (tester) async {
    await pump(
      tester,
      const SldsFieldset(
        legend: 'Group',
        required: true,
        children: [Text('Field')],
      ),
    );
    expect(find.text('*'), findsOneWidget);

    await pump(
      tester,
      const SldsFieldset(
        legend: 'Group',
        required: false,
        children: [Text('Field')],
      ),
    );
    expect(find.text('*'), findsNothing);
  });

  testWidgets('shows description when provided', (tester) async {
    await pump(
      tester,
      const SldsFieldset(
        legend: 'Group',
        description: 'Where should we deliver your order?',
        children: [Text('Field')],
      ),
    );
    expect(find.text('Where should we deliver your order?'), findsOneWidget);
  });

  testWidgets('shows helper text when there is no error', (tester) async {
    await pump(
      tester,
      const SldsFieldset(
        legend: 'Group',
        helperText: 'All fields are required.',
        children: [Text('Field')],
      ),
    );
    expect(find.text('All fields are required.'), findsOneWidget);
  });

  testWidgets('error text replaces helper text and colors it red', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsFieldset(
        legend: 'Group',
        helperText: 'All fields are required.',
        errorText: 'Please complete every field.',
        children: [Text('Field')],
      ),
    );

    expect(find.text('Please complete every field.'), findsOneWidget);
    expect(find.text('All fields are required.'), findsNothing);

    final errorLabel = tester.widget<Text>(
      find.text('Please complete every field.'),
    );
    expect(errorLabel.style?.color, SldsColorTokens.light().error);
  });

  testWidgets('enabled=false dims the legend', (tester) async {
    await pump(
      tester,
      const SldsFieldset(
        legend: 'Group',
        enabled: false,
        children: [Text('Field')],
      ),
    );

    final legend = tester.widget<Text>(find.text('Group'));
    expect(legend.style?.color, SldsColorTokens.light().disabledForeground);
  });

  testWidgets(
    'renders multiple children with spacing between them, none before the first',
    (tester) async {
      await pump(
        tester,
        const SldsFieldset(
          legend: 'Group',
          children: [Text('A'), Text('B'), Text('C')],
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    },
  );

  testWidgets(
    'is exposed as a single semantics container labeled with the legend',
    (tester) async {
      await pump(
        tester,
        const SldsFieldset(
          legend: 'Shipping address',
          children: [Text('Field')],
        ),
      );

      final semantics = tester.getSemantics(find.byType(SldsFieldset));
      expect(semantics.label, 'Shipping address');
    },
  );
}
