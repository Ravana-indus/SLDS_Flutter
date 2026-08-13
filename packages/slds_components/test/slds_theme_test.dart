import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  test('SldsTheme.light() wires tokens into ThemeData', () {
    final theme = SldsTheme.light();

    expect(theme.colorScheme.primary, SldsColors.primary);
    expect(theme.colorScheme.error, SldsColors.error);
    expect(
      theme.textTheme.bodyLarge?.fontSize,
      SldsTypography.desktop.bodyLarge?.fontSize,
    );
    expect(theme.useMaterial3, isTrue);
    expect(theme.brightness, Brightness.light);
  });

  test('SldsTheme.dark() produces a dark ColorScheme from the same seed', () {
    final theme = SldsTheme.dark();

    expect(theme.brightness, Brightness.dark);
    expect(theme.useMaterial3, isTrue);
    // Same seed as light, so hue stays close even though tone flips dark.
    expect(theme.colorScheme.primary, isNot(SldsColors.primary));
  });
}
