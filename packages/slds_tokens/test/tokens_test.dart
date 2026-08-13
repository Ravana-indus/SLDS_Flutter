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
