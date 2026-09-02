// Guards the claim that the floor and golden suites cover *every* public
// component (§1, §8).
//
// Both suites iterate `sldsFixtures()`. That is only equal to "every
// component" while the list keeps pace with the exports — and the failure
// mode is silent: a new widget ships, no fixture is added, and both suites
// keep passing while covering one component less than they claim.
//
// This compares the fixture names against the widget files actually exported
// from the package, so adding a component without a fixture fails here rather
// than quietly shrinking the coverage.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/slds_fixtures.dart';

void main() {
  test('every exported widget has a fixture', () {
    final exported = File('lib/slds_components.dart')
        .readAsLinesSync()
        .map(
          RegExp(r"^export 'src/widgets/slds_(\w+)\.dart';").firstMatch,
        )
        .nonNulls
        .map((m) => m.group(1)!)
        .toSet();

    // Fixture names are the widget's file stem, so the two sets compare
    // directly. A fixture may cover a second surface of the same widget
    // (e.g. a dialog opened by a field), hence subset rather than equality.
    final covered = sldsFixtures().map((f) => f.name).toSet();
    final missing = exported.difference(covered);

    expect(
      missing,
      isEmpty,
      reason:
          'These components are exported but have no fixture, so the device '
          'floor and golden suites silently skip them. Add each to '
          'test/support/slds_fixtures.dart: ${missing.join(', ')}',
    );
  });
}
