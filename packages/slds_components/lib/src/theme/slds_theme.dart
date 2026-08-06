import 'package:flutter/material.dart';

import '../tokens/slds_colors.dart';
import '../tokens/slds_spacing.dart';
import '../tokens/slds_typography.dart';

/// Builds the [ThemeData] SLDS apps should install as `MaterialApp.theme`.
abstract final class SldsTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
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

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: SldsTypography.textTheme,
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
