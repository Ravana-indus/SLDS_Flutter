import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';

/// Icon-tone for [SldsNotificationCard.type] — drives the leading circle's
/// color pairing. [document] is a neutral file icon on a plain white
/// circle; the rest reuse the matching badge token pair (e.g. [error] uses
/// `badgeErrorBackground`/`Text`).
enum SldsNotificationType { document, warning, success, error }

/// SLDS mobile notification card — leading type icon, title, body, a
/// timestamp, and an optional primary action button. Swipe left to reveal
/// a red delete action (via [Dismissible]) when [onDismissed] is set;
/// otherwise the card is static.
class SldsNotificationCard extends StatelessWidget {
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

  final String title;
  final String body;

  /// e.g. "Today, 12:00pm". Null hides the timestamp line.
  final String? timestamp;

  final SldsNotificationType type;

  /// Shows a small blue dot in the top-right corner when true.
  final bool unread;

  /// Primary action button label (e.g. "Download"). Null hides the button.
  final String? actionLabel;
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
          padding: EdgeInsets.all(dimensions.space16),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            border: Border.all(color: colors.borderDecorative),
            borderRadius: BorderRadius.circular(dimensions.radius2xl),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeIcon(type: type),
              SizedBox(width: dimensions.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: tokens.typography.body1.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: dimensions.space4),
                    Text(
                      body,
                      style: tokens.typography.body2.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    if (timestamp != null) ...[
                      SizedBox(height: dimensions.space8),
                      Text(
                        timestamp!,
                        style: tokens.typography.caption1.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
                    if (actionLabel != null) ...[
                      SizedBox(height: dimensions.space12),
                      // SldsButton is deliberately full-width below the
                      // mobile breakpoint (its own spec) when its parent
                      // gives it bounded width — Wrap hands it unbounded
                      // width instead (like a Row would), so it falls back
                      // to content-sized. IntrinsicWidth doesn't work here:
                      // SldsButton has its own LayoutBuilder inside, and
                      // LayoutBuilder can't answer intrinsic-size queries.
                      Wrap(
                        children: [
                          SldsButton(
                            label: actionLabel!,
                            onPressed: onAction,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (unread) ...[
                SizedBox(width: dimensions.space8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.info,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
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
        padding: EdgeInsets.symmetric(horizontal: dimensions.space20),
        decoration: BoxDecoration(
          color: colors.error,
          borderRadius: BorderRadius.circular(dimensions.radius2xl),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: content,
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type});

  final SldsNotificationType type;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;

    final (Color background, Color foreground, IconData icon) = switch (type) {
      SldsNotificationType.document => (
        colors.surfaceCard,
        colors.textPrimary,
        Icons.description_outlined,
      ),
      SldsNotificationType.warning => (
        colors.badgePendingBackground,
        colors.badgePendingText,
        Icons.warning_amber_rounded,
      ),
      SldsNotificationType.success => (
        colors.badgeSuccessBackground,
        colors.badgeSuccessText,
        Icons.check_circle_outline,
      ),
      SldsNotificationType.error => (
        colors.badgeErrorBackground,
        colors.badgeErrorText,
        Icons.cancel_outlined,
      ),
    };

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: type == SldsNotificationType.document
            ? Border.all(color: colors.borderDecorative)
            : null,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 20, color: foreground),
    );
  }
}
