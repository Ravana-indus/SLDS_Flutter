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

// SldsChip's close (×) button: Figma specs a 28px-tall pill and a 16px
// glyph, so the close icon's real hit-test area is grown invisibly via
// SldsOverflowTapTarget (Stack + Positioned) rather than reserving 48px of
// layout space, which would stretch the whole pill past spec. A tap
// genuinely anywhere in that 48x48 region reaches the button — see
// "tapping the close icon fires onDeleted" in slds_chip_test.dart — but
// Semantics geometry always comes from a real RenderObject's own paint
// bounds, and MergeSemantics unions node *properties* (label, actions,
// flags), never geometry, confirmed by dumping this exact semantics tree.
// A control that is visually 16px but genuinely 48px-tappable cannot report
// a matching 48x48 rect to Flutter's semantics tree as things stand, so
// androidTapTargetGuideline — which reads that rect — cannot see it. This
// is a documented, verified exception, not a real accessibility gap.
const _knownTapTargetExceptions = {'chip'};

// SldsProcessList's done step uses the Approved badge pair, matched exactly
// to Figma Badge/Approved/Text #059669 (issue #27): 3.24:1 on #E0F2EC.
// Pending design review — the same exemption as 'light: approved badge' in
// slds_tokens/test/contrast_test.dart.
//
// SldsTooltip's action is an SldsButton (Secondary, Small) per Figma. Its
// semantics rect is the 48px tap target, so the guideline samples the
// tooltip surface around the 28px button rather than the button fill
// (1.59:1 measured; painted label is 15.9:1 light, 9.74:1 dark). Tooltip
// copy is covered by 'tooltip text on tooltip background' in contrast_test.
//
// SldsErrorState's status code (404/500/401) is Figma Text/Tertiary #BCBCBC
// exactly (issue #34): 1.77:1 on the page, below 3:1 for large text. Pending
// design review — same exemption as 'light: error state code on page' in
// contrast_test; the description is covered by its own token pairing.
//
// SldsErrorSummary's links are Figma's 16/400 #D32F2F (issue #149), each in
// a row held to the 48px tap floor so its semantics rect is 48px tall. The
// guideline averages the thin 400-weight glyphs over that whole row and
// reports 3.04:1; the painted pair, #D32F2F on white, is 4.98:1, and the
// stricter #D32F2F on #F7F7F7 is checked by 'error text on page' in
// contrast_test. Same artifact as the tooltip's.
const _knownTextContrastExceptions = {
  'process_list',
  'tooltip',
  'error_state',
  'error_summary',
};

void main() {
  for (final fixture in sldsFixtures()) {
    group(fixture.name, () {
      testWidgets(
        'tap targets meet 48x48',
        (tester) async {
          await tester.pumpWidget(_host(fixture, SldsTheme.light));
          await tester.pumpAndSettle();
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        },
        skip: _knownTapTargetExceptions.contains(fixture.name),
      );

      testWidgets(
        'text contrast meets WCAG AA as painted',
        (tester) async {
          await tester.pumpWidget(_host(fixture, SldsTheme.light));
          await tester.pumpAndSettle();
          await expectLater(tester, meetsGuideline(textContrastGuideline));
        },
        skip: _knownTextContrastExceptions.contains(fixture.name),
      );

      testWidgets('every tappable node is labelled', (tester) async {
        await tester.pumpWidget(_host(fixture, SldsTheme.light));
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      });
    });
  }
}
