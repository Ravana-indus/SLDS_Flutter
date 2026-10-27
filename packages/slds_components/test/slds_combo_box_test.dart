import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  const options = ['Batticaloa', 'Colombo', 'Galle', 'Jaffna'];

  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: field),
    ),
  );

  Widget build({
    List<String> selectedValues = const [],
    ValueChanged<List<String>>? onSelectionChanged,
    bool multiple = false,
    bool required = true,
    String? helperText,
    SldsComboBoxState? visualState,
  }) {
    return SldsComboBox(
      label: 'District',
      placeholder: 'Select district',
      options: options,
      selectedValues: selectedValues,
      onSelectionChanged: onSelectionChanged ?? (_) {},
      multiple: multiple,
      required: required,
      helperText: helperText,
      visualState: visualState,
    );
  }

  testWidgets('renders label, required marker, and placeholder when empty', (
    tester,
  ) async {
    await pump(tester, build());

    expect(find.textContaining('District'), findsOneWidget);
    expect(find.text('*'), findsOneWidget);
    expect(find.text('Select district'), findsOneWidget);
  });

  testWidgets('required=false hides the marker', (tester) async {
    await pump(tester, build(required: false));
    expect(find.text('*'), findsNothing);
  });

  testWidgets('multiple selected values render as removable chips', (
    tester,
  ) async {
    await pump(
      tester,
      build(multiple: true, selectedValues: const ['Colombo', 'Jaffna']),
    );

    expect(find.text('Colombo'), findsOneWidget);
    expect(find.text('Jaffna'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNWidgets(2));
  });

  testWidgets('tapping the field opens the option list', (tester) async {
    await pump(tester, build());

    expect(find.text('Colombo'), findsNothing);
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pump();

    for (final option in options) {
      expect(find.text(option), findsOneWidget);
    }
  });

  testWidgets(
    'single-select: tapping an option selects it and closes the panel',
    (tester) async {
      List<String>? selected;
      await pump(tester, build(onSelectionChanged: (v) => selected = v));

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pump();
      await tester.tap(find.text('Colombo'));
      await tester.pump();

      expect(selected, ['Colombo']);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsNothing);
    },
  );

  testWidgets(
    'multi-select: tapping an option toggles it and keeps the panel open',
    (tester) async {
      List<String>? selected;
      await pump(
        tester,
        build(multiple: true, onSelectionChanged: (v) => selected = v),
      );

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pump();
      await tester.tap(find.text('Colombo'));
      await tester.pump();

      expect(selected, ['Colombo']);
    },
  );

  testWidgets('rows follow Figma: selection is the yellow checkbox, hover '
      'fills the row (#99)', (tester) async {
    await pump(
      tester,
      build(multiple: true, selectedValues: const ['Colombo']),
    );
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pump();

    // Figma's list item has no selected-row fill: a selected row shows a
    // checked #FFC700 box, and only Hover/Focus fill the row #EEEEEE.
    Container box(String option) => tester.widget<Container>(
      find
          .descendant(
            of: find.ancestor(
              of: find.text(option),
              matching: find.byType(InkWell),
            ),
            matching: find.byWidgetPredicate(
              (w) => w is Container && w.constraints?.maxWidth == 16,
            ),
          )
          .first,
    );
    expect(
      (box('Colombo').decoration! as BoxDecoration).color,
      const Color(0xFFFFC700),
    );
    expect(
      (box('Batticaloa').decoration! as BoxDecoration).color,
      const Color(0xFFF7F7F7),
    );
    final row = tester.widget<InkWell>(
      find.ancestor(of: find.text('Colombo'), matching: find.byType(InkWell)),
    );
    expect(row.hoverColor, const Color(0xFFEEEEEE));
    // Only the panel row: the selected value also shows as a grey chip.
    final rowFinder = find.ancestor(
      of: find.text('Colombo').last,
      matching: find.byType(InkWell),
    );
    expect(
      tester
          .widgetList<Container>(
            find.descendant(
              of: rowFinder.first,
              matching: find.byType(Container),
            ),
          )
          .map((c) => (c.decoration as BoxDecoration?)?.color)
          .whereType<Color>()
          .where((c) => c == const Color(0xFFEEEEEE)),
      isEmpty,
      reason: 'no selected-row fill',
    );
  });

  testWidgets('multi-select: tapping a selected option again removes it', (
    tester,
  ) async {
    List<String>? selected;
    await pump(
      tester,
      build(
        multiple: true,
        selectedValues: const ['Colombo'],
        onSelectionChanged: (v) => selected = v,
      ),
    );

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pump();
    await tester.tap(find.text('Colombo').last);
    await tester.pump();

    expect(selected, isEmpty);
  });

  testWidgets("tapping a chip's close icon removes that item", (tester) async {
    List<String>? selected;
    await pump(
      tester,
      build(
        multiple: true,
        selectedValues: const ['Colombo', 'Jaffna'],
        onSelectionChanged: (v) => selected = v,
      ),
    );

    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pump();

    expect(selected, ['Jaffna']);
  });

  testWidgets('typing in the panel search bar narrows the option list', (
    tester,
  ) async {
    await pump(tester, build());

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pump();
    // The search bar inside the open panel is the only text field; the
    // collapsed field is display-only.
    await tester.enterText(find.byType(TextField), 'Colo');
    await tester.pump();

    expect(find.text('Colombo'), findsOneWidget);
    expect(find.text('Batticaloa'), findsNothing);
  });

  testWidgets('the search bar clear button appears only with a query', (
    tester,
  ) async {
    await pump(tester, build());

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pump();
    // Empty query: the search bar shows no clear button.
    expect(find.byIcon(Icons.close), findsNothing);

    await tester.enterText(find.byType(TextField), 'Colo');
    await tester.pump();
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    // Clearing restores the full list and hides the button again.
    expect(find.byIcon(Icons.close), findsNothing);
    expect(find.text('Batticaloa'), findsOneWidget);
  });

  testWidgets('shows helper text', (tester) async {
    await pump(tester, build(helperText: 'Help Text'));
    expect(find.text('Help Text'), findsOneWidget);
  });

  testWidgets('visualState forces the panel open regardless of interaction', (
    tester,
  ) async {
    await pump(tester, build(visualState: SldsComboBoxState.filling));
    expect(find.text('Colombo'), findsOneWidget);
  });
}
