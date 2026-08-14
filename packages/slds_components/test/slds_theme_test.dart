import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

/// Every [ColorScheme] role the library's components can read.
///
/// Named individually rather than reflected over, so adding a role to Flutter
/// does not silently widen or narrow what this suite checks.
Map<String, Color> _roles(ColorScheme s) => {
  'primary': s.primary,
  'onPrimary': s.onPrimary,
  'primaryContainer': s.primaryContainer,
  'onPrimaryContainer': s.onPrimaryContainer,
  'secondary': s.secondary,
  'onSecondary': s.onSecondary,
  'secondaryContainer': s.secondaryContainer,
  'onSecondaryContainer': s.onSecondaryContainer,
  'tertiary': s.tertiary,
  'onTertiary': s.onTertiary,
  'tertiaryContainer': s.tertiaryContainer,
  'onTertiaryContainer': s.onTertiaryContainer,
  'error': s.error,
  'onError': s.onError,
  'errorContainer': s.errorContainer,
  'onErrorContainer': s.onErrorContainer,
  'surface': s.surface,
  'onSurface': s.onSurface,
  'onSurfaceVariant': s.onSurfaceVariant,
  'outline': s.outline,
  'outlineVariant': s.outlineVariant,
  'shadow': s.shadow,
  'scrim': s.scrim,
  'inverseSurface': s.inverseSurface,
  'onInverseSurface': s.onInverseSurface,
  'inversePrimary': s.inversePrimary,
};

/// Roles whose SLDS token is pure black or white, which Material also uses as
/// its default for that role.
///
/// These are set explicitly in `SldsTheme._colorScheme`; the values merely
/// coincide, so "differs from the factory default" cannot tell a wired role
/// from an unwired one here. Rather than skip them, the suite below pins each
/// to the SLDS token it must resolve to — which still fails if the role is
/// ever dropped from the scheme.
Map<String, Color> _expectedCollisionValues(SldsColorTokens colors) => {
  'onTertiary': colors.textStaticBlack,
  'onError': colors.buttonDestructiveLabel,
  'surface': colors.surfaceCard,
  'onSurface': colors.textPrimary,
  'shadow': colors.shadowColor,
  'scrim': colors.shadowColor,
  'inverseSurface': colors.tooltipBackground,
  'onInverseSurface': colors.tooltipText,
};

void main() {
  group('theme entry points', () {
    test('are cached statics, not rebuilt per access', () {
      // §4: a method here would allocate a new ThemeData — re-running every
      // token lookup — on each call, including calls from inside a build.
      expect(identical(SldsTheme.light, SldsTheme.light), isTrue);
      expect(identical(SldsTheme.dark, SldsTheme.dark), isTrue);
      expect(identical(SldsTheme.highContrast, SldsTheme.highContrast), isTrue);
    });

    test('every variant pins Material 3', () {
      for (final theme in [
        SldsTheme.light,
        SldsTheme.dark,
        SldsTheme.highContrast,
      ]) {
        expect(theme.useMaterial3, isTrue);
      }
    });

    test('light and dark carry the brightness they claim', () {
      expect(SldsTheme.light.brightness, Brightness.light);
      expect(SldsTheme.dark.brightness, Brightness.dark);
    });
  });

  group('ColorScheme role coverage (§4)', () {
    // Any role left unset falls back to Flutter's default Material palette,
    // so a widget reading it would render in a colour the design system
    // never chose. These assert the fallback never happens.
    test('no light role equals the Flutter factory default', () {
      final ours = _roles(SldsTheme.light.colorScheme);
      final fallback = _roles(const ColorScheme.light());
      final pinned = _expectedCollisionValues(SldsColorTokens.light());

      for (final entry in ours.entries) {
        if (pinned.containsKey(entry.key)) {
          expect(
            entry.value,
            pinned[entry.key],
            reason:
                'ColorScheme.${entry.key} must resolve to its SLDS token even '
                'though that token equals Material\'s default',
          );
          continue;
        }
        expect(
          entry.value,
          isNot(fallback[entry.key]),
          reason:
              'ColorScheme.${entry.key} is Material\'s default, not an SLDS '
              'token — set it in SldsTheme._colorScheme',
        );
      }
    });

    test('no dark role equals the Flutter factory default', () {
      final ours = _roles(SldsTheme.dark.colorScheme);
      final fallback = _roles(const ColorScheme.dark());
      final pinned = _expectedCollisionValues(SldsColorTokens.dark());

      for (final entry in ours.entries) {
        if (pinned.containsKey(entry.key)) {
          expect(
            entry.value,
            pinned[entry.key],
            reason:
                'ColorScheme.${entry.key} must resolve to its SLDS token even '
                'though that token equals Material\'s default',
          );
          continue;
        }
        expect(
          entry.value,
          isNot(fallback[entry.key]),
          reason:
              'ColorScheme.${entry.key} is Material\'s default, not an SLDS '
              'token — set it in SldsTheme._colorScheme',
        );
      }
    });

    test('light and dark resolve to genuinely different palettes', () {
      expect(
        SldsTheme.light.colorScheme.surface,
        isNot(SldsTheme.dark.colorScheme.surface),
      );
      expect(
        SldsTheme.light.colorScheme.onSurface,
        isNot(SldsTheme.dark.colorScheme.onSurface),
      );
    });

    test('high contrast is its own palette, not an alias of light', () {
      expect(
        SldsTheme.highContrast.colorScheme.onSurface,
        isNot(SldsTheme.light.colorScheme.onSurface),
      );
    });
  });

  group('typography', () {
    test('ThemeData.textTheme comes from the SLDS type scale', () {
      final scale = SldsTypographyTokens.standard;

      expect(
        SldsTheme.light.textTheme.bodyLarge?.fontSize,
        scale.body1.fontSize,
      );
      expect(
        SldsTheme.light.textTheme.bodyMedium?.fontSize,
        scale.body2.fontSize,
      );
      expect(
        SldsTheme.light.textTheme.titleLarge?.fontSize,
        scale.heading4.fontSize,
      );
    });

    test(
      'every mapped slot carries the bundled font, not a system default',
      () {
        final textTheme = SldsTheme.light.textTheme;

        for (final style in [
          textTheme.displayLarge,
          textTheme.headlineMedium,
          textTheme.titleLarge,
          textTheme.bodyLarge,
          textTheme.labelLarge,
        ]) {
          expect(style?.fontFamily, contains('Google Sans'));
        }
      },
    );
  });
}
