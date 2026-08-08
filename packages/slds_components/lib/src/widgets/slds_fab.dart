import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../l10n/gen/slds_localizations.dart';
import '../tokens/slds_breakpoints.dart';
import '../tokens/slds_colors.dart';
import 'slds_button.dart';

/// SLDS floating action button — primary (gold), secondary (outlined
/// white), and destructive (red) variants, matching [SldsButtonVariant].
/// Colors resolve from the ambient [Theme]'s [ColorScheme] (light/dark
/// aware); pass [color] to override for one instance.
///
/// Pass [badgeCount] to overlay a numeric badge (e.g. an unread count);
/// values over 99 display as "99+".
class SldsFab extends StatelessWidget {
  const SldsFab({
    super.key,
    required this.icon,
    required this.onPressed,
    this.variant = SldsButtonVariant.primary,
    this.isLoading = false,
    this.tooltip,
    this.color,
    this.badgeCount,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final SldsButtonVariant variant;
  final bool isLoading;
  final String? tooltip;

  /// Overrides the token-driven accent color for this instance only.
  final Color? color;

  /// Numeric badge shown in the top-right corner; null hides it.
  final int? badgeCount;

  bool get _enabled => onPressed != null && !isLoading;
  bool get _isFilled => variant != SldsButtonVariant.secondary;

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
    final size = SldsBreakpoints.isMobile(context) ? 64.0 : 56.0;

    final icon = this.icon;
    Widget child = isLoading
        ? Semantics(
            label: SldsLocalizations.of(context).loading,
            child: SizedBox(
              width: 20,
              height: 20,
              child: CupertinoActivityIndicator(color: _isFilled ? onBase : base),
            ),
          )
        : Icon(icon, color: _isFilled ? onBase : base);

    if (badgeCount != null) {
      child = Badge.count(
        count: badgeCount!,
        backgroundColor: scheme.error,
        textColor: scheme.onError,
        child: child,
      );
    }

    return Tooltip(
      message: isLoading ? SldsLocalizations.of(context).loading : (tooltip ?? ''),
      child: SizedBox(
        width: size,
        height: size,
        child: _isFilled
            ? FloatingActionButton(
                onPressed: _enabled ? onPressed : null,
                backgroundColor: _enabled
                    ? base
                    : base.withValues(alpha: SldsColors.disabledOpacity),
                disabledElevation: 0,
                elevation: 4,
                child: child,
              )
            : FloatingActionButton(
                onPressed: _enabled ? onPressed : null,
                backgroundColor: scheme.surface,
                foregroundColor: base,
                disabledElevation: 0,
                elevation: 4,
                shape: CircleBorder(
                  side: BorderSide(
                    color: _enabled ? base : scheme.outline.withValues(alpha: SldsColors.disabledOpacity),
                  ),
                ),
                child: child,
              ),
      ),
    );
  }
}
