import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

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
    super.key,
    required this.title,
    required this.body,
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
        final requestedWidth = width ??
            (constraints.hasBoundedWidth ? constraints.maxWidth : figmaReferenceWidth);
        final resolvedWidth = constraints.hasBoundedWidth
            ? requestedWidth.clamp(0.0, constraints.maxWidth).toDouble()
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
                    Text(body, style: tokens.typography.body2.copyWith(color: colors.textSecondary)),
                    if (timestamp != null) ...[
                      SizedBox(height: dimensions.space8),
                      Text(
                        timestamp!,
                        style: tokens.typography.caption1.copyWith(color: colors.textTertiary),
                      ),
                    ],
                    if (actionLabel != null) ...[
                      SizedBox(height: dimensions.space12),
                      SldsButtonInline(label: actionLabel!, onPressed: onAction),
                    ],
                  ],
                ),
              ),
              if (unread) ...[
                SizedBox(width: dimensions.space8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: colors.info, shape: BoxShape.circle),
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
        alignment: Alignment.centerRight,
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
      SldsNotificationType.document => (colors.surfaceCard, colors.textPrimary, Icons.description_outlined),
      SldsNotificationType.warning => (colors.badgePendingBackground, colors.badgePendingText, Icons.warning_amber_rounded),
      SldsNotificationType.success => (colors.badgeSuccessBackground, colors.badgeSuccessText, Icons.check_circle_outline),
      SldsNotificationType.error => (colors.badgeErrorBackground, colors.badgeErrorText, Icons.cancel_outlined),
    };

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: type == SldsNotificationType.document ? Border.all(color: colors.borderDecorative) : null,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 20, color: foreground),
    );
  }
}

/// Minimal gold pill button matching the reference's inline "Download"
/// action — kept private/inline rather than reusing [SldsButton] because
/// this needs a compact, non-full-width footprint regardless of mobile
/// breakpoint, which [SldsButton] doesn't offer.
class SldsButtonInline extends StatelessWidget {
  const SldsButtonInline({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return Material(
      color: colors.buttonPrimaryBackground,
      borderRadius: BorderRadius.circular(dimensions.radiusMd),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(dimensions.radiusMd),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: dimensions.space16, vertical: dimensions.space8),
          child: Text(
            label,
            style: tokens.typography.body2.copyWith(
              color: colors.textStaticBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
