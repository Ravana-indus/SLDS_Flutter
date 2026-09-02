import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// Circular footprint for [SldsAvatar], keyed to [SldsDimensionTokens]'s
/// `avatarSize*` scale.
enum SldsAvatarSize {
  /// 24px — dense lists and inline mentions.
  small,

  /// 32px — the default; list rows and compact headers.
  medium,

  /// 40px — cards and comment threads.
  large,

  /// 48px — profile headers.
  extraLarge,

  /// 56px — the largest swatch, for account/profile pages.
  huge,
}

/// SLDS avatar — a circular person indicator with three fallback tiers:
/// [imageProvider] (a photo) beats [initials] (e.g. "LK") beats the default
/// person glyph. All three share the same accent-yellow background/sizing,
/// so swapping between them (e.g. photo fails to load → initials) never
/// reflows the layout.
class SldsAvatar extends StatelessWidget {
  /// Creates an avatar, resolving its content in the order
  /// [imageProvider], then [initials], then the default person glyph.
  const SldsAvatar({
    super.key,
    this.imageProvider,
    this.initials,
    this.size = SldsAvatarSize.medium,
    this.semanticLabel,
  });

  /// A photo — takes precedence over [initials] and the default icon.
  final ImageProvider? imageProvider;

  /// Shown centered when there's no [imageProvider] (e.g. "LK"). Only the
  /// first two characters are used; falls back to the person icon when null
  /// or empty.
  final String? initials;

  /// Circular footprint, from the token size scale. Defaults to
  /// [SldsAvatarSize.medium] (32px).
  final SldsAvatarSize size;

  /// Screen reader label for the avatar, normally the person's name.
  ///
  /// Null leaves the avatar unlabeled, which is right only when an adjacent
  /// widget already names the same person — otherwise a screen reader
  /// announces nothing, since neither a photo nor initials carry a name.
  final String? semanticLabel;

  double _diameter(SldsDimensionTokens dimensions) => switch (size) {
    SldsAvatarSize.small => dimensions.avatarSize24,
    SldsAvatarSize.medium => dimensions.avatarSize32,
    SldsAvatarSize.large => dimensions.avatarSize40,
    SldsAvatarSize.extraLarge => dimensions.avatarSize48,
    SldsAvatarSize.huge => dimensions.avatarSize56,
  };

  double _iconSize(SldsDimensionTokens dimensions) => switch (size) {
    SldsAvatarSize.small => dimensions.avatarIconSmall,
    SldsAvatarSize.medium => dimensions.avatarIconMedium,
    SldsAvatarSize.large => dimensions.avatarIconLarge,
    SldsAvatarSize.extraLarge => dimensions.avatarIconExtraLarge,
    SldsAvatarSize.huge => dimensions.avatarIconExtraLarge * 2,
  };

  double _initialsFontSize() => switch (size) {
    SldsAvatarSize.small => 11,
    SldsAvatarSize.medium => 13,
    SldsAvatarSize.large => 15,
    SldsAvatarSize.extraLarge => 18,
    SldsAvatarSize.huge => 28,
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final diameter = _diameter(dimensions);
    final background = colors.buttonPrimaryBackground;
    final trimmedInitials = initials?.trim();

    Widget content;
    if (imageProvider != null) {
      content = ClipOval(
        child: Image(
          image: imageProvider!,
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
        ),
      );
    } else if (trimmedInitials != null && trimmedInitials.isNotEmpty) {
      content = Container(
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Text(
          trimmedInitials.length > 2
              ? trimmedInitials.substring(0, 2)
              : trimmedInitials,
          style: TextStyle(
            color: colors.textStaticBlack,
            fontSize: _initialsFontSize(),
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else {
      content = Container(
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(
          Icons.person_outline,
          size: _iconSize(dimensions),
          color: colors.textStaticBlack,
        ),
      );
    }

    return Semantics(
      image: imageProvider != null,
      label: semanticLabel,
      child: SizedBox(width: diameter, height: diameter, child: content),
    );
  }
}
