// Minimum device floor (§1).
//
// The library declares a 320dp minimum logical width, and §1 is explicit that
// components must "render and remain interactive at that floor, not merely
// compile for it". These lay every exported component out at 320dp and fail
// on any overflow, which is what "renders" actually means here.
//
// 320dp is not hypothetical for this platform: it is the width of the low-end
// Android devices a large share of citizens use. Nor is 200% text scale — it
// is what a citizen with low vision has set system-wide, and the narrowest
// screen at the largest text is the hardest cell in the matrix.
//
// The component list is `sldsFixtures()`, shared with the golden suite, so a
// new component cannot be added to the library and skip this check.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

import 'support/slds_fixtures.dart';
import 'support/slds_test_harness.dart';

/// The declared minimum logical width.
const _floorWidth = 320.0;

/// Text scale a component must also survive at the floor (§5).
const _maxTextScale = 2.0;

void main() {
  Future<void> pumpAtFloor(
    WidgetTester tester,
    Widget child, {
    double textScale = 1.0,
  }) async {
    tester.view.physicalSize = const Size(_floorWidth, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(wrap(child, textScale: textScale));
    await tester.pumpAndSettle();
  }

  /// Fails if the widget overflowed its constraints.
  void expectNoOverflow(WidgetTester tester, String what) {
    expect(
      tester.takeException(),
      isNull,
      reason: '$what overflows at ${_floorWidth}dp, the declared floor',
    );
  }

  // Every exported component, at the floor and at the floor doubled. A
  // fixture is given the full 320dp rather than its golden `width`, since
  // what is under test is the floor itself, not the framing of an image.
  for (final fixture in sldsFixtures()) {
    group(fixture.name, () {
      testWidgets('renders at the ${_floorWidth.toInt()}dp floor', (
        tester,
      ) async {
        await pumpAtFloor(tester, fixture.build());
        expectNoOverflow(tester, fixture.name);
      });

      testWidgets('renders at the floor at 200% text scale', (tester) async {
        await pumpAtFloor(
          tester,
          fixture.build(),
          textScale: _maxTextScale,
        );
        expectNoOverflow(tester, '${fixture.name} at 200%');
      });
    });
  }

  group('stays interactive at the floor', () {
    testWidgets('SldsButton still receives taps', (tester) async {
      var tapped = false;
      await pumpAtFloor(
        tester,
        SldsButton(label: 'Continue', onPressed: () => tapped = true),
      );

      await tester.tap(find.byType(SldsButton));
      expect(tapped, isTrue, reason: 'button is unreachable at the floor');
    });

    testWidgets('touch targets keep the 48px minimum at the floor', (
      tester,
    ) async {
      await pumpAtFloor(
        tester,
        SldsButton(label: 'Continue', onPressed: () {}),
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    });
  });
}
