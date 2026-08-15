// Minimum device floor (§1).
//
// The library declares a 320dp minimum logical width, and §1 is explicit that
// components must "render and remain interactive at that floor, not merely
// compile for it". These pump the widest components at 320dp and fail on any
// overflow, which is what "renders" actually means here.
//
// 320dp is not hypothetical for this platform: it is the width of the low-end
// Android devices a large share of citizens use.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

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

  group('renders at the 320dp floor', () {
    testWidgets('SldsButton, including a long label', (tester) async {
      await pumpAtFloor(
        tester,
        SldsButton(
          label: 'Renew my revenue licence now',
          onPressed: () {},
        ),
      );
      expectNoOverflow(tester, 'SldsButton');
    });

    testWidgets('SldsTextField with label, helper and error', (tester) async {
      await pumpAtFloor(
        tester,
        const SldsTextField(
          label: 'Licence number',
          helpText: 'As printed on the top right of your licence',
          errorText: 'Enter a valid licence number',
        ),
      );
      expectNoOverflow(tester, 'SldsTextField');
    });

    testWidgets('SldsCard with running text', (tester) async {
      await pumpAtFloor(
        tester,
        const SldsCard(
          child: Text(
            'Your revenue licence expires soon. Renew it online to avoid a '
            'penalty at the counter.',
          ),
        ),
      );
      expectNoOverflow(tester, 'SldsCard');
    });

    testWidgets('SldsFab', (tester) async {
      await pumpAtFloor(tester, SldsFab(icon: Icons.add, onPressed: () {}));
      expectNoOverflow(tester, 'SldsFab');
    });
  });

  group('renders at the floor at 200% text scale', () {
    // The hardest case in the matrix: the narrowest supported screen and the
    // largest supported text at the same time.
    testWidgets('SldsButton', (tester) async {
      await pumpAtFloor(
        tester,
        SldsButton(label: 'Continue', onPressed: () {}),
        textScale: _maxTextScale,
      );
      expectNoOverflow(tester, 'SldsButton at 200%');
    });

    testWidgets('SldsTextField', (tester) async {
      await pumpAtFloor(
        tester,
        const SldsTextField(label: 'Licence number', helpText: 'Twelve digits'),
        textScale: _maxTextScale,
      );
      expectNoOverflow(tester, 'SldsTextField at 200%');
    });

    testWidgets('SldsCard', (tester) async {
      await pumpAtFloor(
        tester,
        const SldsCard(child: Text('Renew your licence')),
        textScale: _maxTextScale,
      );
      expectNoOverflow(tester, 'SldsCard at 200%');
    });
  });

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
