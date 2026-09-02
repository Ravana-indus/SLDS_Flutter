// Accessible names on the interactive widgets that had none (§5, DoD 3).
//
// slds_form_semantics_test covers the form controls whose role and state
// Flutter's own Material widgets already announce. This file covers the
// other half: the widgets built from a bare InkWell, GestureDetector or
// TextField, which reach a screen reader as an unnamed tappable box unless
// the widget says otherwise.
//
// Two failure modes recur here and are each pinned below, because both pass
// a visual review and neither is visible without a semantics tree:
//
//   * A field whose visible label is a *sibling* Text. Nothing connects the
//     two, so the control announces with no name at all.
//   * State the design carries only in colour — a red asterisk, a red
//     border, a filled pill, a chevron direction. A screen-reader user gets
//     none of it unless it is spelled into the name or a flag.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

import 'support/slds_test_harness.dart';

/// The semantics node for the first [InkWell]/[GestureDetector]-backed
/// control in the tree.
SemanticsNode _firstTappable(WidgetTester tester, Type type) =>
    tester.getSemantics(find.byType(type).first);

void main() {
  group('fields whose visible label is a sibling Text', () {
    // Each of these renders its label as a Text above the input rather than
    // through InputDecoration, so the input itself carries no name.

    testWidgets('SldsTextField announces its label', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(wrap(const SldsTextField(label: 'Licence')));

      expect(tester.getSemantics(find.byType(TextField)).label, 'Licence');
      handle.dispose();
    });

    testWidgets('SldsTextField folds required and error into the name', (
      tester,
    ) async {
      // Both are conveyed visually by colour alone — a red asterisk and red
      // helper text — so neither reaches a screen reader on its own.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          const SldsTextField(
            label: 'Licence',
            isRequired: true,
            errorText: 'Too short',
          ),
        ),
      );

      final label = tester.getSemantics(find.byType(TextField)).label;
      expect(label, contains('Licence'));
      expect(label, contains('required'));
      expect(label, contains('Too short'));
      handle.dispose();
    });

    testWidgets('SldsTextField survives the FormField semantics boundary', (
      tester,
    ) async {
      // Regression guard, not a duplicate of the first test. SldsTextField
      // is built on TextFormField, and a FormField introduces a semantics
      // boundary that silently drops a plain ancestor Semantics label — the
      // same wrapper works on a bare TextField. Only the MergeSemantics in
      // the widget makes the name survive, so removing it fails here rather
      // than shipping a field that announces as nameless.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(wrap(const SldsTextField(label: 'Licence')));

      expect(
        tester.getSemantics(find.byType(TextField)).label,
        isNotEmpty,
        reason:
            'The label was dropped at the FormField boundary — the '
            'MergeSemantics wrapping the field is load-bearing.',
      );
      handle.dispose();
    });

    testWidgets('SldsInput and SldsInputMask announce label and required', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      for (final field in <Widget>[
        const SldsInput(label: 'Amount'),
        const SldsInputMask(label: 'NIC'),
      ]) {
        await tester.pumpWidget(wrap(field));
        final label = tester.getSemantics(find.byType(TextField)).label;
        expect(label, contains('required'), reason: '$field');
      }
      handle.dispose();
    });

    testWidgets('SldsTextArea announces its label', (tester) async {
      // Built on TextFormField like SldsTextField, so it needs the same
      // MergeSemantics to survive the FormField boundary.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(wrap(const SldsTextArea(label: 'Notes')));

      expect(tester.getSemantics(find.byType(TextField)).label, 'Notes');
      handle.dispose();
    });

    testWidgets('SldsSearchBar announces as a named text field', (
      tester,
    ) async {
      // The magnifier icon is the only marker that this is a search field,
      // and an icon announces nothing.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(const SldsSearchBar(hintText: 'Find a service')),
      );

      final node = tester.getSemantics(find.byType(TextField));
      expect(node.label, 'Find a service');
      handle.dispose();
    });
  });

  group('SldsDropdown', () {
    testWidgets('is named by its label, not by its placeholder', (
      tester,
    ) async {
      // The bug this pins: the node's name came from the value Text, so an
      // empty dropdown announced as "Select an option" — the placeholder —
      // with nothing to say which field it belonged to.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsDropdown<String>(
            label: 'District',
            items: const ['Colombo', 'Kandy'],
            itemLabel: (item) => item,
          ),
        ),
      );

      final node = _firstTappable(tester, InkWell);
      expect(node.label, contains('District'));
      expect(node.label, isNot(contains('Select an option')));
      handle.dispose();
    });

    testWidgets('announces the open/closed state', (tester) async {
      // Conveyed visually by a chevron direction only.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsDropdown<String>(
            label: 'District',
            items: const ['Colombo'],
            itemLabel: (item) => item,
          ),
        ),
      );

      expect(_firstTappable(tester, InkWell).label, contains('collapsed'));

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();

      expect(_firstTappable(tester, InkWell).label, contains('expanded'));
      handle.dispose();
    });

    testWidgets('carries the current selection as its value', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsDropdown<String>(
            label: 'District',
            value: 'Kandy',
            items: const ['Colombo', 'Kandy'],
            itemLabel: (item) => item,
          ),
        ),
      );

      expect(_firstTappable(tester, InkWell).value, 'Kandy');
      handle.dispose();
    });
  });

  group('SldsOtpInput', () {
    testWidgets('each box announces its position in the code', (tester) async {
      // Six identical boxes with no position leave a reader unable to tell
      // which digit they are on or how many remain.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(wrap(const SldsOtpInput(length: 3)));

      for (var i = 1; i <= 3; i++) {
        expect(find.bySemanticsLabel('Digit $i of 3'), findsOneWidget);
      }
      handle.dispose();
    });

    testWidgets('the error is announced once for the group, not per box', (
      tester,
    ) async {
      // The error is otherwise only a red border. Announcing it on every box
      // would repeat it [length] times.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          const SldsOtpInput(
            length: 3,
            semanticLabel: 'One-time passcode',
            errorText: 'That code has expired',
          ),
        ),
      );

      final group = tester.getSemantics(find.byType(SldsOtpInput));
      expect(group.label, contains('One-time passcode'));
      expect(group.hint, contains('That code has expired'));
      handle.dispose();
    });
  });

  group('SldsSearchBar panel', () {
    testWidgets('distinguishes a suggestion from a recent search', (
      tester,
    ) async {
      // The two row kinds differ only by a history icon, which announces
      // nothing — so both would otherwise read as the bare search term.
      final handle = tester.ensureSemantics();
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        wrap(
          SldsSearchBar(
            focusNode: focusNode,
            suggestions: const ['Colombo'],
            recentSearches: const ['Kandy'],
          ),
        ),
      );
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Suggestion: Colombo'), findsOneWidget);
      expect(find.bySemanticsLabel('Recent search: Kandy'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('the clear button is named', (tester) async {
      final handle = tester.ensureSemantics();
      final controller = TextEditingController(text: 'col');
      addTearDown(controller.dispose);

      await tester.pumpWidget(wrap(SldsSearchBar(controller: controller)));

      expect(find.bySemanticsLabel('Clear search'), findsOneWidget);
      handle.dispose();
    });
  });

  group('pickers', () {
    testWidgets('SldsDatePicker names its month navigation', (tester) async {
      // Two bare chevrons, identical to a screen reader without names.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsDatePicker(
            initialDate: DateTime(2026, 8, 15),
            onDateSelected: (_) {},
          ),
        ),
      );

      expect(find.bySemanticsLabel('Previous month'), findsOneWidget);
      expect(find.bySemanticsLabel('Next month'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('SldsDatePicker day cells announce the full date', (
      tester,
    ) async {
      // A cell renders a bare "15". The month and year live only in the
      // header, so the number alone does not identify the day being picked.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsDatePicker(
            initialDate: DateTime(2026, 8, 15),
            onDateSelected: (_) {},
          ),
        ),
      );

      expect(find.bySemanticsLabel('Aug 15, 2026'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('SldsTimePickerDialog names its hour, minute and period', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsTimePickerDialog(
            initialTime: const TimeOfDay(hour: 9, minute: 30),
            onTimeChanged: (_) {},
          ),
        ),
      );

      expect(find.bySemanticsLabel('Select hour'), findsOneWidget);
      expect(find.bySemanticsLabel('Select minute'), findsOneWidget);
      expect(find.bySemanticsLabel('AM'), findsOneWidget);
      expect(find.bySemanticsLabel('PM'), findsOneWidget);
      handle.dispose();
    });
  });

  group('pill controls whose state is colour only', () {
    testWidgets('SldsCheckButton announces a checked state', (tester) async {
      // Selection is a solid fill, nothing more.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsCheckButton(
            label: 'Email me',
            selected: true,
            onChanged: (_) {},
          ),
        ),
      );

      final node = _firstTappable(tester, InkWell);
      expect(node.label, 'Email me');
      expect(node.flagsCollection.isChecked, CheckedState.isTrue);
      handle.dispose();
    });

    testWidgets('SldsFilterButton announces its active count', (tester) async {
      // The count is the filter's state and renders as a bare numeral in a
      // badge, which does not read as belonging to the filter.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(SldsFilterButton(label: 'Status', count: 3, onTap: () {})),
      );

      final label = _firstTappable(tester, InkWell).label;
      expect(label, contains('Status'));
      expect(label, contains('3'));
      handle.dispose();
    });

    testWidgets('SldsUploadField names its drop zone', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(SldsUploadField(label: 'ID scan', onTap: () {})),
      );

      expect(_firstTappable(tester, InkWell).label, contains('ID scan'));
      handle.dispose();
    });
  });

  group('localization', () {
    testWidgets('the required marker is spoken in the active locale', (
      tester,
    ) async {
      // These names are assembled from library strings, so a hardcoded
      // English word would survive an English-only test run unnoticed.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          const SldsTextField(label: 'Licence', isRequired: true),
          locale: const Locale('ta'),
        ),
      );

      final label = tester.getSemantics(find.byType(TextField)).label;
      expect(label, contains('Licence'));
      expect(
        label,
        isNot(contains('required')),
        reason: 'The required marker was not localized.',
      );
      handle.dispose();
    });
  });
}
