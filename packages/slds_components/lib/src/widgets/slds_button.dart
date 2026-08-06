import 'package:flutter/material.dart';

import '../l10n/gen/slds_localizations.dart';
import '../tokens/slds_colors.dart';
import '../tokens/slds_spacing.dart';

/// Visual style of an [SldsButton], matching the SLDS action catalogue.
enum SldsButtonVariant {
  /// Filled, highest emphasis. Main call to action.
  primary,

  /// Outlined, paired with primary.
  secondary,

  /// Outlined, low-emphasis / ghost.
  tertiary,

  /// No border, no background.
  text,

  /// Filled, for delete/reject actions.
  destructive,
}

/// SLDS action button — covers the Primary / Secondary / Tertiary / Text /
/// Destructive variants, with hover, focus, and pressed states handled
/// natively via [WidgetStateProperty], plus an explicit loading state
/// (Flutter buttons have no built-in equivalent).
///
/// Colors resolve from the ambient [Theme]'s [ColorScheme] — installing
/// [SldsTheme.light]/[SldsTheme.dark] means this button follows light/dark
/// mode automatically. Pass [color] to override the accent for one instance
/// without forking the widget (e.g. a one-off brand moment); leave it null
/// to use the SLDS token.
///
/// The loading state reads [SldsLocalizations], so the host app's
/// `MaterialApp` must include `SldsLocalizations.localizationsDelegates` /
/// `.supportedLocales` (merge them into your own lists if you have other
/// localized packages).
class SldsButton extends StatelessWidget {
  const SldsButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = SldsButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final SldsButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;

  /// Overrides the token-driven accent color for this instance only.
  final Color? color;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final content = isLoading
        ? Semantics(
            label: SldsLocalizations.of(context).loading,
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(_foreground(context, selected: true)),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18),
                const SizedBox(width: SldsSpacing.xs),
              ],
              Text(label),
              if (trailingIcon != null) ...[
                const SizedBox(width: SldsSpacing.xs),
                Icon(trailingIcon, size: 18),
              ],
            ],
          );

    return _styledButton(context, content);
  }

  ButtonStyle _buildStyle(
    BuildContext context, {
    required EdgeInsets padding,
    required OutlinedBorder shape,
  }) {
    return ButtonStyle(
      padding: WidgetStatePropertyAll(padding),
      shape: WidgetStatePropertyAll(shape),
      backgroundColor: WidgetStateProperty.resolveWith((states) => _background(context, states)),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => _foreground(context, selected: !states.contains(WidgetState.disabled)),
      ),
      side: WidgetStateProperty.resolveWith((states) => _border(context, states)),
      overlayColor: WidgetStateProperty.resolveWith((states) => _overlay(context, states)),
    );
  }

  Widget _styledButton(BuildContext context, Widget content) {
    final style = _buildStyle(
      context,
      padding: const EdgeInsets.symmetric(horizontal: SldsSpacing.lg, vertical: SldsSpacing.md),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SldsSpacing.sm)),
    );

    switch (variant) {
      case SldsButtonVariant.primary:
      case SldsButtonVariant.destructive:
        return FilledButton(onPressed: _enabled ? onPressed : null, style: style, child: content);
      case SldsButtonVariant.secondary:
      case SldsButtonVariant.tertiary:
        return OutlinedButton(onPressed: _enabled ? onPressed : null, style: style, child: content);
      case SldsButtonVariant.text:
        return TextButton(onPressed: _enabled ? onPressed : null, style: style, child: content);
    }
  }

  /// The resolved accent color: [color] override, else the token driven by
  /// the ambient [ColorScheme] (so it flips with light/dark mode).
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

  Color? _background(BuildContext context, Set<WidgetState> states) {
    if (variant == SldsButtonVariant.secondary ||
        variant == SldsButtonVariant.tertiary ||
        variant == SldsButtonVariant.text) {
      return null; // outlined/text styles stay transparent at rest
    }
    final base = _baseColor(context);
    if (states.contains(WidgetState.disabled)) {
      return base.withValues(alpha: SldsColors.disabledOpacity);
    }
    if (states.contains(WidgetState.pressed)) {
      return Color.lerp(base, Colors.black, 0.16);
    }
    if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
      return Color.lerp(base, Colors.black, 0.08);
    }
    return base;
  }

  Color _foreground(BuildContext context, {required bool selected}) {
    final isFilled = variant == SldsButtonVariant.primary || variant == SldsButtonVariant.destructive;
    if (!selected) {
      return Theme.of(context).colorScheme.onSurface.withValues(alpha: SldsColors.disabledOpacity);
    }
    return isFilled ? _onBaseColor(context) : _baseColor(context);
  }

  BorderSide? _border(BuildContext context, Set<WidgetState> states) {
    if (variant != SldsButtonVariant.secondary && variant != SldsButtonVariant.tertiary) {
      return null;
    }
    final outline = Theme.of(context).colorScheme.outline;
    if (states.contains(WidgetState.disabled)) {
      return BorderSide(color: outline.withValues(alpha: SldsColors.disabledOpacity));
    }
    final color = variant == SldsButtonVariant.tertiary ? outline : _baseColor(context);
    return BorderSide(color: color);
  }

  Color _overlay(BuildContext context, Set<WidgetState> states) {
    final isFilled = variant == SldsButtonVariant.primary || variant == SldsButtonVariant.destructive;
    final base = isFilled ? _onBaseColor(context) : _baseColor(context);
    if (states.contains(WidgetState.pressed)) return base.withValues(alpha: 0.12);
    if (states.contains(WidgetState.hovered)) return base.withValues(alpha: 0.08);
    if (states.contains(WidgetState.focused)) return base.withValues(alpha: 0.10);
    return Colors.transparent;
  }
}
