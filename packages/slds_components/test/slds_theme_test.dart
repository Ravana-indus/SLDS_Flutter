import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  test('SldsTheme.light() wires tokens into ThemeData', () {
    final theme = SldsTheme.light();

    expect(theme.colorScheme.primary, SldsColors.primary);
    expect(theme.colorScheme.error, SldsColors.error);
    expect(theme.textTheme.bodyLarge?.fontSize, SldsTypography.textTheme.bodyLarge?.fontSize);
    expect(theme.useMaterial3, isTrue);
  });
}
