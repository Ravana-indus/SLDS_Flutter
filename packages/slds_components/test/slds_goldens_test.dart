// Golden matrix (§8).
//
// Per component: every variant, every theme (light, dark, high contrast), at
// 100% and 200% text scale. Text-bearing components add si and ta at 200%,
// where the taller Sinhala and Tamil glyphs are most likely to clip (§6), and
// one RTL image to prove the directional insets §5 requires.
//
// The images are the review artefact: "a component without goldens is treated
// as unreviewed". Regenerate with `flutter test --update-goldens` and inspect
// every changed image before committing — a golden diff is a visual change,
// which §3 makes a minor version bump at minimum.
//
// Tagged `golden` so CI can run these on their own reference platform,
// separately from the behaviour suite (see .github/workflows/ci.yaml).
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

import 'support/slds_test_harness.dart';

/// Themes every component is captured against.
const _themes = <String>['light', 'dark', 'hc'];

/// Text scales every component is captured at (100% and 200%, per §8).
const _scales = <double>[1.0, 2.0];

/// Locales added for text-bearing components at 200%.
const _localeAxis = <String>['si', 'ta'];

/// Synthetic fixture text. Never a real NIC, licence or vehicle number —
/// goldens are committed images, and §1 forbids generating them against
/// realistic credential data.
const _label = 'Continue';

void main() {
  group('SldsButton', () {
    for (final variant in SldsButtonVariant.values) {
      for (final theme in _themes) {
        for (final scale in _scales) {
          testWidgets('${variant.name} $theme x$scale', (tester) async {
            await tester.pumpWidget(
              wrap(
                SldsButton(label: _label, variant: variant, onPressed: () {}),
                theme: sldsThemeNamed(theme),
                textScale: scale,
                highContrast: theme == 'hc',
              ),
            );
            await expectGolden(
              find.byType(SldsButton),
              'button_${variant.name}_${theme}_x$scale',
            );
          }, skip: goldenSkipReason != null);
        }
      }
    }

    // The locale axis exists for vertical clipping, so it only runs at 200%
    // where the risk is highest.
    for (final locale in _localeAxis) {
      testWidgets('primary $locale x2.0', (tester) async {
        await tester.pumpWidget(
          wrap(
            SldsButton(label: _label, onPressed: () {}),
            locale: Locale(locale),
            textScale: 2.0,
          ),
        );
        await expectGolden(
          find.byType(SldsButton),
          'button_primary_light_x2.0_$locale',
        );
      }, skip: goldenSkipReason != null);
    }

    testWidgets('primary rtl', (tester) async {
      // Supported locales are all LTR, so nothing else in the matrix
      // exercises the directional insets. An unverified claim of RTL
      // safety does not survive audit (§5).
      await tester.pumpWidget(
        wrap(
          SldsButton(
            label: _label,
            leadingIcon: Icons.arrow_back,
            onPressed: () {},
          ),
          textDirection: TextDirection.rtl,
        ),
      );
      await expectGolden(find.byType(SldsButton), 'button_primary_rtl');
    }, skip: goldenSkipReason != null);
  });

  group('SldsFab', () {
    for (final variant in [
      SldsButtonVariant.primary,
      SldsButtonVariant.secondary,
      SldsButtonVariant.destructive,
    ]) {
      for (final theme in _themes) {
        testWidgets('${variant.name} $theme', (tester) async {
          await tester.pumpWidget(
            wrap(
              SldsFab(icon: Icons.add, variant: variant, onPressed: () {}),
              theme: sldsThemeNamed(theme),
              highContrast: theme == 'hc',
            ),
          );
          await expectGolden(
            find.byType(SldsFab),
            'fab_${variant.name}_${theme}_x1.0',
          );
        }, skip: goldenSkipReason != null);
      }
    }

    testWidgets('with badge', (tester) async {
      await tester.pumpWidget(
        wrap(SldsFab(icon: Icons.mail, badgeCount: 3, onPressed: () {})),
      );
      await expectGolden(find.byType(SldsFab), 'fab_badge_light_x1.0');
    }, skip: goldenSkipReason != null);
  });

  group('SldsTextField', () {
    for (final theme in _themes) {
      for (final scale in _scales) {
        testWidgets('default $theme x$scale', (tester) async {
          await tester.pumpWidget(
            wrap(
              const SizedBox(
                width: 320,
                child: SldsTextField(
                  label: 'Licence number',
                  helpText: 'As printed on your licence',
                ),
              ),
              theme: sldsThemeNamed(theme),
              textScale: scale,
              highContrast: theme == 'hc',
            ),
          );
          await expectGolden(
            find.byType(SldsTextField),
            'text_field_default_${theme}_x$scale',
          );
        }, skip: goldenSkipReason != null);
      }
    }

    testWidgets('error light x1.0', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 320,
            child: SldsTextField(
              label: 'Licence number',
              errorText: 'Enter a valid licence number',
            ),
          ),
        ),
      );
      await expectGolden(
        find.byType(SldsTextField),
        'text_field_error_light_x1.0',
      );
    }, skip: goldenSkipReason != null);

    for (final locale in _localeAxis) {
      testWidgets('default $locale x2.0', (tester) async {
        await tester.pumpWidget(
          wrap(
            const SizedBox(
              width: 320,
              child: SldsTextField(label: 'Licence number'),
            ),
            locale: Locale(locale),
            textScale: 2.0,
          ),
        );
        await expectGolden(
          find.byType(SldsTextField),
          'text_field_default_light_x2.0_$locale',
        );
      }, skip: goldenSkipReason != null);
    }
  });

  group('SldsCard', () {
    for (final theme in _themes) {
      testWidgets('default $theme', (tester) async {
        await tester.pumpWidget(
          wrap(
            const SizedBox(
              width: 320,
              child: SldsCard(child: Text('Vehicle details')),
            ),
            theme: sldsThemeNamed(theme),
            highContrast: theme == 'hc',
          ),
        );
        await expectGolden(find.byType(SldsCard), 'card_default_${theme}_x1.0');
      }, skip: goldenSkipReason != null);
    }
  });

  group('SldsToggle', () {
    for (final theme in _themes) {
      for (final value in [false, true]) {
        testWidgets('${value ? 'on' : 'off'} $theme', (tester) async {
          await tester.pumpWidget(
            wrap(
              SldsToggle(value: value, onChanged: (_) {}),
              theme: sldsThemeNamed(theme),
              highContrast: theme == 'hc',
            ),
          );
          await expectGolden(
            find.byType(SldsToggle),
            'toggle_${value ? 'on' : 'off'}_${theme}_x1.0',
          );
        }, skip: goldenSkipReason != null);
      }
    }
  });
}
