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
      // ExcludeSemantics covers the whole badge, digits included: a screen
      // reader announcing "3" says nothing useful. The meaning is carried by
      // the button's own label instead, as "3 unread notifications".
      child = ExcludeSemantics(
        child: Badge.count(
          count: badgeCount!,
          backgroundColor: colors.notificationBadgeBackground,
          textColor: colors.buttonDestructiveLabel,
          child: child,
        ),
      );
    }

    // An icon-only control has no text for a screen reader to fall back on,
    // so it needs an explicit name. Built from the tooltip plus any badge
    // meaning, and applied to the tappable node itself rather than to an
    // ancestor — a wrapping Tooltip labels its own node and leaves the
    // button underneath nameless, which labeledTapTargetGuideline catches.
    final label = [
      if (isLoading) l10n.loading else ?tooltip,
      if (badgeCount != null) l10n.unreadCount(badgeCount!),
    ].join(', ');

    final button = SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        tooltip: label.isEmpty ? null : label,
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

    return button;
  }
}
