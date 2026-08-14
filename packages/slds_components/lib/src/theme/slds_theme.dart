import 'package:flutter/material.dart';

import 'slds_design_tokens.dart';

/// Builds the [ThemeData] SLDS apps install as `MaterialApp.theme`,
/// `.darkTheme` and `.highContrastTheme`.
///
/// Every entry point is a cached `static final`, not a method: a method would
/// build a new [ThemeData] — re-running every token lookup — on each call,
/// including calls made from inside a consuming app's `build`.
///
/// ```dart
/// MaterialApp(
///   theme: SldsTheme.light,
///   darkTheme: SldsTheme.dark,
///   highContrastTheme: SldsTheme.highContrast,
///   highContrastDarkTheme: SldsTheme.highContrast,
///   localizationsDelegates: SldsLocalizations.localizationsDelegates,
///   supportedLocales: SldsLocalizations.supportedLocales,
/// )
/// ```
abstract final class SldsTheme {
  /// The light theme.
  static final ThemeData light = _theme(SldsTokenSet.light(), Brightness.light);

  /// The dark theme.
  static final ThemeData dark = _theme(SldsTokenSet.dark(), Brightness.dark);

  /// The high-contrast theme.
  ///
  /// Wire this to both `highContrastTheme` and `highContrastDarkTheme`: the
  /// palette is built for maximum contrast rather than for a light or dark
  /// aesthetic, so it serves either OS setting.
  static final ThemeData highContrast = _theme(
    SldsTokenSet.highContrast(),
    Brightness.light,
  );

  /// Maps SLDS colour tokens onto every [ColorScheme] role the library's
  /// components touch.
  ///
  /// Built by listing roles explicitly rather than via [ColorScheme.fromSeed]:
  /// a seeded scheme derives most roles from a tonal algorithm, so any role
  /// not named would silently render in a Material-derived colour instead of
  /// an SLDS one. `slds_theme_test.dart` asserts no role here equals the
  /// corresponding Flutter factory default.
  static ColorScheme _colorScheme(SldsTokenSet tokens, Brightness brightness) {
    final colors = tokens.colors;
    return ColorScheme(
      brightness: brightness,
      primary: colors.buttonPrimaryBackground,
      onPrimary: colors.buttonPrimaryLabel,
      primaryContainer: colors.surfacePrimary,
      onPrimaryContainer: colors.textPrimary,
      secondary: colors.buttonSecondaryBackground,
      onSecondary: colors.buttonSecondaryLabel,
      secondaryContainer: colors.surfaceRaised,
      onSecondaryContainer: colors.textPrimary,
      tertiary: colors.summaryBoxAccent,
      onTertiary: colors.textStaticBlack,
      tertiaryContainer: colors.listBackground,
      onTertiaryContainer: colors.textPrimary,
      error: colors.error,
      onError: colors.buttonDestructiveLabel,
      errorContainer: colors.badgeErrorBackground,
      onErrorContainer: colors.badgeErrorText,
      surface: colors.surfaceCard,
      onSurface: colors.textPrimary,
      surfaceDim: colors.surfacePage,
      surfaceBright: colors.surfaceCard,
      surfaceContainerLowest: colors.surfaceCard,
      surfaceContainerLow: colors.surfacePage,
      surfaceContainer: colors.surfaceRaised,
      surfaceContainerHigh: colors.surfaceHover,
      surfaceContainerHighest: colors.surfaceHover,
      onSurfaceVariant: colors.textSecondary,
      outline: colors.borderDefault,
      outlineVariant: colors.borderDecorative,
      shadow: colors.shadowColor,
      scrim: colors.shadowColor,
      // Inverse roles back the snackbar, which paints light-on-dark in the
      // light theme and the reverse in dark.
      inverseSurface: colors.tooltipBackground,
      onInverseSurface: colors.tooltipText,
      inversePrimary: colors.buttonPrimaryHover,
    );
  }

  static ThemeData _theme(SldsTokenSet tokens, Brightness brightness) {
    final colorScheme = _colorScheme(tokens, brightness);
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: tokens.typography.materialTextTheme,
      scaffoldBackgroundColor: colors.surfacePage,
      cardTheme: CardThemeData(
        color: colors.surfaceCard,
        margin: EdgeInsets.all(dimensions.space12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dimensions.radiusLg),
          side: BorderSide(color: colors.cardBorder),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: dimensions.space16,
            vertical: dimensions.space12,
          ),
        ),
      ),
    );
  }
}

/// Applies the SLDS token set matching the ambient [Theme] to [child].
///
/// The type scale is theme-independent, so this no longer swaps text styles
/// by width — [SldsTheme] carries the full scale. It remains as the documented
/// place to wrap `MaterialApp.builder`, and as the compatibility point for
/// apps already installing it.
///
/// ```dart
/// MaterialApp(
///   theme: SldsTheme.light,
///   builder: (context, child) => SldsResponsiveText(child: child!),
/// )
/// ```
class SldsResponsiveText extends StatelessWidget {
  /// Wraps [child].
  const SldsResponsiveText({super.key, required this.child});

  /// The subtree to wrap.
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
