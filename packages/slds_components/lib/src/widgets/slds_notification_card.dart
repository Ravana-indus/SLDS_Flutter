import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';
import 'package:slds_components/src/widgets/slds_notification_icon.dart';

/// SLDS mobile notification card — leading type icon, title, body, a
/// timestamp, and an optional primary action button. Swipe left to reveal
/// a red delete action (via [Dismissible]) when [onDismissed] is set;
/// otherwise the card is static.
class SldsNotificationCard extends StatelessWidget {
  /// Creates a notification card.
  const SldsNotificationCard({
    required this.title,
    required this.body,
    super.key,
    this.timestamp,
    this.type = SldsNotificationType.document,
    this.unread = false,
    this.actionLabel,
    this.onAction,
    this.onDismissed,
    this.width,
  });

  /// The notification's headline.
  final String title;

  /// The notification's message text.
  final String body;

  /// e.g. "Today, 12:00pm". Null hides the timestamp line.
  final String? timestamp;

  /// Icon tone for the leading circle.
  final SldsNotificationType type;

  /// Shows a small blue dot in the top-right corner when true.
  final bool unread;

  /// Primary action button label (e.g. "Download"). Null hides the button.
  final String? actionLabel;

  /// Called when the action button is tapped.
  final VoidCallback? onAction;

  /// Called with the notification removed after a left swipe reveals the
  /// red delete action and the user releases past the threshold. Null
  /// disables swipe-to-dismiss entirely (a plain, static card).
  final ValueChanged<DismissDirection>? onDismissed;

  /// Preferred width, clamped to the available parent width.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    final content = LayoutBuilder(
      builder: (context, constraints) {
        const figmaReferenceWidth = 375.0;
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
          // Asymmetric by spec: the trailing edge carries half the padding
          // because the unread indicator supplies its own 8px of inset.
          padding: EdgeInsetsDirectional.fromSTEB(
            dimensions.space16,
            dimensions.space16,
            dimensions.space8,
            dimensions.space16,
          ),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            border: Border.all(color: colors.borderDecorative),
            borderRadius: BorderRadius.circular(dimensions.radius2xl),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SldsNotificationIcon(type: type),
              SizedBox(width: dimensions.space16),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: dimensions.space4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: tokens.typography.body2.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: dimensions.space2),
                      Text(
                        body,
                        style: tokens.typography.body2.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      if (timestamp != null) ...[
                        SizedBox(height: dimensions.space2),
                        Text(
                          timestamp!,
                          style: tokens.typography.caption1.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                      if (actionLabel != null) ...[
                        SizedBox(height: dimensions.space8),
                        // SldsButton is deliberately full-width below the
                        // mobile breakpoint (its own spec) when its parent
                        // gives it bounded width, but this card's CTA is
                        // content-sized at every width per the spec. A Row
                        // hands its child unbounded width, so the button
                        // falls back to content-sized — while still passing
                        // vertical constraints through, which keeps the
                        // button's invisible 48px WCAG 2.5.5 tap area intact
                        // (an UnconstrainedBox would collapse it to 30px).
                        // IntrinsicWidth doesn't work here: SldsButton has
                        // its own LayoutBuilder inside, and LayoutBuilder
                        // can't answer intrinsic-size queries.
                        Row(
                          children: [
                            SldsButton(
                              label: actionLabel!,
                              onPressed: onAction,
                              size: SldsButtonSize.small,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (unread)
                Padding(
                  padding: EdgeInsets.all(dimensions.space8),
                  child: Container(
                    // ponytail: literal 14 — no spacing token for it; add
                    // one if a second component needs this dot size.
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: colors.info,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );

    if (onDismissed == null) return content;

    return Dismissible(
      key: key ?? ValueKey(title),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      background: Container(
        // The swipe is endToStart, so the revealed icon has to sit at the
        // end edge — pinning it right would reveal it on the wrong side of
        // an RTL card, opposite the direction the finger moved.
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsets.symmetric(
          horizontal: dimensions.space20,
          vertical: dimensions.space16,
        ),
        decoration: BoxDecoration(
          color: colors.error,
          borderRadius: BorderRadius.circular(dimensions.radius2xl),
        ),
        child: SizedBox(
          width: dimensions.tapTargetMin,
          height: dimensions.tapTargetMin,
          child: Icon(
            Icons.delete_outline,
            size: dimensions.iconSizeLarge,
            color: colors.textInverse,
          ),
        ),
      ),
      child: content,
    );
  }
}
