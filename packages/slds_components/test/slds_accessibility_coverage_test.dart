// Rendered-tree accessibility gates over *every* component (§5, §8, DoD 4).
//
// `slds_accessibility_guidelines_test.dart` runs the same matchers against a
// handful of components chosen by hand. That is not a gate: a matcher aimed at
// four widgets can only ever find bugs in those four, and it missed a 26x26
// month-navigation button in the date picker that a GovTech audit later found
// by reading the source.
//
// This suite drives the matchers from `sldsFixtures()`, the same list the
// golden and device-floor suites use, and `slds_fixture_coverage_test.dart`
// fails when an exported component has no fixture in it. So a new component
// cannot be added to the library and silently skip these checks.
//
// Three matchers, each catching something the others cannot:
//
//   androidTapTargetGuideline  every tappable node is at least 48x48
//                              (WCAG 2.5.8; SLDS holds Android's stricter
//                              figure over iOS's 44)
//   textContrastGuideline      text as *painted* clears WCAG AA, including
//                              any opacity composited on top — which the
//                              pure-Dart token test structurally cannot see
//   labeledTapTargetGuideline  every tappable node has a name to announce

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

import 'support/slds_fixtures.dart';

/// Builds [fixture] inside a themed, localized app, matching how a consuming
/// app installs the library.
Widget _host(SldsFixture fixture, ThemeData theme) => MaterialApp(
  theme: theme,
  localizationsDelegates: SldsLocalizations.localizationsDelegates,
  supportedLocales: SldsLocalizations.supportedLocales,
  home: Scaffold(
    body: Center(
      child: fixture.width == null
          ? fixture.build()
          : SizedBox(width: fixture.width, child: fixture.build()),
    ),
  ),
);

void main() {
  for (final fixture in sldsFixtures()) {
    group(fixture.name, () {
      testWidgets('tap targets meet 48x48', (tester) async {
        await tester.pumpWidget(_host(fixture, SldsTheme.light));
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      });

      testWidgets('text contrast meets WCAG AA as painted', (tester) async {
        await tester.pumpWidget(_host(fixture, SldsTheme.light));
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      });

      testWidgets('every tappable node is labelled', (tester) async {
        await tester.pumpWidget(_host(fixture, SldsTheme.light));
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      });
    });
  }
}
