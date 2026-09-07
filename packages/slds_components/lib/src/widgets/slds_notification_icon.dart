import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// Icon-tone for [SldsNotificationIcon] — drives the circle's color
/// pairing. [document] is a neutral file icon on a plain sunken circle;
/// the rest reuse the matching badge token pair (e.g. [error] uses
/// `badgeErrorBackground`/`Text`).
enum SldsNotificationType {
  /// A neutral file/document notice.
  document,

  /// Something needing attention.
  warning,

  /// Something that completed successfully.
  success,

  /// Something that failed.
  error,
}

/// SLDS notification icon — a circular tinted badge carrying the glyph for
/// a [SldsNotificationType]. Used on its own, or as the leading element of
/// an `SldsNotificationCard`.
///
/// Sizing comes from tokens: a 28px glyph inset by 12px on each side, so
/// the circle measures 52px.
class SldsNotificationIcon extends StatelessWidget {
  /// Creates a notification icon.
  const SldsNotificationIcon({
    super.key,
    this.type = SldsNotificationType.document,
    this.semanticLabel,
  });

  /// Icon tone for the circle.
  final SldsNotificationType type;

  /// Screen-reader label. Null leaves the icon decorative — correct when a
  /// neighbouring title already conveys the notification's meaning.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    final (Color background, Color foreground, IconData icon) = switch (type) {
      SldsNotificationType.document => (
        colors.surfaceSunken,
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
      padding: EdgeInsets.all(dimensions.space12),
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        // The document tone sits on a surface the same color as the card
        // behind it, so it needs an outline to read as a circle at all.
        border: type == SldsNotificationType.document
            ? Border.all(color: colors.borderDecorative)
            : null,
      ),
      child: Icon(
        icon,
        size: dimensions.iconSizeXLarge,
        color: foreground,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
