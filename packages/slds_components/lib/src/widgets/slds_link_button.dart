import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart' show SldsButton;
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart' show SldsButton;

/// SLDS inline text link — underlined, without button chrome.
///
/// Use inside body copy or wherever an [SldsButton] would be visually too
/// heavy. Thin wrapper over [TextButton] so hover, focus, pressed and
/// disabled resolve natively via [WidgetStateProperty]. Colours resolve from
/// the ambient SLDS token set, so the link follows light, dark and
/// high-contrast themes.
///
/// The link keeps the 48x48 minimum touch target: the underline stays tight
/// to the text, but the tappable area is padded out to the floor. A link set
/// in running text therefore stays reachable without the underline drifting
/// away from the words it belongs to.
class SldsLinkButton extends StatelessWidget {
  /// Creates an inline text link.
  const SldsLinkButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  /// The link text.
  final String label;

  /// Called when the link is tapped. Null disables it.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.slds.colors;
    final dimensions = context.slds.dimensions;

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsetsDirectional.symmetric(horizontal: dimensions.space4),
        ),
        // Height, not width: a link is as wide as its text, but must still be
        // tall enough to hit. Material's own tapTargetSize is left in place
        // rather than shrink-wrapped away.
        minimumSize: WidgetStatePropertyAll(Size(0, dimensions.tapTargetMin)),
        // Hover and pressed feedback comes from the state layer behind the
        // text. The label keeps its own colour throughout: the ghost
        // background tokens are surfaces, and using one as text would put
        // near-white on a near-white card.
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return colors.buttonGhostPressed;
          }
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return colors.buttonGhostHover;
          }
          return null;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.disabledForeground;
          }
          return colors.buttonGhostLabel;
        }),
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }
}
