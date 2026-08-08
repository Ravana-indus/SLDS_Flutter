import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  const items = ['Batticaloa', 'Colombo', 'Galle', 'Gampaha'];

  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
        MaterialApp(theme: SldsTheme.light(), home: Scaffold(body: field)),
      );

  testWidgets('renders label, required marker, and placeholder', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsDropdown<String>(
        label: 'District',
        items: items,
        itemLabel: _identity,
        isRequired: true,
        hintText: 'Select district',
      ),
    );

    expect(find.textContaining('District'), findsOneWidget);
    expect(find.textContaining('*'), findsOneWidget);
    expect(find.text('Select district'), findsOneWidget);
  });

  testWidgets('tapping the field opens the search + option list', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsDropdown<String>(label: 'District', items: items, itemLabel: _identity),
    );

    expect(find.text('Search'), findsNothing);
    await tester.tap(find.text('Select an option'));
    await tester.pump();

    expect(find.text('Search'), findsOneWidget);
    for (final item in items) {
      expect(find.text(item), findsOneWidget);
    }
  });

  testWidgets('typing in search filters the option list', (tester) async {
    await pump(
      tester,
      const SldsDropdown<String>(label: 'District', items: items, itemLabel: _identity),
    );

    await tester.tap(find.text('Select an option'));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Colo');
    await tester.pump();

    expect(find.text('Colombo'), findsOneWidget);
    expect(find.text('Batticaloa'), findsNothing);
    expect(find.text('Galle'), findsNothing);
  });

  testWidgets('selecting an item calls onChanged, closes the panel, and shows the value', (
    tester,
  ) async {
    String? selected;
    await pump(
      tester,
      SldsDropdown<String>(
        label: 'District',
        items: items,
        itemLabel: _identity,
        onChanged: (v) => selected = v,
      ),
    );

    await tester.tap(find.text('Select an option'));
    await tester.pump();
    await tester.tap(find.text('Colombo'));
    await tester.pump();

    expect(selected, 'Colombo');
    expect(find.text('Search'), findsNothing);
  });

  testWidgets('shows "No results" when the search matches nothing', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsDropdown<String>(label: 'District', items: items, itemLabel: _identity),
    );

    await tester.tap(find.text('Select an option'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();

    expect(find.text('No results'), findsOneWidget);
  });

  testWidgets('shows help text when there is no error', (tester) async {
    await pump(
      tester,
      const SldsDropdown<String>(
        label: 'District',
        items: items,
        itemLabel: _identity,
        helpText: 'Help Text',
      ),
    );
    expect(find.text('Help Text'), findsOneWidget);
  });

  testWidgets('error text replaces help text', (tester) async {
    await pump(
      tester,
      const SldsDropdown<String>(
        label: 'District',
        items: items,
        itemLabel: _identity,
        helpText: 'Help Text',
        errorText: 'Error Text',
      ),
    );

    expect(find.text('Error Text'), findsOneWidget);
    expect(find.text('Help Text'), findsNothing);
  });

  testWidgets('disabled field does not open on tap', (tester) async {
    await pump(
      tester,
      const SldsDropdown<String>(
        label: 'District',
        items: items,
        itemLabel: _identity,
        enabled: false,
      ),
    );

    await tester.tap(find.text('Select an option'));
    await tester.pump();

    expect(find.text('Search'), findsNothing);
  });
}

String _identity(String item) => item;
