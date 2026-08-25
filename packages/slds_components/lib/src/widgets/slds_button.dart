import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_focus.dart';

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

/// Size of an [SldsButton], matching the SLDS size ramp.
///
/// Each size carries its own height, radius, padding, icon size and text
/// style — they are not a single scale factor, so they are resolved together
/// from [_SldsButtonMetrics] rather than derived from the height.
enum SldsButtonSize {
  /// 28px. Dense tables and inline actions.
  small,

  /// 36px. Compact toolbars.
  medium,

  /// 48px. The desktop default.
  large,

  /// 56px. The mobile default, sized for touch.
  extraLarge,
}

/// The resolved per-size geometry for one [SldsButtonSize].
@immutable
class _SldsButtonMetrics {
  const _SldsButtonMetrics({
    required this.height,
    required this.radius,
    required this.padding,
    required this.gap,
    required this.iconSize,
    required this.textStyle,
  });

  /// Resolves the metrics for [size] from the ambient token set.
  factory _SldsButtonMetrics.of(BuildContext context, SldsButtonSize size) {
    final tokens = context.slds;
    final d = tokens.dimensions;
    final t = tokens.typography;
    // The text container carries a 6px horizontal pad of its own in Figma,
    // which is folded into the gap here rather than modelled as a second box.
    final textPad = d.space6;
    return switch (size) {
      SldsButtonSize.small => _SldsButtonMetrics(
        height: d.buttonHeightSmall,
        radius: d.radiusXl,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: d.space8,
          vertical: d.space4,
        ),
        gap: d.space0 + textPad,
        iconSize: d.iconSizeSmall,
        textStyle: t.body2,
      ),
      SldsButtonSize.medium => _SldsButtonMetrics(
        height: d.buttonHeightMedium,
        radius: d.radiusXl,
        padding: EdgeInsetsDirectional.all(d.space8),
        gap: d.space0 + textPad,
        iconSize: d.iconSizeMedium,
        textStyle: t.body1,
      ),
      SldsButtonSize.large => _SldsButtonMetrics(
        height: d.buttonHeightLarge,
        radius: d.radius2xl,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: d.space16,
          vertical: d.space12,
        ),
        gap: d.space4 + textPad,
        iconSize: d.iconSizeMedium,
        textStyle: t.title1,
      ),
      SldsButtonSize.extraLarge => _SldsButtonMetrics(
        height: d.buttonHeightExtraLarge,
        radius: d.radius2xl,
        padding: EdgeInsetsDirectional.all(d.space16),
        gap: d.space4 + textPad,
        iconSize: d.iconSizeLarge,
        textStyle: t.title1,
      ),
    };
  }

  final double height;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double gap;
  final double iconSize;
  final TextStyle textStyle;
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
class SldsButton extends StatefulWidget {
  /// Creates an SLDS action button.
  const SldsButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = SldsButtonVariant.primary,
    this.size,
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

  /// Which SLDS size to render.
  ///
  /// Defaults to the responsive pair the SLDS action spec calls for:
  /// [SldsButtonSize.extraLarge] below the mobile breakpoint (a touch-sized
  /// target) and [SldsButtonSize.large] above it. Set this to pin one size
  /// regardless of width — e.g. [SldsButtonSize.small] for a dense table row.
  final SldsButtonSize? size;

  SldsButtonSize _size(BuildContext context) =>
      size ??
      (context.sldsIsMobile ? SldsButtonSize.extraLarge : SldsButtonSize.large);

  /// Optional icon shown before the label.
  final IconData? leadingIcon;

  /// Optional icon shown after the label.
  final IconData? trailingIcon;

  /// Whether to replace the label with a loading indicator.
  final bool isLoading;

  @override
  State<SldsButton> createState() => _SldsButtonState();
}

class _SldsButtonState extends State<SldsButton> {
  /// Whether the button currently owns focus, driving the SLDS focus ring.
  bool _focused = false;

  SldsButtonVariant get variant => widget.variant;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  void _handleFocusChange(bool focused) {
    if (focused == _focused) return;
    setState(() => _focused = focused);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _SldsButtonMetrics.of(context, widget._size(context));
    final content = widget.isLoading
        ? Semantics(
            // liveRegion so the switch into the loading state is announced
            // as it happens, rather than only when focus next lands here.
            liveRegion: true,
            label: context.sldsStrings.loading,
            child: SizedBox(
              width: metrics.iconSize,
              height: metrics.iconSize,
              child: CupertinoActivityIndicator(
                color: _foreground(context, selected: true),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.leadingIcon != null) ...[
                Icon(widget.leadingIcon, size: metrics.iconSize),
                SizedBox(width: metrics.gap),
              ],
              // Flexible so a long/translated label ellipsizes instead of
              // overflowing past the button on a narrow phone.
              Flexible(
                child: Text(widget.label, overflow: TextOverflow.ellipsis),
              ),
              if (widget.trailingIcon != null) ...[
                SizedBox(width: metrics.gap),
                Icon(widget.trailingIcon, size: metrics.iconSize),
              ],
            ],
          );

    return _styledButton(context, content, metrics);
  }

  ButtonStyle _buildStyle(
    BuildContext context, {
    required _SldsButtonMetrics metrics,
    required double minWidth,
  }) {
    return ButtonStyle(
      padding: WidgetStatePropertyAll(metrics.padding),
      textStyle: WidgetStatePropertyAll(metrics.textStyle),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(metrics.radius),
        ),
      ),
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
      // The painted box is exactly the size Figma specifies. Material's
      // default tapTargetSize would inflate anything under 48px back up to
      // 48px, which would silently turn the small and medium sizes into the
      // large one — the touch target is restored separately, in
      // [_buttonForVariant], so it does not distort the visible geometry.
      // Height is a minimum, never a fixed size: at large text scales the
      // label must be able to push the button taller instead of being clipped.
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: WidgetStatePropertyAll(Size(minWidth, metrics.height)),
    );
  }

  Widget _styledButton(
    BuildContext context,
    Widget content,
    _SldsButtonMetrics metrics,
  ) {
    // Full-width is a property of the mobile layout, not of the size ramp:
    // a small button pinned inside a dense desktop table stays intrinsic.
    if (!context.sldsIsMobile) {
      return _buttonForVariant(context, content, metrics, minWidth: 0);
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
          return _buttonForVariant(context, content, metrics, minWidth: 0);
        }
        return SizedBox(
          width: double.infinity,
          child: _buttonForVariant(
            context,
            content,
            metrics,
            minWidth: double.infinity,
          ),
        );
      },
    );
  }

  Widget _buttonForVariant(
    BuildContext context,
    Widget content,
    _SldsButtonMetrics metrics, {
    required double minWidth,
  }) {
    final style = _buildStyle(context, metrics: metrics, minWidth: minWidth);

    final button = switch (variant) {
      SldsButtonVariant.primary ||
      SldsButtonVariant.destructive => FilledButton(
        onPressed: _enabled ? widget.onPressed : null,
        onFocusChange: _handleFocusChange,
        style: style,
        child: content,
      ),
      SldsButtonVariant.secondary ||
      SldsButtonVariant.tertiary => OutlinedButton(
        onPressed: _enabled ? widget.onPressed : null,
        onFocusChange: _handleFocusChange,
        style: style,
        child: content,
      ),
      SldsButtonVariant.text => TextButton(
        onPressed: _enabled ? widget.onPressed : null,
        onFocusChange: _handleFocusChange,
        style: style,
        child: content,
      ),
    };

    // The ring is painted outside the button box rather than as a border, so
    // it does not shift the button's own geometry when focus arrives.
    final ringed = SldsFocusRing(
      focused: _focused,
      borderRadius: BorderRadius.circular(metrics.radius),
      error: variant == SldsButtonVariant.destructive,
      child: button,
    );

    // WCAG 2.5.5 / the SLDS 48px floor. The small and medium sizes paint
    // below 48px by design, so the shortfall is reclaimed as an invisible
    // tap area around the painted box instead of by inflating it.
    final target = context.slds.dimensions.tapTargetMin;
    if (metrics.height >= target) return ringed;
    // A minimum rather than a fixed height, for the same reason as the style
    // above: a 2x text scale must be free to grow past the tap target.
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: target),
      child: Center(heightFactor: 1, child: ringed),
    );
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
