// Golden coverage for the components outside the deep matrix (§8).
//
// `slds_goldens_test.dart` holds the full per-variant, per-theme, per-scale
// matrix for the five components that carry the most visual surface. §8 also
// treats "a component without goldens" as unreviewed, which left the other 47
// exported components with no image at all.
//
// This file closes that gap at a deliberately shallower depth: one image per
// component per theme (light, dark, high contrast), plus a 200% text-scale
// image in light. That is enough to catch the regressions goldens actually
// catch here — a token that stopped resolving, a surface that went
// transparent in dark, a control that clips when the user doubles their text
// size — without multiplying 47 components by every variant they own.
//
// Deepen a component's coverage by moving it into the matrix file when its
// variants start carrying real visual meaning, not by widening this one.
//
// Regenerate with `flutter test --update-goldens` and inspect every changed
// image before committing — a golden diff is a visual change, which §3 makes
// a minor version bump at minimum.
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/slds_fixtures.dart';
import 'support/slds_test_harness.dart';

/// Themes every component is captured against, matching the matrix file.
const _themes = <String>['light', 'dark', 'hc'];

void main() {
  for (final fixture in sldsFixtures()) {
    group(fixture.name, () {
      for (final theme in _themes) {
        testWidgets('$theme x1.0', (tester) async {
          await tester.pumpWidget(
            wrap(
              _bounded(fixture),
              theme: sldsThemeNamed(theme),
              highContrast: theme == 'hc',
            ),
          );
          await expectGolden(
            find.byType(_Frame),
            '${fixture.name}_${theme}_x1.0',
          );
        }, skip: goldenSkipReason != null);
      }

      // 200% is where a fixed-height control clips its own text, which is the
      // failure this shallow matrix is most likely to catch (§8).
      testWidgets('light x2.0', (tester) async {
        await tester.pumpWidget(wrap(_bounded(fixture), textScale: 2));
        await expectGolden(
          find.byType(_Frame),
          '${fixture.name}_light_x2.0',
        );
      }, skip: goldenSkipReason != null);
    });
  }
}

/// Wraps a fixture in the [_Frame] the golden is captured against.
///
/// Capturing a shared marker type rather than each component's own type keeps
/// one code path here; capturing the component directly would miss the width
/// bound that frames it.
Widget _bounded(SldsFixture fixture) => _Frame(
  child: fixture.width == null
      ? fixture.build()
      : SizedBox(width: fixture.width, child: fixture.build()),
);

/// Marker widget giving every coverage golden the same capture boundary.
class _Frame extends StatelessWidget {
  const _Frame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
