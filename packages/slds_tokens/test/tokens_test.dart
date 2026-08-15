import 'package:slds_tokens/slds_tokens.dart';
import 'package:test/test.dart';

void main() {
  group('SldsRawColorTokens', () {
    test('two instances of the same palette are equal', () {
      expect(SldsRawColorTokens.light(), SldsRawColorTokens.light());
      expect(
        SldsRawColorTokens.light().hashCode,
        SldsRawColorTokens.light().hashCode,
      );
    });

    test('different palettes are not equal', () {
      expect(SldsRawColorTokens.light(), isNot(SldsRawColorTokens.dark()));
      expect(
        SldsRawColorTokens.light(),
        isNot(SldsRawColorTokens.highContrast()),
      );
    });

    test('copyWith changes only the named role', () {
      final base = SldsRawColorTokens.light();
      final changed = base.copyWith(textPrimary: 0xff123456);

      expect(changed.textPrimary, 0xff123456);
      expect(changed.textSecondary, base.textSecondary);
      expect(changed, isNot(base));
    });

    test('copyWith with no arguments equals the original', () {
      expect(SldsRawColorTokens.light().copyWith(), SldsRawColorTokens.light());
    });

    test('lerp returns the endpoints at t=0 and t=1', () {
      final a = SldsRawColorTokens.light();
      final b = SldsRawColorTokens.dark();

      expect(SldsRawColorTokens.lerp(a, b, 0), a);
      expect(SldsRawColorTokens.lerp(a, b, 1), b);
    });

    test('lerp interpolates each channel at the midpoint', () {
      final a = SldsRawColorTokens.light().copyWith(textPrimary: 0xff000000);
      final b = SldsRawColorTokens.light().copyWith(textPrimary: 0xffffffff);

      expect(SldsRawColorTokens.lerp(a, b, 0.5).textPrimary, 0xff808080);
    });
  });

  group('lerpArgb', () {
    test('interpolates the alpha channel too', () {
      expect(lerpArgb(0x00000000, 0xff000000, 0.5), 0x80000000);
    });

    test('clamps rather than overflowing', () {
      expect(lerpArgb(0xff000000, 0xffffffff, 2), 0xffffffff);
      expect(lerpArgb(0xff000000, 0xffffffff, -1), 0xff000000);
    });
  });

  group('SldsDimensionTokens', () {
    test('the standard scale is equal to itself', () {
      expect(SldsDimensionTokens.standard, SldsDimensionTokens.standard);
      expect(
        SldsDimensionTokens.standard.hashCode,
        SldsDimensionTokens.standard.hashCode,
      );
    });

    test('copyWith changes only the named value', () {
      final changed = SldsDimensionTokens.standard.copyWith(space4: 99);

      expect(changed.space4, 99);
      expect(changed.space8, SldsDimensionTokens.standard.space8);
      expect(changed, isNot(SldsDimensionTokens.standard));
    });

    test('retains the negative elevation spread', () {
      // Regression: an earlier port dropped this because the value is negative.
      expect(SldsDimensionTokens.standard.elevationSpread, -3);
    });
  });

  group('SldsRawTypographyTokens', () {
    test('heightFactor converts designed line height to a multiplier', () {
      const token = SldsTextStyleToken(
        fontSize: 16,
        lineHeight: 20,
        fontWeight: 400,
      );

      expect(token.heightFactor, 20 / 16);
    });

    test('the standard scale is equal to itself', () {
      expect(
        SldsRawTypographyTokens.standard,
        SldsRawTypographyTokens.standard,
      );
    });

    test('copyWith changes only the named style', () {
      final changed = SldsRawTypographyTokens.standard.copyWith(
        body1: const SldsTextStyleToken(
          fontSize: 99,
          lineHeight: 99,
          fontWeight: 700,
        ),
      );

      expect(changed.body1.fontSize, 99);
      expect(changed.body2, SldsRawTypographyTokens.standard.body2);
    });

    test('retains negative letter spacing', () {
      expect(SldsRawTypographyTokens.standard.mobileDisplay1.letterSpacing, -2);
    });

    // Every style pinned to the Figma text-style spec (Foundation
    // Documentation, node 1193:10717), so a drifting metric fails here rather
    // than shipping. Values are size / line height / weight / tracking, and
    // the comment names the exact Figma style each token mirrors — the
    // unprefixed Dart names do not consistently mean "desktop".
    test('the standard scale matches the Figma text-style spec', () {
      const t = SldsRawTypographyTokens.standard;
      const expected = <String, (SldsTextStyleToken, String)>{
        'bottomNavigationLabel': (
          SldsTextStyleToken(
            fontSize: 12,
            lineHeight: 18,
            fontWeight: 400,
            letterSpacing: 0.2,
          ),
          'Desktop/Caption 1',
        ),
        'snackbarCaption': (
          SldsTextStyleToken(
            fontSize: 12,
            lineHeight: 18,
            fontWeight: 400,
            letterSpacing: 0.2,
          ),
          'Desktop/Caption 1',
        ),
        'body1': (
          SldsTextStyleToken(fontSize: 16, lineHeight: 20, fontWeight: 400),
          'Mobile/Body 1',
        ),
        'body2': (
          SldsTextStyleToken(fontSize: 14, lineHeight: 22, fontWeight: 400),
          'Desktop/Body 2',
        ),
        'caption1': (
          SldsTextStyleToken(fontSize: 12, lineHeight: 16, fontWeight: 400),
          'Mobile/Caption 1',
        ),
        'caption2': (
          SldsTextStyleToken(
            fontSize: 11,
            lineHeight: 16,
            fontWeight: 400,
            letterSpacing: 0.3,
          ),
          'Desktop/Caption 2',
        ),
        'mobileCaption2': (
          SldsTextStyleToken(fontSize: 11, lineHeight: 20, fontWeight: 400),
          'Mobile/Caption 2',
        ),
        'mobileDisplay1': (
          SldsTextStyleToken(
            fontSize: 36,
            lineHeight: 44,
            fontWeight: 500,
            letterSpacing: -2,
          ),
          'Mobile/Display 1',
        ),
        'display2': (
          SldsTextStyleToken(
            fontSize: 44,
            lineHeight: 56,
            fontWeight: 700,
            letterSpacing: -0.3,
          ),
          'Desktop/Display 2',
        ),
        'heading4': (
          SldsTextStyleToken(
            fontSize: 24,
            lineHeight: 32,
            fontWeight: 500,
            letterSpacing: -0.1,
          ),
          'Desktop/Heading 4',
        ),
        'title1': (
          SldsTextStyleToken(fontSize: 18, lineHeight: 24, fontWeight: 500),
          'Mobile/Title 1',
        ),
        'heading1': (
          SldsTextStyleToken(fontSize: 26, lineHeight: 28, fontWeight: 500),
          'Mobile/Heading 1',
        ),
        'heading2': (
          SldsTextStyleToken(fontSize: 24, lineHeight: 32, fontWeight: 500),
          'Mobile/Heading 2',
        ),
        'desktopHeading2': (
          SldsTextStyleToken(
            fontSize: 28,
            lineHeight: 40,
            fontWeight: 700,
            letterSpacing: -0.2,
          ),
          'Desktop/Heading 2',
        ),
        'heading3': (
          SldsTextStyleToken(
            fontSize: 22,
            lineHeight: 36,
            fontWeight: 700,
            letterSpacing: -0.5,
          ),
          'Mobile/Heading 3',
        ),
        'desktopTitle1': (
          SldsTextStyleToken(fontSize: 18, lineHeight: 28, fontWeight: 500),
          'Desktop/Title 1',
        ),
      };

      final actual = <String, SldsTextStyleToken>{
        'bottomNavigationLabel': t.bottomNavigationLabel,
        'snackbarCaption': t.snackbarCaption,
        'body1': t.body1,
        'body2': t.body2,
        'caption1': t.caption1,
        'caption2': t.caption2,
        'mobileCaption2': t.mobileCaption2,
        'mobileDisplay1': t.mobileDisplay1,
        'display2': t.display2,
        'heading4': t.heading4,
        'title1': t.title1,
        'heading1': t.heading1,
        'heading2': t.heading2,
        'desktopHeading2': t.desktopHeading2,
        'heading3': t.heading3,
        'desktopTitle1': t.desktopTitle1,
      };

      for (final entry in expected.entries) {
        final (style, figmaName) = entry.value;
        expect(
          actual[entry.key],
          style,
          reason:
              '${entry.key} no longer matches Figma $figmaName. Update the '
              'token to the spec, or update this expectation if design '
              'changed the style.',
        );
      }
    });

    // fieldLabel/compactLabel/compactDescription have no Figma text style of
    // their own — they are component-level aliases that reuse an existing
    // scale entry. Pinned so a change to them stays a deliberate act.
    test('component-level styles alias the scale they were derived from', () {
      const t = SldsRawTypographyTokens.standard;

      expect(t.fieldLabel, t.body1, reason: 'fieldLabel mirrors Mobile/Body 1');
      expect(
        t.compactLabel,
        t.body1,
        reason: 'compactLabel mirrors Mobile/Body 1',
      );
      expect(
        t.compactDescription,
        t.body2,
        reason: 'compactDescription mirrors Desktop/Body 2',
      );
    });
  });

  group('SldsMotionTokens', () {
    test('reducedMotion collapses both durations to zero', () {
      const motion = SldsMotionTokens(reducedMotion: true);

      expect(motion.fast, Duration.zero);
      expect(motion.normal, Duration.zero);
    });

    test('durations pass through when motion is not reduced', () {
      const motion = SldsMotionTokens(reducedMotion: false);

      expect(motion.fast, const Duration(milliseconds: 120));
      expect(motion.normal, const Duration(milliseconds: 180));
    });

    test('equality accounts for the reducedMotion flag', () {
      expect(
        const SldsMotionTokens(reducedMotion: false),
        isNot(const SldsMotionTokens(reducedMotion: true)),
      );
    });
  });

  group('SldsRawTokenSet', () {
    test('same-theme sets are equal', () {
      expect(SldsRawTokenSet.light(), SldsRawTokenSet.light());
      expect(
        SldsRawTokenSet.light().hashCode,
        SldsRawTokenSet.light().hashCode,
      );
    });

    test('different themes are not equal', () {
      expect(SldsRawTokenSet.light(), isNot(SldsRawTokenSet.dark()));
    });

    test('reducedMotion participates in equality', () {
      expect(
        SldsRawTokenSet.light(),
        isNot(SldsRawTokenSet.light(reducedMotion: true)),
      );
    });

    test('every theme shares the dimension and type scales', () {
      expect(
        SldsRawTokenSet.dark().dimensions,
        SldsRawTokenSet.light().dimensions,
      );
      expect(
        SldsRawTokenSet.dark().typography,
        SldsRawTokenSet.light().typography,
      );
    });
  });
}
