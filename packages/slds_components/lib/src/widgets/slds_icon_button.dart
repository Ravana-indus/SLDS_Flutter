import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/gen/slds_localizations.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';

/// SLDS icon-only button, sharing the [SldsButtonVariant] palette with
/// [SldsButton].
///
/// Every colour resolves from the ambient SLDS token set, so the button
/// follows light, dark and high-contrast themes automatically.
///
/// The touch target clears the 48x48 minimum at both breakpoints, and grows
/// on mobile to match [SldsButton]'s height there. An icon-only control has
/// no visible text, so [tooltip] doubles as its accessible name — pass one
/// unless the surrounding content already names the action.
class SldsIconButton extends StatelessWidget {
  /// Creates an icon-only button.
  const SldsIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.variant = SldsButtonVariant.primary,
    this.isLoading = false,
    this.tooltip,
  });

  /// The glyph shown in the button.
  final IconData icon;

  /// Called when the button is tapped. Null disables it.
  final VoidCallback? onPressed;

  /// Which SLDS action variant to render.
  final SldsButtonVariant variant;

  /// Whether to replace the icon with a loading indicator.
  final bool isLoading;

  /// Accessible name and hover label for the action.
  final String? tooltip;

  bool get _enabled => onPressed != null && !isLoading;
  bool get _isFilled =>
      variant == SldsButtonVariant.primary ||
      variant == SldsButtonVariant.destructive;

  Color _background(SldsColorTokens colors) => switch (variant) {
    SldsButtonVariant.destructive => colors.buttonDestructiveBackground,
    SldsButtonVariant.secondary => colors.buttonSecondaryBackground,
    _ => colors.buttonPrimaryBackground,
  };

  Color _foreground(SldsColorTokens colors) => switch (variant) {
    SldsButtonVariant.destructive => colors.buttonDestructiveLabel,
    SldsButtonVariant.secondary => colors.buttonSecondaryLabel,
    SldsButtonVariant.tertiary ||
    SldsButtonVariant.text => colors.buttonGhostLabel,
    _ => colors.buttonPrimaryLabel,
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    // Both clear the 48px floor; the larger mobile target matches
    // SldsButton's height at that breakpoint.
    final size = context.sldsIsMobile
        ? dimensions.buttonHeightExtraLarge
        : dimensions.buttonHeightLarge;

    final foreground = _foreground(colors);

    return IconButton(
      onPressed: _enabled ? onPressed : null,
      tooltip: isLoading ? SldsLocalizations.of(context).loading : tooltip,
      icon: isLoading
          ? SizedBox(
              width: dimensions.iconSizeMedium,
              height: dimensions.iconSizeMedium,
              child: CupertinoActivityIndicator(color: foreground),
            )
          : Icon(icon),
      constraints: BoxConstraints(minWidth: size, minHeight: size),
      style: IconButton.styleFrom(
        backgroundColor: _isFilled ? _background(colors) : null,
        foregroundColor: foreground,
        disabledBackgroundColor: _isFilled ? colors.disabledBackground : null,
        disabledForegroundColor: colors.disabledForeground,
        side: !_isFilled && variant != SldsButtonVariant.text
            ? BorderSide(
                color: variant == SldsButtonVariant.tertiary
                    ? colors.borderDefault
                    : colors.buttonSecondaryBorder,
                width: dimensions.controlBorderWidth,
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dimensions.radiusLg),
        ),
      ),
    );
  }
}
