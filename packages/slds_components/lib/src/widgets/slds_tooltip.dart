import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';

/// Which edge of [SldsTooltip] the pointer tail sticks out of — point it at
/// whatever the tooltip is anchored to.
enum SldsTooltipTailAlignment { start, center, end }

/// Which edge the pointer tail sticks out of.
enum SldsTooltipTailSide { top, bottom }

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
    required this.title,
    super.key,
    this.description,
    this.stepLabel,
    this.actionLabel,
    this.onAction,
    this.onClose,
    this.tailAlignment = SldsTooltipTailAlignment.start,
    this.tailSide = SldsTooltipTailSide.top,
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
  final SldsTooltipTailSide tailSide;

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
                  ? requestedWidth.clamp(0.0, constraints.maxWidth)
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

    final pointsUp = tailSide == SldsTooltipTailSide.top;
    // Fixed inset from the card edge, not a fraction of its width — a
    // fractional inset drifts as the card grows.
    final tailInset = EdgeInsets.only(
      left: tailAlignment == SldsTooltipTailAlignment.start
          ? dimensions.space16
          : 0,
      right: tailAlignment == SldsTooltipTailAlignment.end
          ? dimensions.space16
          : 0,
    );

    final tail = Padding(
      padding: tailInset,
      child: Align(
        alignment: switch (tailAlignment) {
          SldsTooltipTailAlignment.start => Alignment.centerLeft,
          SldsTooltipTailAlignment.center => Alignment.center,
          SldsTooltipTailAlignment.end => Alignment.centerRight,
        },
        // Overlap the card by 1px so no hairline seam shows between them.
        child: Transform.translate(
          offset: Offset(0, pointsUp ? 1 : -1),
          child: CustomPaint(
            size: Size(dimensions.space16, dimensions.space8),
            painter: _TailPainter(
              color: colors.tooltipBackground,
              pointsUp: pointsUp,
            ),
          ),
        ),
      ),
    );

    final stack = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: pointsUp ? [tail, card] : [card, tail],
    );

    // The compact pill sizes to its text, so the Column needs IntrinsicWidth to
    // hug it — otherwise the tail's Align spans the full parent width and the
    // tail drifts off the pill. The full card resolves its own explicit width,
    // and its LayoutBuilder can't be measured intrinsically anyway.
    return _compact ? IntrinsicWidth(child: stack) : stack;
  }
}

class _TailPainter extends CustomPainter {
  const _TailPainter({required this.color, required this.pointsUp});

  final Color color;
  final bool pointsUp;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (pointsUp) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
    }
    canvas.drawPath(path..close(), Paint()..color = color);
  }

  @override
  bool shouldRepaint(_TailPainter old) =>
      old.color != color || old.pointsUp != pointsUp;
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
                  label: context.sldsStrings.close,
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
