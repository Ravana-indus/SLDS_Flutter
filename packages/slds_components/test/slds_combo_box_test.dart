import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  const items = ['Batticaloa', 'Colombo', 'Galle', 'Jaffna'];

  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
        MaterialApp(theme: SldsTheme.light(), home: Scaffold(body: field)),
      );

  testWidgets('renders label, required marker, and placeholder when empty', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsComboBox<String>(
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

  testWidgets('selected items render as removable chips instead of the placeholder', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsComboBox<String>(
        label: 'District',
        items: items,
        itemLabel: _identity,
        value: ['Colombo', 'Jaffna'],
      ),
    );

    expect(find.text('Colombo'), findsOneWidget);
    expect(find.text('Jaffna'), findsOneWidget);
    expect(find.text('Select district'), findsNothing);
    expect(find.byIcon(Icons.close), findsNWidgets(2));
  });

  testWidgets('tapping the field opens the search + checkbox option list', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsComboBox<String>(label: 'District', items: items, itemLabel: _identity),
    );

    expect(find.text('Search'), findsNothing);
    await tester.tap(find.text('Select district'));
    await tester.pump();

    expect(find.text('Search'), findsOneWidget);
    expect(find.byType(SldsCheckbox), findsNWidgets(items.length));
  });

  testWidgets('tapping an option toggles it into onChanged and checks its box', (
    tester,
  ) async {
    List<String>? selected;
    await pump(
      tester,
      SldsComboBox<String>(
        label: 'District',
        items: items,
        itemLabel: _identity,
        onChanged: (v) => selected = v,
      ),
    );

    await tester.tap(find.text('Select district'));
    await tester.pump();
    await tester.tap(find.text('Colombo'));
    await tester.pump();

    expect(selected, ['Colombo']);
  });

  testWidgets('tapping a selected option again removes it', (tester) async {
    List<String>? selected;
    await pump(
      tester,
      SldsComboBox<String>(
        label: 'District',
        items: items,
        itemLabel: _identity,
        value: const ['Colombo'],
        onChanged: (v) => selected = v,
      ),
    );

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pump();
    await tester.tap(find.text('Colombo').last);
    await tester.pump();

    expect(selected, isEmpty);
  });

  testWidgets('the panel stays open after selecting an option (multi-select)', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsComboBox<String>(label: 'District', items: items, itemLabel: _identity),
    );

    await tester.tap(find.text('Select district'));
    await tester.pump();
    await tester.tap(find.text('Colombo'));
    await tester.pump();

    expect(find.text('Search'), findsOneWidget);
  });

  testWidgets('tapping a chip\'s close icon removes that item', (tester) async {
    List<String>? selected;
    await pump(
      tester,
      SldsComboBox<String>(
        label: 'District',
        items: items,
        itemLabel: _identity,
        value: const ['Colombo', 'Jaffna'],
        onChanged: (v) => selected = v,
      ),
    );

    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pump();

    expect(selected, ['Jaffna']);
  });

  testWidgets('typing in search filters the option list', (tester) async {
    await pump(
      tester,
      const SldsComboBox<String>(label: 'District', items: items, itemLabel: _identity),
    );

    await tester.tap(find.text('Select district'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Colo');
    await tester.pump();

    expect(find.text('Colombo'), findsOneWidget);
    expect(find.text('Batticaloa'), findsNothing);
  });

  testWidgets('shows help text when there is no error', (tester) async {
    await pump(
      tester,
      const SldsComboBox<String>(
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
      const SldsComboBox<String>(
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
      const SldsComboBox<String>(
        label: 'District',
        items: items,
        itemLabel: _identity,
        enabled: false,
      ),
    );

    await tester.tap(find.text('Select district'));
    await tester.pump();

    expect(find.text('Search'), findsNothing);
  });
}

String _identity(String item) => item;
