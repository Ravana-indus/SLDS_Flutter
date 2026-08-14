import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  const options = ['Option One', 'Option Two', 'Option Three'];

  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light,
      home: Scaffold(body: field),
    ),
  );

  testWidgets('renders every option, checkboxes when multiple', (tester) async {
    await pump(
      tester,
      SldsFilterDropdown(
        options: options,
        selectedValues: const [],
        onSelectionChanged: (_) {},
      ),
    );

    for (final option in options) {
      expect(find.text(option), findsOneWidget);
    }
    expect(find.byType(SldsCheckbox), findsNWidgets(options.length));
  });

  testWidgets('renders radios when multiple is false', (tester) async {
    await pump(
      tester,
      SldsFilterDropdown(
        options: options,
        selectedValues: const [],
        multiple: false,
        onSelectionChanged: (_) {},
      ),
    );

    expect(find.byType(SldsRadio<bool>), findsNWidgets(options.length));
    expect(find.byType(SldsCheckbox), findsNothing);
  });

  testWidgets(
    'multi-select: tapping a row toggles it into onSelectionChanged',
    (tester) async {
      List<String>? next;
      await pump(
        tester,
        SldsFilterDropdown(
          options: options,
          selectedValues: const [],
          onSelectionChanged: (v) => next = v,
        ),
      );

      await tester.tap(find.text('Option One'));
      expect(next, ['Option One']);
    },
  );

  testWidgets('multi-select: tapping a selected row again removes it', (
    tester,
  ) async {
    List<String>? next;
    await pump(
      tester,
      SldsFilterDropdown(
        options: options,
        selectedValues: const ['Option One'],
        onSelectionChanged: (v) => next = v,
      ),
    );

    await tester.tap(find.text('Option One'));
    expect(next, isEmpty);
  });

  testWidgets(
    'single-select: picking a new option replaces the prior selection',
    (tester) async {
      List<String>? next;
      await pump(
        tester,
        SldsFilterDropdown(
          options: options,
          selectedValues: const ['Option One'],
          multiple: false,
          onSelectionChanged: (v) => next = v,
        ),
      );

      await tester.tap(find.text('Option Two'));
      expect(next, ['Option Two']);
    },
  );

  testWidgets('Apply calls onApply with the current selectedValues', (
    tester,
  ) async {
    List<String>? applied;
    await pump(
      tester,
      SldsFilterDropdown(
        options: options,
        selectedValues: const ['Option One', 'Option Two'],
        onSelectionChanged: (_) {},
        onApply: (v) => applied = v,
      ),
    );

    await tester.tap(find.text('Apply'));
    expect(applied, ['Option One', 'Option Two']);
  });

  testWidgets('Cancel calls onCancel', (tester) async {
    var cancelled = false;
    await pump(
      tester,
      SldsFilterDropdown(
        options: options,
        selectedValues: const [],
        onSelectionChanged: (_) {},
        onCancel: () => cancelled = true,
      ),
    );

    await tester.tap(find.text('Cancel'));
    expect(cancelled, isTrue);
  });

  testWidgets('cancelText/applyText override the default footer labels', (
    tester,
  ) async {
    await pump(
      tester,
      SldsFilterDropdown(
        options: options,
        selectedValues: const [],
        onSelectionChanged: (_) {},
        cancelText: 'Discard',
        applyText: 'Save',
      ),
    );

    expect(find.text('Discard'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Cancel'), findsNothing);
    expect(find.text('Apply'), findsNothing);
  });
}
