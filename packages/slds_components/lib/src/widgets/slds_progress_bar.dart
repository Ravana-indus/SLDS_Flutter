import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';

/// SLDS progress bar — a continuous, value-based indicator (file uploads,
/// loading tasks, profile completion): a rounded track filled to [value]
/// (0.0-1.0), with an optional percentage label. Fill width animates on
/// change (300ms ease-out).
///
/// Per the Figma spec, never animate progress backwards — if you reset
/// [value] to 0, pass a new [key] at the same time so the widget remounts
/// and snaps instead of animating down.
///
/// Not a loading spinner — [value] must be known/derivable. Use
/// [CircularProgressIndicator] for unknown-duration work.
class SldsProgressBar extends StatelessWidget {
  /// Creates a determinate progress bar.
  const SldsProgressBar({
    required this.value,
    super.key,
    this.showLabel = true,
  });

  /// Progress fraction, 0.0-1.0. Values outside that range are clamped.
  final double value;

  /// Shows the rounded percentage (e.g. "40%") right-aligned after the bar.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final clamped = value.clamp(0.0, 1.0);
    final fill = colors.progressFill;
    final percent = (clamped * 100).round();
    final labelStyle = tokens.typography.body1.copyWith(
      color: colors.textSecondary,
    );

    return Semantics(
      label: context.sldsStrings.progress,
      value: '$percent%',
      child: ExcludeSemantics(
        child: Row(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: colors.progressTrack,
                          borderRadius: BorderRadius.circular(
                            dimensions.radiusFull,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: tokens.motion.normal,
                        curve: Curves.easeOut,
                        height: 6,
                        width: constraints.maxWidth * clamped,
                        decoration: BoxDecoration(
                          color: fill,
                          borderRadius: BorderRadius.circular(
                            dimensions.radiusFull,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (showLabel) ...[
              SizedBox(width: dimensions.space12),
              // Reserve the width of the widest label, "100%", so the bar
              // keeps one length and 100% never wraps — a fixed 40px box
              // (as in Figma) is too narrow for it at 16px.
              Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  Visibility.maintain(
                    visible: false,
                    child: Text('100%', style: labelStyle),
                  ),
                  Text('$percent%', style: labelStyle),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
