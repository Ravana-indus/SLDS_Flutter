import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// Circular footprint for [SldsAvatar], keyed to [SldsDimensionTokens]'s
/// `avatarSize*` scale (24/32/40/48/56, plus a 64px `extraLarge` matching
/// the Figma reference's largest swatch).
enum SldsAvatarSize { small, medium, large, extraLarge, huge }

/// SLDS avatar — a circular person indicator with three fallback tiers:
/// [imageProvider] (a photo) beats [initials] (e.g. "LK") beats the default
/// person glyph. All three share the same accent-yellow background/sizing,
/// so swapping between them (e.g. photo fails to load → initials) never
/// reflows the layout.
class SldsAvatar extends StatelessWidget {
  const SldsAvatar({
    super.key,
    this.imageProvider,
    this.initials,
    this.size = SldsAvatarSize.medium,
    this.color,
    this.semanticLabel,
  });

  /// A photo — takes precedence over [initials] and the default icon.
  final ImageProvider? imageProvider;

  /// Shown centered when there's no [imageProvider] (e.g. "LK"). Only the
  /// first two characters are used; falls back to the person icon when null
  /// or empty.
  final String? initials;

  final SldsAvatarSize size;

  /// Overrides the token-driven background for this instance only.
  final Color? color;

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
    final background = color ?? colors.buttonPrimaryBackground;
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
