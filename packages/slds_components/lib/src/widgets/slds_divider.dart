import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart'
    show SldsButton, SldsButtonSize, SldsButtonVariant;
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart'
    show SldsButton, SldsButtonSize, SldsButtonVariant;

/// SLDS divider — a thin horizontal rule (Figma "Default"), or, with
/// [child] set, a rule split around centered content (e.g. an "or" label
/// between two sign-in options).
///
/// For Figma's "With Button" variant (node 502:3758) specifically, use
/// [SldsDivider.withButton] rather than building your own [SldsButton] and
/// passing it as [child]: Figma specifies that button's exact style — ghost
/// label colour, 16px leading `+`, the Small button scale (28px tall) — and
/// a hand-built one is exactly where that spec drifts (a prior widgetbook
/// demo left off `size: SldsButtonSize.small` and rendered the button at
/// 2-3x Figma's height). The named constructor gets it right once, in one
/// place, instead of leaving every caller to reconstruct the spec.
///
/// Responsive by construction: both rule segments are `Expanded`, so it
/// always fills whatever width its parent gives it.
class SldsDivider extends StatelessWidget {
  /// Creates a divider, optionally split around [child].
  const SldsDivider({super.key, this.child});

  /// Creates a divider split around a centered "+ [buttonLabel]" button,
  /// styled exactly to Figma's "With Button" variant (502:3758).
  factory SldsDivider.withButton({
    required String buttonLabel,
    required VoidCallback onButtonPressed,
    Key? key,
  }) => SldsDivider(
    key: key,
    child: SldsButton(
      label: buttonLabel,
      onPressed: onButtonPressed,
      variant: SldsButtonVariant.tertiary,
      size: SldsButtonSize.small,
      leadingIcon: Icons.add,
    ),
  );

  /// Centered content splitting the rule (e.g. a [Text] or the button
  /// [SldsDivider.withButton] builds). Null renders a single unbroken line.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final dimensions = tokens.dimensions;
    final lineColor = tokens.colors.borderDefault;

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
