import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// SLDS divider — a thin horizontal rule, or (with [child]) a rule split
/// around a centered label/button (e.g. "or" between two sign-in options,
/// or Figma's "+ Button" example). Responsive by construction: both rule
/// segments are `Expanded`, so it always fills whatever width its parent
/// gives it.
class SldsDivider extends StatelessWidget {
  const SldsDivider({super.key, this.child, this.color});

  /// Centered content splitting the rule (e.g. a [Text] or [SldsButton]).
  /// Null renders a single unbroken line.
  final Widget? child;

  /// Overrides the token-driven line color for this instance only.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final dimensions = tokens.dimensions;
    final lineColor = color ?? tokens.colors.borderDefault;

    if (child == null) {
      return Divider(height: 1, thickness: 1, color: lineColor);
    }

    return Row(
      children: [
        Expanded(child: Divider(height: 1, thickness: 1, color: lineColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dimensions.space16),
          child: child,
        ),
        Expanded(child: Divider(height: 1, thickness: 1, color: lineColor)),
      ],
    );
  }
}
