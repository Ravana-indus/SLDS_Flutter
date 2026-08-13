import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// Which edge of [SldsTooltip] the pointer tail sticks out of — point it at
/// whatever the tooltip is anchored to.
enum SldsTooltipTailAlignment { start, center, end }

/// SLDS tooltip — a dark card with a triangular pointer tail. Scales from a
/// single-line label (just [title]) up to a full walkthrough step (title +
/// [description] + [stepLabel] + an [actionLabel] button + a close
/// button), each optional field adding a row — pass only what you need.
///
/// This is content + tail only, not a popover; position it yourself (e.g.
/// a [Positioned]/[CompositedTransformFollower] near the anchor widget) and
/// point [tailAlignment] at it.
class SldsTooltip extends StatelessWidget {
  const SldsTooltip({
    super.key,
    required this.title,
    this.description,
    this.stepLabel,
    this.actionLabel,
    this.onAction,
    this.onClose,
    this.tailAlignment = SldsTooltipTailAlignment.start,
    this.width,
  });

  final String title;

  /// Supporting copy under [title]. Null renders the compact label-only
  /// pill (no card padding beyond the label itself).
  final String? description;

  /// Progress text (e.g. "1 of 5") shown beside [actionLabel] — only
  /// meaningful alongside [description].
  final String? stepLabel;

  /// Trailing action button label (e.g. "Action", "Next"). Null hides the
  /// button.
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Null hides the close (×) button — only shown alongside [description].
  final VoidCallback? onClose;

  final SldsTooltipTailAlignment tailAlignment;

  /// Preferred width, clamped to the available parent width. Defaults to
  /// the Figma reference width (360) when the parent is unbounded and
  /// [description] is set; the compact label-only form always sizes to fit
  /// its content instead.
  final double? width;

  bool get _compact => description == null;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    final card = _compact
        ? _CompactCard(title: title)
        : LayoutBuilder(
            builder: (context, constraints) {
              const figmaReferenceWidth = 360.0;
              final requestedWidth =
                  width ??
                  (constraints.hasBoundedWidth
                      ? constraints.maxWidth
                      : figmaReferenceWidth);
              final resolvedWidth = constraints.hasBoundedWidth
                  ? requestedWidth.clamp(0.0, constraints.maxWidth).toDouble()
                  : requestedWidth;

              return _FullCard(
                width: resolvedWidth,
                title: title,
                description: description!,
                stepLabel: stepLabel,
                actionLabel: actionLabel,
                onAction: onAction,
                onClose: onClose,
              );
            },
          );

    final tailAlignmentX = switch (tailAlignment) {
      SldsTooltipTailAlignment.start => -0.8,
      SldsTooltipTailAlignment.center => 0.0,
      SldsTooltipTailAlignment.end => 0.8,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        card,
        Align(
          alignment: Alignment(tailAlignmentX, 0),
          child: Transform.translate(
            offset: const Offset(0, -1),
            child: Transform.rotate(
              angle:
                  0.785398, // 45deg — a square clipped to its top-left corner reads as a triangle.
              child: Container(
                width: dimensions.space12,
                height: dimensions.space12,
                color: colors.tooltipBackground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CompactCard extends StatelessWidget {
  const _CompactCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.space12,
        vertical: dimensions.space8,
      ),
      decoration: BoxDecoration(
        color: colors.tooltipBackground,
        borderRadius: BorderRadius.circular(dimensions.radiusMd),
      ),
      child: Text(
        title,
        style: tokens.typography.caption1.copyWith(color: colors.tooltipText),
      ),
    );
  }
}

class _FullCard extends StatelessWidget {
  const _FullCard({
    required this.width,
    required this.title,
    required this.description,
    this.stepLabel,
    this.actionLabel,
    this.onAction,
    this.onClose,
  });

  final double width;
  final String title;
  final String description;
  final String? stepLabel;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final showFooter = stepLabel != null || actionLabel != null;

    return Container(
      width: width,
      padding: EdgeInsets.all(dimensions.space16),
      decoration: BoxDecoration(
        color: colors.tooltipBackground,
        borderRadius: BorderRadius.circular(dimensions.radiusLg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: tokens.typography.body1.copyWith(
                    color: colors.tooltipText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (onClose != null)
                Semantics(
                  button: true,
                  label: 'Close',
                  child: InkWell(
                    onTap: onClose,
                    borderRadius: BorderRadius.circular(dimensions.radiusFull),
                    child: Icon(
                      Icons.close,
                      size: dimensions.iconSizeMedium,
                      color: colors.tooltipText,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: dimensions.space4),
          Text(
            description,
            style: tokens.typography.body2.copyWith(color: colors.tooltipText),
          ),
          if (showFooter) ...[
            SizedBox(height: dimensions.space12),
            Row(
              children: [
                if (stepLabel != null)
                  Expanded(
                    child: Text(
                      stepLabel!,
                      style: tokens.typography.caption1.copyWith(
                        color: colors.tooltipText,
                      ),
                    ),
                  ),
                if (actionLabel != null)
                  Material(
                    color: colors.surfaceCard,
                    borderRadius: BorderRadius.circular(dimensions.radiusMd),
                    child: InkWell(
                      onTap: onAction,
                      borderRadius: BorderRadius.circular(dimensions.radiusMd),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: dimensions.space12,
                          vertical: dimensions.space6,
                        ),
                        child: Text(
                          actionLabel!,
                          style: tokens.typography.caption1.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
