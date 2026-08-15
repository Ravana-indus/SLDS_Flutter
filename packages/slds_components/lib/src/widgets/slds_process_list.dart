import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/slds_components.dart'
    show SldsSummaryBadgeStatus, SldsSummaryList;
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_summary_list.dart'
    show SldsSummaryBadgeStatus, SldsSummaryList;

/// Status of one [SldsProcessStep] — drives the numbered badge's color.
/// Reuses the same tone pairing as [SldsSummaryBadgeStatus] (approved/green
/// for done, pending/yellow for current, neutral/gray for upcoming).
enum SldsProcessStepStatus { done, current, upcoming }

/// One numbered row in an [SldsProcessList].
class SldsProcessStep {
  const SldsProcessStep({
    required this.title,
    required this.description,
    this.status = SldsProcessStepStatus.upcoming,
  });

  final String title;
  final String description;
  final SldsProcessStepStatus status;
}

/// SLDS process list — USWDS-style numbered steps for "how this works" /
/// "what happens next" screens. Renders [steps] in order with a colored
/// numbered badge per [SldsProcessStep.status] and 1px dividers between
/// rows, inside a bordered card (same shell as [SldsSummaryList]).
class SldsProcessList extends StatelessWidget {
  const SldsProcessList({required this.steps, super.key, this.width});

  final List<SldsProcessStep> steps;

  /// Preferred width, clamped to the available parent width. Defaults to
  /// the Figma reference width (480) when the parent is unbounded.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return LayoutBuilder(
      builder: (context, constraints) {
        const figmaReferenceWidth = 480.0;
        final requestedWidth =
            width ??
            (constraints.hasBoundedWidth
                ? constraints.maxWidth
                : figmaReferenceWidth);
        final resolvedWidth = constraints.hasBoundedWidth
            ? requestedWidth.clamp(0.0, constraints.maxWidth)
            : requestedWidth;

        return Container(
          width: resolvedWidth,
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            border: Border.all(color: colors.borderDecorative),
            borderRadius: BorderRadius.circular(dimensions.radius2xl),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < steps.length; i++) ...[
                if (i > 0) Divider(height: 1, color: colors.borderDecorative),
                _ProcessStepTile(index: i + 1, step: steps[i]),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ProcessStepTile extends StatelessWidget {
  const _ProcessStepTile({required this.index, required this.step});

  final int index;
  final SldsProcessStep step;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    final (Color background, Color foreground) = switch (step.status) {
      SldsProcessStepStatus.done => (
        colors.badgeApprovedBackground,
        colors.badgeApprovedText,
      ),
      SldsProcessStepStatus.current => (
        colors.badgePendingBackground,
        colors.badgePendingText,
      ),
      SldsProcessStepStatus.upcoming => (
        colors.disabledBackground,
        colors.disabledForeground,
      ),
    };

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: context.sldsStrings.stepOf(index, step.title, step.description),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dimensions.space16,
          vertical: dimensions.space16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(dimensions.radiusMd),
              ),
              child: Text(
                '$index',
                style: tokens.typography.body1.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: dimensions.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    step.title,
                    style: tokens.typography.body1.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: dimensions.space4),
                  Text(
                    step.description,
                    style: tokens.typography.body2.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
