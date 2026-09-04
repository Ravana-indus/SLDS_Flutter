import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';
import 'package:slds_components/src/widgets/slds_focus.dart';

/// The resolved per-size geometry for one [SldsButtonSize] icon button.
///
/// Kept separate from [SldsButton]'s table on purpose: the box sizes agree,
/// but the icon does not — an icon button stays at 24px for both Large and
/// Extra Large, where a labelled button drops to 20px at Large.
@immutable
class _SldsIconButtonMetrics {
  const _SldsIconButtonMetrics({
    required this.box,
    required this.radius,
    required this.iconSize,
  });

  /// Resolves the metrics for [size] from the ambient token set.
  factory _SldsIconButtonMetrics.of(BuildContext context, SldsButtonSize size) {
    final d = context.slds.dimensions;
    return switch (size) {
      SldsButtonSize.small => _SldsIconButtonMetrics(
        box: d.buttonHeightSmall,
        radius: d.radiusXl,
        iconSize: d.iconSizeSmall,
      ),
      SldsButtonSize.medium => _SldsIconButtonMetrics(
        box: d.buttonHeightMedium,
        radius: d.radiusXl,
        iconSize: d.iconSizeMedium,
      ),
      SldsButtonSize.large => _SldsIconButtonMetrics(
        box: d.buttonHeightLarge,
        radius: d.radius2xl,
        iconSize: d.iconSizeLarge,
      ),
      SldsButtonSize.extraLarge => _SldsIconButtonMetrics(
        box: d.buttonHeightExtraLarge,
        radius: d.radius2xl,
        iconSize: d.iconSizeLarge,
      ),
    };
  }

  /// The square box, both width and height.
  final double box;
  final double radius;
  final double iconSize;
}

/// SLDS icon-only button, sharing the [SldsButtonVariant] palette and the
/// [SldsButtonSize] ramp with [SldsButton].
///
/// Every colour resolves from the ambient SLDS token set, so the button
/// follows light, dark and high-contrast themes automatically, and hover,
/// focus and pressed feedback come from designed tokens rather than
/// Material's computed state layer.
///
/// The touch target clears the 48x48 minimum at every size — the small and
/// medium boxes paint below it and reclaim the difference as an invisible
/// tap area. An icon-only control has no visible text, so [tooltip] doubles
/// as its accessible name — pass one unless the surrounding content already
/// names the action.
class SldsIconButton extends StatefulWidget {
  /// Creates an icon-only button.
  const SldsIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.variant = SldsButtonVariant.primary,
    this.size,
    this.isLoading = false,
    this.tooltip,
  });

  /// The glyph shown in the button.
  final IconData icon;

  /// Called when the button is tapped. Null disables it.
  final VoidCallback? onPressed;

  /// Which SLDS action variant to render.
  final SldsButtonVariant variant;

  /// Which SLDS size to render.
  ///
  /// Defaults to the responsive pair [SldsButton] uses:
  /// [SldsButtonSize.extraLarge] below the mobile breakpoint and
  /// [SldsButtonSize.large] above it.
  final SldsButtonSize? size;

  /// Whether to replace the icon with a loading indicator.
  final bool isLoading;

  /// Accessible name and hover label for the action.
  final String? tooltip;

  SldsButtonSize _size(BuildContext context) =>
      size ??
      (context.sldsIsMobile ? SldsButtonSize.extraLarge : SldsButtonSize.large);

  @override
  State<SldsIconButton> createState() => _SldsIconButtonState();
}

class _SldsIconButtonState extends State<SldsIconButton> {
  /// The button's own focus node, watched to drive the SLDS focus ring.
  ///
  /// IconButton exposes no onFocusChange callback, so the node is owned here
  /// and listened to directly rather than wrapping the button in a second
  /// Focus widget, which would add a stop to the tab order.
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChange);

  /// Whether the button currently owns focus, driving the SLDS focus ring.
  bool _focused = false;

  SldsButtonVariant get variant => widget.variant;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  void _onFocusChange() {
    if (_focusNode.hasFocus == _focused) return;
    setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  /// Resting, hover and pressed backgrounds per variant.
  ///
  /// Each state reads a designed token rather than being derived from the
  /// resting colour, so the palette stays the design team's decision and
  /// holds under the high-contrast theme, where a computed tint would not.
  Color? _background(BuildContext context, Set<WidgetState> states) {
    final colors = context.slds.colors;

    // Ghost variants are transparent at rest; their feedback comes from the
    // ghost overlay tokens.
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
      SldsButtonVariant.destructive => colors.buttonDestructiveLabel,
      SldsButtonVariant.secondary => colors.buttonSecondaryLabel,
      SldsButtonVariant.tertiary ||
      SldsButtonVariant.text => colors.buttonGhostLabel,
      SldsButtonVariant.primary => colors.buttonPrimaryLabel,
    };
  }

  /// Only the secondary variant is outlined — Figma's Ghost has no border.
  BorderSide? _border(BuildContext context, Set<WidgetState> states) {
    if (variant != SldsButtonVariant.secondary) return null;
    final colors = context.slds.colors;
    final width = context.slds.dimensions.controlBorderWidth;
    return BorderSide(
      color: states.contains(WidgetState.disabled)
          ? colors.disabledBorder
          : colors.buttonSecondaryBorder,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _SldsIconButtonMetrics.of(context, widget._size(context));

    final button = IconButton(
      onPressed: _enabled ? widget.onPressed : null,
      focusNode: _focusNode,
      tooltip: widget.isLoading ? context.sldsStrings.loading : widget.tooltip,
      iconSize: metrics.iconSize,
      icon: widget.isLoading
          ? SizedBox(
              width: metrics.iconSize,
              height: metrics.iconSize,
              child: CupertinoActivityIndicator(
                color: _foreground(context, selected: true),
              ),
            )
          : Icon(widget.icon, size: metrics.iconSize),
      style: ButtonStyle(
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
        // The per-state backgrounds above already carry hover, focus and
        // pressed feedback, so Material's own state layer is suppressed
        // rather than tinting a colour the design system has decided.
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        // The painted box is exactly the square Figma specifies; the 48px
        // touch target is restored below so it cannot distort the geometry.
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: WidgetStatePropertyAll(Size(metrics.box, metrics.box)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(metrics.radius),
          ),
        ),
      ),
    );

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
    if (metrics.box >= target) return ringed;
    return SizedBox(
      width: target,
      height: target,
      child: Center(child: ringed),
    );
  }
}
