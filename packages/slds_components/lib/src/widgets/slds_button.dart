import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/gen/slds_localizations.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';

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
/// Every colour resolves from the ambient SLDS token set, so the button
/// follows light, dark and high-contrast themes automatically. There is no
/// per-instance colour override: variants are the supported way to change a
/// button's emphasis.
///
/// The loading state reads [SldsLocalizations], so the host app's
/// `MaterialApp` must include `SldsLocalizations.localizationsDelegates` /
/// `.supportedLocales` (merge them into your own lists if you have other
/// localized packages).
///
/// Sized per the SLDS action spec: intrinsic width at desktop widths,
/// full-width below the mobile breakpoint.
class SldsButton extends StatelessWidget {
  /// Creates an SLDS action button.
  const SldsButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = SldsButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
  });

  /// The button's text label.
  final String label;

  /// Called when the button is tapped. Null disables the button.
  final VoidCallback? onPressed;

  /// Which SLDS action variant to render.
  final SldsButtonVariant variant;

  /// Optional icon shown before the label.
  final IconData? leadingIcon;

  /// Optional icon shown after the label.
  final IconData? trailingIcon;

  /// Whether to replace the label with a loading indicator.
  final bool isLoading;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.slds.dimensions;
    final content = isLoading
        ? Semantics(
            // liveRegion so the switch into the loading state is announced
            // as it happens, rather than only when focus next lands here.
            liveRegion: true,
            label: SldsLocalizations.of(context).loading,
            child: SizedBox(
              width: dimensions.iconSizeMedium,
              height: dimensions.iconSizeMedium,
              child: CupertinoActivityIndicator(
                color: _foreground(context, selected: true),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: dimensions.iconSizeMedium),
                SizedBox(width: dimensions.space8),
              ],
              // Flexible so a long/translated label ellipsizes instead of
              // overflowing past the button on a narrow phone.
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
              if (trailingIcon != null) ...[
                SizedBox(width: dimensions.space8),
                Icon(trailingIcon, size: dimensions.iconSizeMedium),
              ],
            ],
          );

    return _styledButton(context, content);
  }

  ButtonStyle _buildStyle(
    BuildContext context, {
    required EdgeInsetsGeometry padding,
    required OutlinedBorder shape,
    required double minWidth,
  }) {
    return ButtonStyle(
      padding: WidgetStatePropertyAll(padding),
      shape: WidgetStatePropertyAll(shape),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => _background(context, states),
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => _foreground(
          context,
          selected: !states.contains(WidgetState.disabled),
        ),
      ),
      side: WidgetStateProperty.resolveWith(
        (states) => _border(context, states),
      ),
      // The per-state backgrounds in [_background] already carry hover, focus
      // and pressed feedback, so Material's own state layer is suppressed
      // rather than tinting a colour the design system has decided.
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      // Both heights clear the 48px minimum touch target, so Material's
      // default tapTargetSize is left alone rather than shrink-wrapped.
      minimumSize: WidgetStatePropertyAll(
        Size(
          minWidth,
          context.sldsIsMobile
              ? context.slds.dimensions.buttonHeightExtraLarge
              : context.slds.dimensions.buttonHeightLarge,
        ),
      ),
    );
  }

  Widget _styledButton(BuildContext context, Widget content) {
    final isMobile = context.sldsIsMobile;
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

  Widget _buttonForVariant(
    BuildContext context,
    Widget content, {
    required double minWidth,
  }) {
    final dimensions = context.slds.dimensions;
    final style = _buildStyle(
      context,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: dimensions.space16,
        vertical: dimensions.space12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dimensions.radiusLg),
      ),
      minWidth: minWidth,
    );

    return switch (variant) {
      SldsButtonVariant.primary ||
      SldsButtonVariant.destructive => FilledButton(
        onPressed: _enabled ? onPressed : null,
        style: style,
        child: content,
      ),
      SldsButtonVariant.secondary ||
      SldsButtonVariant.tertiary => OutlinedButton(
        onPressed: _enabled ? onPressed : null,
        style: style,
        child: content,
      ),
      SldsButtonVariant.text => TextButton(
        onPressed: _enabled ? onPressed : null,
        style: style,
        child: content,
      ),
    };
  }

  /// Resting, hover and pressed backgrounds per variant.
  ///
  /// Each state reads a designed token rather than being derived from the
  /// resting colour, so the palette stays the design team's decision and
  /// holds under the high-contrast theme, where a computed tint would not.
  Color? _background(BuildContext context, Set<WidgetState> states) {
    final colors = context.slds.colors;

    // Text and tertiary are borderless/transparent at rest; their feedback
    // comes from the ghost overlay tokens.
    if (variant == SldsButtonVariant.text ||
        variant == SldsButtonVariant.tertiary) {
      if (states.contains(WidgetState.disabled)) return null;
      if (states.contains(WidgetState.pressed)) {
        return colors.buttonGhostPressed;
      }
      if (states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.focused)) {
        return colors.buttonGhostHover;
      }
      return null;
    }

    if (states.contains(WidgetState.disabled)) return colors.disabledBackground;

    final pressed = states.contains(WidgetState.pressed);
    final hovered =
        states.contains(WidgetState.hovered) ||
        states.contains(WidgetState.focused);

    return switch (variant) {
      SldsButtonVariant.primary when pressed => colors.buttonPrimaryPressed,
      SldsButtonVariant.primary when hovered => colors.buttonPrimaryHover,
      SldsButtonVariant.primary => colors.buttonPrimaryBackground,
      SldsButtonVariant.destructive when pressed =>
        colors.buttonDestructivePressed,
      SldsButtonVariant.destructive when hovered =>
        colors.buttonDestructiveHover,
      SldsButtonVariant.destructive => colors.buttonDestructiveBackground,
      SldsButtonVariant.secondary when pressed => colors.buttonSecondaryPressed,
      SldsButtonVariant.secondary when hovered => colors.buttonSecondaryHover,
      SldsButtonVariant.secondary => colors.buttonSecondaryBackground,
      _ => null,
    };
  }

  Color _foreground(BuildContext context, {required bool selected}) {
    final colors = context.slds.colors;
    if (!selected) return colors.disabledForeground;

    return switch (variant) {
      SldsButtonVariant.primary => colors.buttonPrimaryLabel,
      SldsButtonVariant.destructive => colors.buttonDestructiveLabel,
      SldsButtonVariant.secondary => colors.buttonSecondaryLabel,
      SldsButtonVariant.tertiary ||
      SldsButtonVariant.text => colors.buttonGhostLabel,
    };
  }

  BorderSide? _border(BuildContext context, Set<WidgetState> states) {
    if (variant != SldsButtonVariant.secondary &&
        variant != SldsButtonVariant.tertiary) {
      return null;
    }
    final colors = context.slds.colors;
    final width = context.slds.dimensions.controlBorderWidth;
    if (states.contains(WidgetState.disabled)) {
      return BorderSide(color: colors.disabledBorder, width: width);
    }
    return BorderSide(
      color: variant == SldsButtonVariant.tertiary
          ? colors.borderDefault
          : colors.buttonSecondaryBorder,
      width: width,
    );
  }
}
