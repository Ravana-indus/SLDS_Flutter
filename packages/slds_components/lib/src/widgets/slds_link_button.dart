import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart' show SldsButton;
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart' show SldsButton;
import 'package:slds_components/src/widgets/slds_focus.dart';

/// Visual style of an [SldsLinkButton].
enum SldsLinkButtonVariant {
  /// Neutral inline link. The default.
  primary,

  /// Red inline link, for destructive actions such as "Remove".
  destructive,
}

/// SLDS inline text link — underlined, without button chrome.
///
/// Use inside body copy or wherever an [SldsButton] would be visually too
/// heavy. Thin wrapper over [TextButton] so hover, focus, pressed and
/// disabled resolve natively via [WidgetStateProperty]. Colours resolve from
/// the ambient SLDS token set, so the link follows light, dark and
/// high-contrast themes.
///
/// Feedback is carried by the label colour itself, which darkens on hover —
/// an inline link has no surface of its own to tint.
///
/// The link keeps the 48x48 minimum touch target: the underline stays tight
/// to the text, but the tappable area is padded out to the floor. A link set
/// in running text therefore stays reachable without the underline drifting
/// away from the words it belongs to.
class SldsLinkButton extends StatefulWidget {
  /// Creates an inline text link.
  const SldsLinkButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = SldsLinkButtonVariant.primary,
  });

  /// The link text.
  final String label;

  /// Called when the link is tapped. Null disables it.
  final VoidCallback? onPressed;

  /// Which SLDS link variant to render.
  final SldsLinkButtonVariant variant;

  @override
  State<SldsLinkButton> createState() => _SldsLinkButtonState();
}

class _SldsLinkButtonState extends State<SldsLinkButton> {
  /// Whether the link currently owns focus, driving the SLDS focus ring.
  bool _focused = false;

  void _handleFocusChange(bool focused) {
    if (focused == _focused) return;
    setState(() => _focused = focused);
  }

  /// The label colour per state.
  ///
  /// Both variants darken on hover rather than gaining a background: Figma
  /// defines no surface for either state, and the ghost background tokens
  /// are surfaces — using one as text would put near-white on a near-white
  /// card.
  Color _foreground(BuildContext context, Set<WidgetState> states) {
    final colors = context.slds.colors;
    if (states.contains(WidgetState.disabled)) return colors.disabledForeground;

    // Pressed reuses the hover colour: Figma defines no separate pressed
    // state for a link, and leaving the press with no feedback at all would
    // be worse than reusing the one designed shift.
    final active =
        states.contains(WidgetState.hovered) ||
        states.contains(WidgetState.focused) ||
        states.contains(WidgetState.pressed);

    return switch (widget.variant) {
      SldsLinkButtonVariant.primary =>
        active ? colors.linkLabelHover : colors.linkLabel,
      SldsLinkButtonVariant.destructive =>
        active ? colors.linkDestructiveLabelHover : colors.linkDestructiveLabel,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;

    final button = TextButton(
      onPressed: widget.onPressed,
      onFocusChange: _handleFocusChange,
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsetsDirectional.symmetric(horizontal: tokens.dimensions.space4),
        ),
        // Height, not width: a link is as wide as its text, but must still be
        // tall enough to hit. Material's own tapTargetSize is left in place
        // rather than shrink-wrapped away.
        minimumSize: WidgetStatePropertyAll(
          Size(0, tokens.dimensions.tapTargetMin),
        ),
        // Figma gives a link no surface in any state, so Material's state
        // layer is suppressed and the feedback lives in the label colour.
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        textStyle: WidgetStatePropertyAll(tokens.typography.body1),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => _foreground(context, states),
        ),
      ),
      child: Text(
        widget.label,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(decoration: TextDecoration.underline),
      ),
    );

    // A link paints no box of its own, so the ring is drawn tight to the
    // text's own radius rather than a button-sized rounded rectangle.
    return SldsFocusRing(
      focused: _focused,
      borderRadius: BorderRadius.circular(tokens.dimensions.radiusSm),
      error: widget.variant == SldsLinkButtonVariant.destructive,
      child: button,
    );
  }
}
