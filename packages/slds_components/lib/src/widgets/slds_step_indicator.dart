import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// SLDS step indicator — a row of equal-width pill segments showing
/// progress through a flow (e.g. a multi-page form), [currentStep] (0-based)
/// segments filled with the accent color, the rest plain. Same visual as
/// [SldsTopNavBar.progress]'s built-in indicator, standalone for use
/// outside a nav bar (e.g. above a form body). Responsive: segments share
/// the row's width equally via [Expanded].
class SldsStepIndicator extends StatelessWidget {
  const SldsStepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.color,
  });

  final int totalSteps;

  /// Number of segments to fill (0-based position — e.g. 3 fills the first
  /// 3 of [totalSteps]).
  final int currentStep;

  /// Overrides the token-driven accent color for filled segments.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final accent = color ?? colors.buttonPrimaryBackground;

    return Row(
      children: [
        for (var i = 0; i < totalSteps; i++) ...[
          if (i > 0) SizedBox(width: dimensions.space8),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: i < currentStep ? accent : colors.borderDefault,
                borderRadius: BorderRadius.circular(dimensions.radiusFull),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
