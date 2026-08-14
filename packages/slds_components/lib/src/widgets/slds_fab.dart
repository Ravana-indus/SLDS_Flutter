import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../l10n/gen/slds_localizations.dart';
import '../theme/slds_tokens.dart';
import 'slds_button.dart';

/// SLDS floating action button.
///
/// Variant colours resolve from the ambient SLDS token set, so the button
/// follows light, dark and high-contrast themes automatically.
///
/// Only the filled variants ([SldsButtonVariant.primary],
/// [SldsButtonVariant.destructive]) and the outlined
/// [SldsButtonVariant.secondary] are supported: a FAB is a high-emphasis
/// control, and the low-emphasis `tertiary`/`text` variants have no
/// meaningful FAB rendering. Passing either asserts in debug.
///
/// Pass [badgeCount] to overlay a numeric badge (for example an unread
/// count). The badge announces its meaning through [SldsLocalizations], not
/// as a bare number, so a screen reader says "3 unread notifications" rather
/// than "3".
class SldsFab extends StatelessWidget {
  /// Creates a floating action button.
  const SldsFab({
    super.key,
    required this.icon,
    required this.onPressed,
    this.variant = SldsButtonVariant.primary,
    this.isLoading = false,
    this.tooltip,
    this.badgeCount,
    this.heroTag,
  }) : assert(
         variant == SldsButtonVariant.primary ||
             variant == SldsButtonVariant.secondary ||
             variant == SldsButtonVariant.destructive,
         'SldsFab supports the primary, secondary and destructive variants; '
         'tertiary and text have no FAB rendering.',
       );

  /// The glyph shown in the button.
  final IconData icon;

  /// Called when the button is tapped. Null disables the button.
  final VoidCallback? onPressed;

  /// Which SLDS action variant to render.
  final SldsButtonVariant variant;

  /// Whether to replace the icon with a loading indicator.
  final bool isLoading;

  /// Optional tooltip. Omitted entirely when null, so the semantics tree
  /// stays free of empty labels.
  final String? tooltip;

  /// Numeric badge shown in the corner; null hides it.
  final int? badgeCount;

  /// Hero tag for the underlying [FloatingActionButton].
  ///
  /// Flutter gives every FAB the same default tag, so two SldsFabs on one
  /// route throw a duplicate-hero exception. Pass a unique tag when a route
  /// shows more than one, or `null` here leaves the hero animation disabled
  /// rather than colliding.
  final Object? heroTag;

  bool get _enabled => onPressed != null && !isLoading;
  bool get _isFilled => variant != SldsButtonVariant.secondary;

  Color _background(SldsColorTokens colors) {
    if (!_enabled) return colors.disabledBackground;
    return switch (variant) {
      SldsButtonVariant.destructive => colors.buttonDestructiveBackground,
      SldsButtonVariant.secondary => colors.buttonSecondaryBackground,
      _ => colors.buttonPrimaryBackground,
    };
  }

  Color _foreground(SldsColorTokens colors) {
    if (!_enabled) return colors.disabledForeground;
    return switch (variant) {
      SldsButtonVariant.destructive => colors.buttonDestructiveLabel,
      SldsButtonVariant.secondary => colors.buttonSecondaryLabel,
      _ => colors.buttonPrimaryLabel,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final l10n = SldsLocalizations.of(context);

    final size = context.sldsIsMobile
        ? dimensions.avatarSize56
        : dimensions.buttonHeightExtraLarge;
    final foreground = _foreground(colors);

    Widget child = isLoading
        ? Semantics(
            liveRegion: true,
            label: l10n.loading,
            child: SizedBox(
              width: dimensions.iconSizeMedium,
              height: dimensions.iconSizeMedium,
              child: CupertinoActivityIndicator(color: foreground),
            ),
          )
        : Icon(icon, color: foreground);

    if (badgeCount != null) {
      // The count alone means nothing spoken aloud, so the badge carries a
      // localized label and its own digits are hidden from the tree.
      child = Semantics(
        label: l10n.unreadCount(badgeCount!),
        container: true,
        child: Badge.count(
          count: badgeCount!,
          backgroundColor: colors.notificationBadgeBackground,
          textColor: colors.buttonDestructiveLabel,
          child: ExcludeSemantics(child: child),
        ),
      );
    }

    final button = SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        onPressed: _enabled ? onPressed : null,
        heroTag: heroTag,
        backgroundColor: _background(colors),
        foregroundColor: foreground,
        disabledElevation: 0,
        elevation: dimensions.cardShadowBlur,
        shape: _isFilled
            ? const CircleBorder()
            : CircleBorder(
                side: BorderSide(
                  color: _enabled
                      ? colors.buttonSecondaryBorder
                      : colors.disabledBorder,
                  width: dimensions.controlBorderWidth,
                ),
              ),
        child: child,
      ),
    );

    // No Tooltip wrapper when there is nothing to say — an empty message
    // would otherwise add a blank node to the semantics tree.
    final message = isLoading ? l10n.loading : tooltip;
    if (message == null) return button;
    return Tooltip(message: message, child: button);
  }
}
