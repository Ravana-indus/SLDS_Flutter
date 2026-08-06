import 'package:flutter/material.dart';

import '../l10n/gen/slds_localizations.dart';
import '../tokens/slds_colors.dart';
import 'slds_button.dart';

/// SLDS icon-only button — same variant palette as [SldsButton], sized for
/// a 44×44 minimum touch target per the SLDS mobile spec. Colors resolve
/// from the ambient [Theme]'s [ColorScheme] (light/dark aware); pass
/// [color] to override the accent for one instance.
class SldsIconButton extends StatelessWidget {
  const SldsIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.variant = SldsButtonVariant.primary,
    this.isLoading = false,
    this.tooltip,
    this.color,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final SldsButtonVariant variant;
  final bool isLoading;
  final String? tooltip;

  /// Overrides the token-driven accent color for this instance only.
  final Color? color;

  bool get _enabled => onPressed != null && !isLoading;
  bool get _isFilled =>
      variant == SldsButtonVariant.primary || variant == SldsButtonVariant.destructive;

  Color _baseColor(BuildContext context) {
    if (color != null) return color!;
    final scheme = Theme.of(context).colorScheme;
    return variant == SldsButtonVariant.destructive ? scheme.error : scheme.primary;
  }

  Color _onBaseColor(BuildContext context) {
    if (color != null) {
      return ThemeData.estimateBrightnessForColor(color!) == Brightness.dark
          ? Colors.white
          : Colors.black;
    }
    final scheme = Theme.of(context).colorScheme;
    return variant == SldsButtonVariant.destructive ? scheme.onError : scheme.onPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = _baseColor(context);
    final onBase = _onBaseColor(context);

    return IconButton(
      onPressed: _enabled ? onPressed : null,
      tooltip: isLoading ? SldsLocalizations.of(context).loading : tooltip,
      icon: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(_isFilled ? onBase : base),
              ),
            )
          : Icon(icon),
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      style: IconButton.styleFrom(
        backgroundColor: _isFilled ? base : Colors.transparent,
        foregroundColor: _isFilled ? onBase : base,
        disabledBackgroundColor:
            _isFilled ? base.withValues(alpha: SldsColors.disabledOpacity) : Colors.transparent,
        disabledForegroundColor: scheme.onSurface.withValues(alpha: SldsColors.disabledOpacity),
        side: !_isFilled && variant != SldsButtonVariant.text
            ? BorderSide(color: variant == SldsButtonVariant.tertiary ? scheme.outline : base)
            : null,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }
}
