// ThemeExtension wiring and the inverse-surface tokens (§4).
//
// Two things are under test:
//
//   1. The token set travels on ThemeData as a ThemeExtension, so a consuming
//      app can override tokens with `theme.copyWith(extensions:)` and have
//      components pick the override up. Before this, `context.slds` re-derived
//      a palette from brightness and silently ignored any customization.
//
//   2. The components with a deliberate dark *style variant* (top nav, bottom
//      nav, tab strip, pull-to-refresh) read those colours from tokens rather
//      than hardcoded Colors.black/white. They previously could not render in
//      the high-contrast palette at all — the palette whose users need it most.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';
import 'package:slds_tokens/slds_tokens.dart';

import 'support/slds_test_harness.dart';

void main() {
  group('SldsTokenSet is a ThemeExtension (§4)', () {
    test('every shipped theme carries the extension', () {
      for (final theme in [
        SldsTheme.light,
        SldsTheme.dark,
        SldsTheme.highContrast,
      ]) {
        expect(theme.extension<SldsTokenSet>(), isNotNull);
      }
    });

    test('each theme carries its own palette, not a shared one', () {
      final light = SldsTheme.light.extension<SldsTokenSet>()!;
      final dark = SldsTheme.dark.extension<SldsTokenSet>()!;
      final hc = SldsTheme.highContrast.extension<SldsTokenSet>()!;

      expect(light.colors.surfacePage, isNot(dark.colors.surfacePage));
      expect(light.colors.textPrimary, isNot(hc.colors.textPrimary));
    });

    testWidgets('context.slds returns the theme extension', (tester) async {
      late SldsTokenSet seen;
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              seen = context.slds;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(seen, same(SldsTheme.light.extension<SldsTokenSet>()));
    });

    testWidgets('an app override reaches context.slds', (tester) async {
      // The whole point of the extension: a host app rebrands the accent and
      // components follow, without forking a widget.
      const brand = Color(0xFF8D153A);
      final base = SldsTheme.light.extension<SldsTokenSet>()!;
      final overridden = SldsTheme.light.copyWith(
        extensions: [
          base.copyWith(
            colors: SldsColorTokens(
              base.colors.tokens.copyWith(buttonPrimaryBackground: 0xFF8D153A),
            ),
          ),
        ],
      );

      late SldsTokenSet seen;
      await tester.pumpWidget(
        MaterialApp(
          theme: overridden,
          localizationsDelegates: SldsLocalizations.localizationsDelegates,
          supportedLocales: SldsLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              seen = context.slds;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(seen.colors.buttonPrimaryBackground, brand);
    });

    test('lerp interpolates rather than snapping', () {
      final light = SldsTheme.light.extension<SldsTokenSet>()!;
      final dark = SldsTheme.dark.extension<SldsTokenSet>()!;
      final mid = light.lerp(dark, 0.5);

      expect(mid.colors.surfacePage, isNot(light.colors.surfacePage));
      expect(mid.colors.surfacePage, isNot(dark.colors.surfacePage));
    });
  });

  group('inverse surface tokens', () {
    test('every palette defines an inverse pair', () {
      for (final tokens in [
        SldsTokenSet.light(),
        SldsTokenSet.dark(),
        SldsTokenSet.highContrast(),
      ]) {
        expect(tokens.colors.surfaceInverse, isNotNull);
        expect(tokens.colors.textInverse, isNotNull);
      }
    });

    test('text on the inverse surface clears WCAG AA in every palette', () {
      for (final entry in {
        'light': SldsRawColorTokens.light(),
        'dark': SldsRawColorTokens.dark(),
        'highContrast': SldsRawColorTokens.highContrast(),
      }.entries) {
        final ratio = contrastRatio(
          entry.value.textInverse,
          entry.value.surfaceInverse,
        );
        expect(
          ratio,
          greaterThanOrEqualTo(4.5),
          reason:
              '${entry.key}: text on the inverse surface is $ratio:1, '
              'below the 4.5:1 WCAG 1.4.3 minimum for body text',
        );
      }
    });
  });

  group('dark style variants read tokens, not literals', () {
    // The regression this guards: `dark` in these widgets is a *style
    // variant*, not Theme.brightness, so a reader that greps for brightness
    // misses that high contrast never reached them.
    testWidgets('the dark top nav paints the inverse token', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SldsTopNavBar(title: 'Licence', style: SldsTopNavBarStyle.dark),
          theme: SldsTheme.highContrast,
          highContrast: true,
        ),
      );

      final expected = SldsTokenSet.highContrast().colors.surfaceInverse;
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(SldsTopNavBar),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, expected);
    });
  });
}
