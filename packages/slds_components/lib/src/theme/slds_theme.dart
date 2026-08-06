import 'package:flutter/material.dart';

import '../tokens/slds_colors.dart';
import '../tokens/slds_spacing.dart';
import '../tokens/slds_typography.dart';

/// Builds the [ThemeData] SLDS apps install as `MaterialApp.theme` /
/// `.darkTheme`. Both are seeded from the same [SldsColors] tokens via
/// [ColorScheme.fromSeed], so dark mode isn't a separate hand-picked
/// palette — swap for GovTech's real dark tokens once published.
///
/// The text scale is Desktop by default; wrap your `MaterialApp` in
/// [SldsResponsiveText] (or call [SldsTypography.of] yourself in a
/// `MaterialApp.builder`) to switch to the Mobile scale under
/// [SldsTypography.breakpoint].
abstract final class SldsTheme {
  static ThemeData light() => _theme(_lightColorScheme, SldsTypography.desktop);

  static ThemeData dark() => _theme(_darkColorScheme, SldsTypography.desktop);

  static ColorScheme get _lightColorScheme => ColorScheme.fromSeed(
        seedColor: SldsColors.primary,
        brightness: Brightness.light,
        primary: SldsColors.primary,
        onPrimary: SldsColors.onPrimary,
        secondary: SldsColors.secondary,
        onSecondary: SldsColors.onSecondary,
        surface: SldsColors.surface,
        onSurface: SldsColors.onSurface,
        error: SldsColors.error,
        onError: SldsColors.onError,
      );

  static ColorScheme get _darkColorScheme => ColorScheme.fromSeed(
        seedColor: SldsColors.primary,
        brightness: Brightness.dark,
        secondary: SldsColors.secondary,
        error: SldsColors.error,
      );

  static ThemeData _theme(ColorScheme colorScheme, TextTheme textTheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        margin: const EdgeInsets.all(SldsSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SldsSpacing.sm),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: SldsSpacing.lg,
            vertical: SldsSpacing.md,
          ),
        ),
      ),
    );
  }
}

/// Swaps the ambient [Theme]'s `textTheme` between [SldsTypography.desktop]
/// and [SldsTypography.mobile] based on the current [MediaQuery] width.
/// Wrap `MaterialApp.builder` (or any subtree) with this:
///
/// ```dart
/// MaterialApp(
///   theme: SldsTheme.light(),
///   darkTheme: SldsTheme.dark(),
///   builder: (context, child) => SldsResponsiveText(child: child!),
///   // ...
/// )
/// ```
class SldsResponsiveText extends StatelessWidget {
  const SldsResponsiveText({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(textTheme: SldsTypography.of(context)),
      child: child,
    );
  }
}
