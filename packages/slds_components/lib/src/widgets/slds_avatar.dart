import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_path_glyph.dart';

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

  // Figma Avatar (502:3768), Type=Icon: the User glyph's box per size.
  double _iconSize() => switch (size) {
    SldsAvatarSize.small => 16,
    SldsAvatarSize.medium => 20,
    SldsAvatarSize.large => 24,
    SldsAvatarSize.extraLarge => 24,
    SldsAvatarSize.huge => 28,
  };

  // Figma Avatar, Type=Text: size / weight / line height per size (#202).
  (double, FontWeight, double) _initialsType() => switch (size) {
    SldsAvatarSize.small => (12, FontWeight.w400, 14),
    SldsAvatarSize.medium => (16, FontWeight.w400, 24),
    SldsAvatarSize.large => (18, FontWeight.w500, 24),
    SldsAvatarSize.extraLarge => (24, FontWeight.w500, 30),
    SldsAvatarSize.huge => (22, FontWeight.w700, 28),
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final diameter = _diameter(dimensions);
    final background = colors.buttonPrimaryBackground;
    // Figma draws initials and the glyph #17171A on the gold — the label
    // colour every gold surface uses.
    final foreground = colors.buttonPrimaryLabel;
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
          style: () {
            final (fontSize, weight, line) = _initialsType();
            return tokens.typography.body1.copyWith(
              color: foreground,
              fontSize: fontSize,
              fontWeight: weight,
              height: line / fontSize,
            );
          }(),
        ),
      );
    } else {
      content = Container(
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        alignment: Alignment.center,
        // Figma's Phosphor User glyph, not Material's person icon (#201).
        child: SldsPathGlyph(
          path: _user,
          viewBox: 24,
          size: _iconSize(),
          color: foreground,
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

/// Phosphor User (regular), as exported from Figma on a 24x24 grid.
final Path _user = Path()
  ..moveTo(21.6484, 19.875)
  ..cubicTo(20.2206, 17.4065, 18.0203, 15.6365, 15.4525, 14.7975)
  ..cubicTo(16.7226, 14.0414, 17.7094, 12.8892, 18.2614, 11.5179)
  ..cubicTo(18.8134, 10.1467, 18.8999, 8.6321, 18.5078, 7.2069)
  ..cubicTo(18.1157, 5.7816, 17.2666, 4.5245, 16.0909, 3.6286)
  ..cubicTo(14.9151, 2.7327, 13.4778, 2.2474, 11.9996, 2.2474)
  ..cubicTo(10.5215, 2.2474, 9.0841, 2.7327, 7.9084, 3.6286)
  ..cubicTo(6.7327, 4.5245, 5.8836, 5.7816, 5.4915, 7.2069)
  ..cubicTo(5.0994, 8.6321, 5.1859, 10.1467, 5.7379, 11.5179)
  ..cubicTo(6.2898, 12.8892, 7.2767, 14.0414, 8.5468, 14.7975)
  ..cubicTo(5.979, 15.6356, 3.7787, 17.4056, 2.3509, 19.875)
  ..cubicTo(2.2985, 19.9604, 2.2638, 20.0554, 2.2487, 20.1544)
  ..cubicTo(2.2337, 20.2534, 2.2386, 20.3544, 2.2633, 20.4515)
  ..cubicTo(2.2879, 20.5486, 2.3317, 20.6397, 2.3921, 20.7196)
  ..cubicTo(2.4526, 20.7995, 2.5284, 20.8664, 2.6151, 20.9165)
  ..cubicTo(2.7018, 20.9666, 2.7977, 20.9988, 2.8971, 21.0113)
  ..cubicTo(2.9965, 21.0237, 3.0973, 21.0161, 3.1937, 20.989)
  ..cubicTo(3.2901, 20.9618, 3.3801, 20.9156, 3.4583, 20.8531)
  ..cubicTo(3.5366, 20.7906, 3.6015, 20.713, 3.6493, 20.625)
  ..cubicTo(5.4156, 17.5725, 8.5375, 15.75, 11.9996, 15.75)
  ..cubicTo(15.4618, 15.75, 18.5837, 17.5725, 20.35, 20.625)
  ..cubicTo(20.3977, 20.713, 20.4627, 20.7906, 20.5409, 20.8531)
  ..cubicTo(20.6192, 20.9156, 20.7092, 20.9618, 20.8056, 20.989)
  ..cubicTo(20.902, 21.0161, 21.0028, 21.0237, 21.1022, 21.0113)
  ..cubicTo(21.2016, 20.9988, 21.2975, 20.9666, 21.3842, 20.9165)
  ..cubicTo(21.4709, 20.8664, 21.5467, 20.7995, 21.6072, 20.7196)
  ..cubicTo(21.6676, 20.6397, 21.7114, 20.5486, 21.736, 20.4515)
  ..cubicTo(21.7607, 20.3544, 21.7656, 20.2534, 21.7505, 20.1544)
  ..cubicTo(21.7355, 20.0554, 21.7008, 19.9604, 21.6484, 19.875)
  ..close()
  ..moveTo(6.7496, 9)
  ..cubicTo(6.7496, 7.9616, 7.0575, 6.9466, 7.6344, 6.0832)
  ..cubicTo(8.2113, 5.2199, 9.0312, 4.547, 9.9906, 4.1496)
  ..cubicTo(10.9499, 3.7523, 12.0055, 3.6483, 13.0239, 3.8509)
  ..cubicTo(14.0423, 4.0534, 14.9777, 4.5534, 15.712, 5.2877)
  ..cubicTo(16.4462, 6.0219, 16.9462, 6.9574, 17.1488, 7.9758)
  ..cubicTo(17.3513, 8.9942, 17.2474, 10.0498, 16.85, 11.0091)
  ..cubicTo(16.4527, 11.9684, 15.7797, 12.7883, 14.9164, 13.3652)
  ..cubicTo(14.053, 13.9421, 13.038, 14.25, 11.9996, 14.25)
  ..cubicTo(10.6077, 14.2485, 9.2732, 13.6949, 8.289, 12.7107)
  ..cubicTo(7.3047, 11.7264, 6.7511, 10.3919, 6.7496, 9)
  ..close();
