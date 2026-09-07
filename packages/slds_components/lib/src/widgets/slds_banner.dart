import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';
import 'package:slds_components/src/widgets/slds_icon_button.dart';

/// Severity of an [SldsBanner] — drives the icon, the border and the tinted
/// background as one set.
///
/// The tints reuse the status badge token pairs rather than introducing a
/// parallel `banner/*` palette: Figma's banner backgrounds are already the
/// badge backgrounds to the byte (`#E0F2EC`, `#FFF8D6`, `#FDECEA`), so a
/// second set of tokens would be the same colours under a second name, free
/// to drift apart at the next sync.
enum SldsBannerSeverity {
  /// Something completed. Green.
  success,

  /// Something needs attention before it becomes a problem. Amber.
  warning,

  /// Something failed. Red.
  error,

  /// A neutral notice. Teal on the plain card surface.
  info,
}

/// SLDS notification banner — an inline, non-transient status message with a
/// severity icon, a message, an optional inline action and an optional
/// dismiss button.
///
/// Distinct from `SldsSnackBar`, which floats over the page and times itself
/// out: a banner sits in the layout and stays until the user acts on it. Use
/// it for state the citizen must be able to re-read — a failed submission, a
/// session about to expire — and a snack bar for transient confirmations.
///
/// Colours resolve from the ambient SLDS token set, so the banner follows
/// light, dark and high-contrast themes.
///
/// The banner announces itself as a live region: it usually appears in
/// response to something the user did elsewhere on the page, without focus
/// moving to it, so without this a screen reader user is never told it
/// arrived (§5).
class SldsBanner extends StatelessWidget {
  /// Creates a notification banner.
  const SldsBanner({
    required this.message,
    super.key,
    this.severity = SldsBannerSeverity.info,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
  });

  /// The banner's message.
  final String message;

  /// Which severity to render.
  final SldsBannerSeverity severity;

  /// Inline action label (e.g. "Try again"). Null hides the action, as does
  /// a null [onAction] — an action that does nothing is worse than none.
  final String? actionLabel;

  /// Called when the inline action is tapped.
  final VoidCallback? onAction;

  /// Called when the dismiss button is tapped. Null hides the button, for a
  /// banner the user is not allowed to dismiss.
  final VoidCallback? onDismiss;

  /// The icon, border and background for [severity].
  ///
  /// The border reads the semantic status token rather than Figma's raw hex:
  /// `success` was deliberately darkened from `#1FAA63` to `#00833C` for AA
  /// (see the palette note in `slds_tokens/lib/src/colors.dart`), and
  /// re-importing the Figma value here would quietly undo that.
  (IconData, Color, Color) _tones(SldsColorTokens colors) =>
      switch (severity) {
        SldsBannerSeverity.success => (
          Icons.check_circle,
          colors.success,
          colors.badgeSuccessBackground,
        ),
        SldsBannerSeverity.warning => (
          Icons.error,
          colors.warning,
          colors.badgePendingBackground,
        ),
        SldsBannerSeverity.error => (
          Icons.cancel,
          colors.error,
          colors.badgeErrorBackground,
        ),
        SldsBannerSeverity.info => (
          Icons.info,
          colors.info,
          colors.surfaceCard,
        ),
      };

  /// The width [text] wants on a single unwrapped line, used to decide
  /// whether the actions still fit beside it.
  double _textWidth(BuildContext context, String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }

  /// The width the action and dismiss controls occupy together.
  ///
  /// Measured from the same tokens the controls are built from rather than
  /// laid out twice — they are a fixed-height button and a square icon
  /// button, so their width is arithmetic, not a layout question.
  double _actionsWidth(BuildContext context, {required bool showAction}) {
    final tokens = context.slds;
    final d = tokens.dimensions;
    var width = 0.0;
    if (showAction) {
      // title1 and space16 either side are what SldsButton's Large metrics
      // actually use — measuring with body1 would under-report the width and
      // put the actions on a row they do not fit.
      width +=
          _textWidth(
            context,
            actionLabel!,
            tokens.typography.title1,
          ) +
          d.space16 * 2;
    }
    if (onDismiss != null) width += d.buttonHeightLarge;
    return width;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final (icon, accent, background) = _tones(colors);

    // Warning is the one severity whose message is not textPrimary: on the
    // pale amber tint Figma specifies a darker brown, which is also what
    // clears AA there.
    final messageColor = severity == SldsBannerSeverity.warning
        ? colors.bannerWarningTitle
        : colors.textPrimary;

    final showAction = actionLabel != null && onAction != null;

    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        // The trailing edge carries less padding than the leading one: the
        // dismiss button brings its own inset, so matching 12px both sides
        // would read as lopsided.
        padding: EdgeInsetsDirectional.fromSTEB(
          dimensions.space12,
          dimensions.space8,
          dimensions.space8,
          dimensions.space8,
        ),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            color: accent,
            width: dimensions.controlBorderWidth,
          ),
          borderRadius: BorderRadius.circular(dimensions.radius2xl),
          boxShadow: [
            BoxShadow(
              color: colors.shadowColor.withValues(alpha: 0.12),
              blurRadius: dimensions.elevationBlur,
              spreadRadius: dimensions.elevationSpread,
              offset: Offset(0, dimensions.elevationOffsetY),
            ),
          ],
        ),
        // LayoutBuilder, not Wrap: the actions sit on the message's row
        // while both fit, and drop to their own row when they don't — but
        // the message still needs a *bounded* width in the first case, or
        // Flexible starves it to a few characters per line at 200% text
        // scale. So the fit is measured once and the two layouts are built
        // explicitly.
        child: LayoutBuilder(
          builder: (context, constraints) {
            final messageWidth = _textWidth(
              context,
              message,
              tokens.typography.body2.copyWith(color: messageColor),
            );
            final actionsWidth = _actionsWidth(context, showAction: showAction);
            // The icon and its gutter sit beside the message on both
            // layouts, so they come off the available width either way.
            final leading = dimensions.iconSizeLarge + dimensions.space8;
            // The message is allowed to wrap beside the actions — the Figma
            // banner does exactly that — so the row only fails when what is
            // left for the message is too narrow to read. Below roughly a
            // third of the width it stops being a paragraph and starts
            // breaking mid-word, which is when stacking wins.
            final messageRoom =
                constraints.maxWidth -
                leading -
                dimensions.space8 -
                actionsWidth;
            final fitsOneRow =
                messageRoom >= messageWidth ||
                messageRoom >= constraints.maxWidth / 3;

            final messageRow = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // The icon repeats the severity the colour already carries,
                // so it is decorative to a screen reader — the message text
                // is what gets announced.
                ExcludeSemantics(
                  child: Icon(
                    icon,
                    size: dimensions.iconSizeLarge,
                    color: accent,
                  ),
                ),
                SizedBox(width: dimensions.space8),
                Flexible(
                  child: Text(
                    message,
                    style: tokens.typography.body2.copyWith(
                      color: messageColor,
                    ),
                  ),
                ),
              ],
            );

            final actions = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showAction)
                  SldsButton(
                    label: actionLabel!,
                    onPressed: onAction,
                    variant: SldsButtonVariant.text,
                    size: SldsButtonSize.large,
                  ),
                if (onDismiss != null)
                  SldsIconButton(
                    icon: Icons.close,
                    onPressed: onDismiss,
                    variant: SldsButtonVariant.text,
                    size: SldsButtonSize.large,
                    tooltip: context.sldsStrings.close,
                  ),
              ],
            );

            if (actionsWidth == 0) return messageRow;

            if (fitsOneRow) {
              return Row(
                children: [
                  Flexible(child: messageRow),
                  SizedBox(width: dimensions.space8),
                  actions,
                ],
              );
            }

            // Stacked: the message gets the banner's full width, and the
            // actions sit under it against the trailing edge.
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                messageRow,
                SizedBox(height: dimensions.space4),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: actions,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
