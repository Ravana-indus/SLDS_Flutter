import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../l10n/gen/slds_localizations.dart';
import '../tokens/slds_breakpoints.dart';
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
///
/// Sized per the SLDS action spec: 44px tall and intrinsic width at/above
/// [SldsBreakpoints.mobile]; 52px tall and full-width below it.
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
              child: CupertinoActivityIndicator(
                color: _foreground(context, selected: true),
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
              // Flexible so a long/translated label ellipsizes instead of
              // overflowing past the button on a narrow phone.
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
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
    required double minWidth,
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
      minimumSize: WidgetStatePropertyAll(Size(minWidth, SldsBreakpoints.isMobile(context) ? 52.0 : 44.0)),
      // Without this, Material pads the tap target to its own 48px a11y
      // minimum regardless of minimumSize, overriding the 44px SLDS spec.
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _styledButton(BuildContext context, Widget content) {
    final isMobile = SldsBreakpoints.isMobile(context);
    if (!isMobile) {
      return _buttonForVariant(context, content, minWidth: 0);
    }
    // Full-width-on-mobile is only valid when the parent actually bounds
    // our width (e.g. a form field's Column) — inside a Row (like a
    // Cancel/Apply footer), children get unconstrained width, so both the
    // minimumSize and the outer SizedBox must fall back to content-sized
    // instead of `double.infinity`, which crashes layout there.
    //
    // LayoutBuilder itself can't sit inside a subtree an ancestor queries
    // for intrinsic dimensions (IntrinsicWidth, an OverflowBar like
    // AlertDialog.actions uses, ...) — it refuses to answer regardless of
    // which branch would run. There's no way to make this widget safe
    // under both an unconstrained-width Row *and* an intrinsic-querying
    // ancestor at the same time, so callers that need SldsButton doing
    // something other than "one button alone in a bounded column" (e.g.
    // dialog footers) should lay their own Row out — see SldsDialog, which
    // builds a plain Row instead of AlertDialog's OverflowBar-based
    // actions for exactly this reason.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth) {
          return _buttonForVariant(context, content, minWidth: 0);
        }
        return SizedBox(
          width: double.infinity,
          child: _buttonForVariant(context, content, minWidth: double.infinity),
        );
      },
    );
  }

  Widget _buttonForVariant(BuildContext context, Widget content, {required double minWidth}) {
    final style = _buildStyle(
      context,
      padding: const EdgeInsets.symmetric(horizontal: SldsSpacing.lg, vertical: SldsSpacing.md),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SldsSpacing.sm)),
      minWidth: minWidth,
    );

    return switch (variant) {
      SldsButtonVariant.primary ||
      SldsButtonVariant.destructive =>
        FilledButton(onPressed: _enabled ? onPressed : null, style: style, child: content),
      SldsButtonVariant.secondary ||
      SldsButtonVariant.tertiary =>
        OutlinedButton(onPressed: _enabled ? onPressed : null, style: style, child: content),
      SldsButtonVariant.text =>
        TextButton(onPressed: _enabled ? onPressed : null, style: style, child: content),
    };
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
    if (variant == SldsButtonVariant.text) {
      return null; // text style stays transparent in both light and dark
    }
    if (variant == SldsButtonVariant.secondary || variant == SldsButtonVariant.tertiary) {
      // Light mode: transparent-with-border. Dark mode: filled with a dark
      // surface tone (per the SLDS dark-mode spec) — border stays too.
      final theme = Theme.of(context);
      if (theme.brightness == Brightness.light) return null;
      final container = theme.colorScheme.surfaceContainerHighest;
      if (states.contains(WidgetState.disabled)) {
        return container.withValues(alpha: SldsColors.disabledOpacity);
      }
      if (states.contains(WidgetState.pressed)) return Color.lerp(container, Colors.white, 0.08);
      if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
        return Color.lerp(container, Colors.white, 0.04);
      }
      return container;
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
