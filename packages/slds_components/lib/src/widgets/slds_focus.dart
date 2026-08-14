import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// The SLDS focus indicator, as a [BoxShadow] list.
///
/// Two concentric rings: a solid stroke in `focusRing`, which is the part
/// that carries the WCAG 2.2 non-text contrast requirement (1.4.11, 3:1
/// against adjacent colours), and a softer `focusHalo` glow outside it that
/// gives the indicator its SLDS character. Ordering matters — the stroke is
/// listed first so it paints closest to the control.
///
/// Pass [error] for destructive or invalid controls, which use the error
/// ring tokens instead.
List<BoxShadow> sldsFocusRing(SldsTokenSet tokens, {bool error = false}) {
  final colors = tokens.colors;
  final spread = tokens.dimensions.focusRingSpread;
  return [
    BoxShadow(
      color: error ? colors.focusRingError : colors.focusRing,
      spreadRadius: spread,
    ),
    BoxShadow(
      color: error ? colors.focusHaloError : colors.focusHalo,
      spreadRadius: spread * 2,
    ),
  ];
}

/// Wraps [child] in a focus indicator that appears when [focused] is true.
///
/// Use this for controls that paint their own container. It keeps the
/// indicator's geometry and colour in one place, so a control does not have
/// to reimplement WCAG 2.2 Focus Appearance itself.
class SldsFocusRing extends StatelessWidget {
  /// Creates a focus indicator around [child].
  const SldsFocusRing({
    required this.focused,
    required this.child,
    super.key,
    this.borderRadius,
    this.error = false,
  });

  /// Whether the wrapped control currently has focus.
  final bool focused;

  /// The control to outline.
  final Widget child;

  /// Corner radius of the indicator. Defaults to a fully rounded ring.
  final BorderRadius? borderRadius;

  /// Whether to use the error ring tokens.
  final bool error;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius:
            borderRadius ?? BorderRadius.circular(tokens.dimensions.radiusFull),
        boxShadow: focused ? sldsFocusRing(tokens, error: error) : null,
      ),
      child: child,
    );
  }
}
