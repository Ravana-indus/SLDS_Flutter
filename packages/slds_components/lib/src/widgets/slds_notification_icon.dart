import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_path_glyph.dart';

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

    final (Color background, Color foreground, IconData? icon) = switch (type) {
      // Figma's _notificaiton_icon_element Default draws Phosphor FileDoc,
      // painted below; Material has no file glyph with "DOC" on it (#137).
      SldsNotificationType.document => (
        colors.surfaceSunken,
        colors.textPrimary,
        null,
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
      child: icon != null
          ? Icon(
              icon,
              size: dimensions.iconSizeXLarge,
              color: foreground,
              semanticLabel: semanticLabel,
            )
          : SldsPathGlyph(
              path: _fileDoc,
              viewBox: 28,
              size: dimensions.iconSizeXLarge,
              color: foreground,
              semanticLabel: semanticLabel,
            ),
    );
  }
}

/// Phosphor FileDoc (regular), as exported from Figma on a 28x28 grid.
final Path _fileDoc = Path()
  ..moveTo(5.6875, 15.75)
  ..lineTo(3.9375, 15.75)
  ..cubicTo(3.7054, 15.75, 3.4829, 15.8422, 3.3188, 16.0063)
  ..cubicTo(3.1547, 16.1704, 3.0625, 16.3929, 3.0625, 16.625)
  ..lineTo(3.0625, 22.75)
  ..cubicTo(3.0625, 22.9821, 3.1547, 23.2046, 3.3188, 23.3687)
  ..cubicTo(3.4829, 23.5328, 3.7054, 23.625, 3.9375, 23.625)
  ..lineTo(5.6875, 23.625)
  ..cubicTo(6.7318, 23.625, 7.7333, 23.2102, 8.4717, 22.4717)
  ..cubicTo(9.2102, 21.7333, 9.625, 20.7318, 9.625, 19.6875)
  ..cubicTo(9.625, 18.6432, 9.2102, 17.6417, 8.4717, 16.9033)
  ..cubicTo(7.7333, 16.1648, 6.7318, 15.75, 5.6875, 15.75)
  ..close()
  ..moveTo(5.6875, 21.875)
  ..lineTo(4.8125, 21.875)
  ..lineTo(4.8125, 17.5)
  ..lineTo(5.6875, 17.5)
  ..cubicTo(6.2677, 17.5, 6.8241, 17.7305, 7.2343, 18.1407)
  ..cubicTo(7.6445, 18.5509, 7.875, 19.1073, 7.875, 19.6875)
  ..cubicTo(7.875, 20.2677, 7.6445, 20.8241, 7.2343, 21.2343)
  ..cubicTo(6.8241, 21.6445, 6.2677, 21.875, 5.6875, 21.875)
  ..close()
  ..moveTo(24.2298, 21.338)
  ..cubicTo(24.3975, 21.4984, 24.4946, 21.7188, 24.4997, 21.9508)
  ..cubicTo(24.5048, 22.1828, 24.4176, 22.4073, 24.2572, 22.575)
  ..cubicTo(23.9525, 22.903, 23.5841, 23.1653, 23.1744, 23.3458)
  ..cubicTo(22.7648, 23.5264, 22.3226, 23.6214, 21.875, 23.625)
  ..cubicTo(19.9445, 23.625, 18.375, 21.8586, 18.375, 19.6875)
  ..cubicTo(18.375, 17.5164, 19.9445, 15.75, 21.875, 15.75)
  ..cubicTo(22.3226, 15.7536, 22.7648, 15.8486, 23.1744, 16.0292)
  ..cubicTo(23.5841, 16.2097, 23.9525, 16.472, 24.2572, 16.8)
  ..cubicTo(24.4141, 16.9683, 24.4984, 17.1916, 24.4918, 17.4217)
  ..cubicTo(24.4853, 17.6517, 24.3883, 17.8698, 24.2221, 18.0289)
  ..cubicTo(24.0558, 18.188, 23.8336, 18.2752, 23.6035, 18.2716)
  ..cubicTo(23.3734, 18.268, 23.154, 18.1739, 22.9928, 18.0097)
  ..cubicTo(22.8508, 17.8534, 22.6784, 17.7276, 22.4863, 17.64)
  ..cubicTo(22.2941, 17.5524, 22.0861, 17.5047, 21.875, 17.5)
  ..cubicTo(20.9103, 17.5, 20.125, 18.4844, 20.125, 19.6875)
  ..cubicTo(20.125, 20.8906, 20.9103, 21.875, 21.875, 21.875)
  ..cubicTo(22.0861, 21.8703, 22.2941, 21.8226, 22.4863, 21.735)
  ..cubicTo(22.6784, 21.6474, 22.8508, 21.5216, 22.9928, 21.3653)
  ..cubicTo(23.1532, 21.1977, 23.3737, 21.1006, 23.6057, 21.0955)
  ..cubicTo(23.8376, 21.0903, 24.0622, 21.1776, 24.2298, 21.338)
  ..close()
  ..moveTo(14, 15.75)
  ..cubicTo(12.0695, 15.75, 10.5, 17.5164, 10.5, 19.6875)
  ..cubicTo(10.5, 21.8586, 12.0695, 23.625, 14, 23.625)
  ..cubicTo(15.9305, 23.625, 17.5, 21.8586, 17.5, 19.6875)
  ..cubicTo(17.5, 17.5164, 15.9305, 15.75, 14, 15.75)
  ..close()
  ..moveTo(14, 21.875)
  ..cubicTo(13.0353, 21.875, 12.25, 20.8906, 12.25, 19.6875)
  ..cubicTo(12.25, 18.4844, 13.0353, 17.5, 14, 17.5)
  ..cubicTo(14.9647, 17.5, 15.75, 18.4844, 15.75, 19.6875)
  ..cubicTo(15.75, 20.8906, 14.9647, 21.875, 14, 21.875)
  ..close()
  ..moveTo(5.25, 13.125)
  ..cubicTo(5.4821, 13.125, 5.7046, 13.0328, 5.8687, 12.8687)
  ..cubicTo(6.0328, 12.7046, 6.125, 12.4821, 6.125, 12.25)
  ..lineTo(6.125, 4.375)
  ..lineTo(15.75, 4.375)
  ..lineTo(15.75, 9.625)
  ..cubicTo(15.75, 9.8571, 15.8422, 10.0796, 16.0063, 10.2437)
  ..cubicTo(16.1704, 10.4078, 16.3929, 10.5, 16.625, 10.5)
  ..lineTo(21.875, 10.5)
  ..lineTo(21.875, 12.25)
  ..cubicTo(21.875, 12.4821, 21.9672, 12.7046, 22.1313, 12.8687)
  ..cubicTo(22.2954, 13.0328, 22.5179, 13.125, 22.75, 13.125)
  ..cubicTo(22.9821, 13.125, 23.2046, 13.0328, 23.3687, 12.8687)
  ..cubicTo(23.5328, 12.7046, 23.625, 12.4821, 23.625, 12.25)
  ..lineTo(23.625, 9.625)
  ..cubicTo(23.6251, 9.5101, 23.6025, 9.3962, 23.5586, 9.29)
  ..cubicTo(23.5147, 9.1838, 23.4503, 9.0873, 23.3691, 9.0059)
  ..lineTo(17.2441, 2.8809)
  ..cubicTo(17.1627, 2.7997, 17.0662, 2.7353, 16.96, 2.6914)
  ..cubicTo(16.8538, 2.6475, 16.7399, 2.6249, 16.625, 2.625)
  ..lineTo(6.125, 2.625)
  ..cubicTo(5.6609, 2.625, 5.2157, 2.8094, 4.8876, 3.1376)
  ..cubicTo(4.5594, 3.4657, 4.375, 3.9109, 4.375, 4.375)
  ..lineTo(4.375, 12.25)
  ..cubicTo(4.375, 12.4821, 4.4672, 12.7046, 4.6313, 12.8687)
  ..cubicTo(4.7954, 13.0328, 5.0179, 13.125, 5.25, 13.125)
  ..close()
  ..moveTo(17.5, 5.612)
  ..lineTo(20.638, 8.75)
  ..lineTo(17.5, 8.75)
  ..lineTo(17.5, 5.612)
  ..close();
