// Form-control semantics (§5).
//
// A checkbox, radio or switch that reaches a screen reader as an unlabelled
// box is unusable: the user cannot tell what the control is, what state it
// is in, or what it governs. These assert all three.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

import 'support/slds_test_harness.dart';

void main() {
  group('SldsCheckbox', () {
    testWidgets('announces role, state and name', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsCheckbox(
            value: true,
            onChanged: (_) {},
            semanticLabel: 'I accept the terms',
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(SldsCheckbox));
      expect(node.label, 'I accept the terms');
      expect(node.flagsCollection.isChecked, CheckedState.isTrue);
      expect(node.flagsCollection.isEnabled, Tristate.isTrue);
      handle.dispose();
    });

    testWidgets('unchecked state is announced as unchecked', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(SldsCheckbox(value: false, onChanged: (_) {}, semanticLabel: 'X')),
      );

      final node = tester.getSemantics(find.byType(SldsCheckbox));
      expect(node.flagsCollection.isChecked, CheckedState.isFalse);
      handle.dispose();
    });

    testWidgets('indeterminate is announced as mixed, not as unchecked', (
      tester,
    ) async {
      // "Some but not all selected" is a distinct state; collapsing it to
      // unchecked would misreport a select-all parent.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(SldsCheckbox(value: null, onChanged: (_) {}, semanticLabel: 'X')),
      );

      final node = tester.getSemantics(find.byType(SldsCheckbox));
      expect(node.flagsCollection.isChecked, CheckedState.mixed);
      handle.dispose();
    });

    testWidgets('disabled is announced as disabled', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(const SldsCheckbox(value: false, onChanged: null)),
      );

      final node = tester.getSemantics(find.byType(SldsCheckbox));
      expect(node.flagsCollection.isEnabled, Tristate.isFalse);
      handle.dispose();
    });
  });

  group('SldsRadio', () {
    testWidgets('is announced as a radio, not a checkbox', (tester) async {
      // inMutuallyExclusiveGroup is the flag that distinguishes them, and it
      // changes how the whole group is navigated.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsRadio<String>(
            value: 'petrol',
            groupValue: 'petrol',
            onChanged: (_) {},
            semanticLabel: 'Petrol',
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(SldsRadio<String>));
      expect(node.label, 'Petrol');
      expect(node.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
      expect(node.flagsCollection.isChecked, CheckedState.isTrue);
      handle.dispose();
    });

    testWidgets('an unselected option is announced as unselected', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsRadio<String>(
            value: 'diesel',
            groupValue: 'petrol',
            onChanged: (_) {},
            semanticLabel: 'Diesel',
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(SldsRadio<String>));
      expect(node.flagsCollection.isChecked, CheckedState.isFalse);
      handle.dispose();
    });
  });

  group('SldsToggle', () {
    testWidgets('is announced as a switch, not a checkbox', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsToggle(
            value: true,
            onChanged: (_) {},
            semanticLabel: 'Email reminders',
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(SldsToggle));
      expect(node.label, 'Email reminders');
      expect(node.flagsCollection.isToggled, Tristate.isTrue);
      handle.dispose();
    });

    testWidgets('off state is announced as off', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(SldsToggle(value: false, onChanged: (_) {}, semanticLabel: 'X')),
      );

      final node = tester.getSemantics(find.byType(SldsToggle));
      expect(node.flagsCollection.isToggled, Tristate.isFalse);
      handle.dispose();
    });
  });

  group('all three', () {
    testWidgets('expose a tap action so they can be activated', (tester) async {
      // Announcing state is not enough — assistive technology has to be able
      // to change it.
      final handle = tester.ensureSemantics();

      for (final widget in <Widget>[
        SldsCheckbox(value: false, onChanged: (_) {}, semanticLabel: 'a'),
        SldsToggle(value: false, onChanged: (_) {}, semanticLabel: 'b'),
        SldsRadio<int>(
          value: 1,
          groupValue: 2,
          onChanged: (_) {},
          semanticLabel: 'c',
        ),
      ]) {
        await tester.pumpWidget(wrap(widget));
        final node = tester.getSemantics(find.byWidget(widget));
        expect(
          node.getSemanticsData().hasAction(SemanticsAction.tap),
          isTrue,
          reason:
              '${widget.runtimeType} cannot be activated by a '
              'screen reader',
        );
      }
      handle.dispose();
    });
  });
}
