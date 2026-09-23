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
  (IconData, Color, Color) _tones(SldsColorTokens colors) => switch (severity) {
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
  /// laid out twice — a link is as wide as its text plus its own padding,
  /// and the dismiss button is a fixed square, so their width is
  /// arithmetic, not a layout question.
  double _actionsWidth(BuildContext context, {required bool showAction}) {
    final tokens = context.slds;
    final d = tokens.dimensions;
    var width = 0.0;
    if (showAction) {
      // body1 and space4 either side are what SldsLinkButton actually uses
      // — Figma's Action is a plain underlined link, not an SldsButton.
      width +=
          _textWidth(context, actionLabel!, tokens.typography.body1) +
          d.space4 * 2;
    }
    // Figma's dismiss (459:3194) paints at the Small icon-button scale
    // (28px), but SldsIconButton itself reserves the WCAG 2.5.8 floor
    // around anything below it, so that's the real width this row claims.
    if (onDismiss != null) width += d.tapTargetMin;
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
                dimensions.space24 -
                actionsWidth;
            final fitsOneRow =
                messageRoom >= messageWidth ||
                messageRoom >= constraints.maxWidth / 3;

            final messageRow = Row(
              // Figma's banner (459:3223) is items-center end to end — the
              // icon, message and actions all sit on the row's vertical
              // centre, even when the message wraps to two lines. Aligning
              // the icon to start instead pinned it to the first line only.
              // ignore: avoid_redundant_argument_values
              crossAxisAlignment: CrossAxisAlignment.center,
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
                // Figma's "Action" (LinkButton, node 248:2292) is a plain
                // underlined link, not a button — SldsButton's chrome (a
                // filled/outlined box) was visually far heavier than spec.
                //
                // Not SldsLinkButton: its default grey (colors.linkLabel) is
                // tuned for AA on the plain page background, and only
                // clears 4.2:1 / 4.3:1 on the success/error tints here —
                // under WCAG 1.4.3's 4.5:1 floor. messageColor already
                // carries the right colour per severity (textPrimary, or
                // the warning-specific dark brown), so the action reuses it
                // rather than SldsLinkButton reaching for architecture
                // sign-off to add a colour override this is the only
                // caller of.
                if (showAction)
                  _BannerActionLink(
                    label: actionLabel!,
                    onPressed: onAction,
                    color: messageColor,
                  ),
                if (onDismiss != null)
                  SldsIconButton(
                    icon: Icons.close,
                    onPressed: onDismiss,
                    variant: SldsButtonVariant.text,
                    size: SldsButtonSize.small,
                    tooltip: context.sldsStrings.close,
                  ),
              ],
            );

            if (actionsWidth == 0) return messageRow;

            if (fitsOneRow) {
              return Row(
                children: [
                  // Expanded, not Flexible: Figma's message container is
                  // flex-[1_0_0] (tight fit) — it always claims the rest of
                  // the row, pushing the actions to the card's right edge
                  // even when the message is short. Flexible's loose fit let
                  // the whole row shrink-wrap instead, leaving Action/×
                  // stranded right after the text with empty space beyond.
                  Expanded(child: messageRow),
                  // Figma's banner (459:3223) puts a 24px gap between the
                  // message and the button container, not 8 — 8 is the
                  // tighter icon-to-text gap inside the message itself.
                  SizedBox(width: dimensions.space24),
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

/// [SldsBanner]'s inline action — the same underlined-link recipe the
/// library's own link button uses, but with an explicit [color] rather than
/// that widget's own token, since the right colour here must track the
/// banner's severity/tint (see the call site's comment for why).
class _BannerActionLink extends StatelessWidget {
  const _BannerActionLink({
    required this.label,
    required this.onPressed,
    required this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsetsDirectional.symmetric(horizontal: tokens.dimensions.space4),
        ),
        // Height, not width: a link is as wide as its text, but must still
        // be tall enough to hit. Material's own tapTargetSize is left in
        // place rather than shrink-wrapped away.
        minimumSize: WidgetStatePropertyAll(
          Size(0, tokens.dimensions.tapTargetMin),
        ),
        // Figma gives a link no surface in any state, so Material's state
        // layer is suppressed and the feedback lives in the label colour.
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        textStyle: WidgetStatePropertyAll(tokens.typography.body1),
        foregroundColor: WidgetStatePropertyAll(color),
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }
}
