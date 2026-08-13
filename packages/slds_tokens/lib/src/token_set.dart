import 'colors.dart';
import 'dimensions.dart';
import 'motion.dart';
import 'typography.dart';

/// Every SLDS token for one theme, in raw (Flutter-free) form.
///
/// `slds_components` wraps this in its own `SldsTokenSet`, which exposes the
/// same values as `Color` and `TextStyle`. Widgets use that one; this type is
/// the transport across the package boundary.
class SldsRawTokenSet {
  /// Creates a raw token set.
  const SldsRawTokenSet({
    required this.colors,
    required this.motion,
    this.dimensions = SldsDimensionTokens.standard,
    this.typography = SldsRawTypographyTokens.standard,
  });

  /// The light theme's tokens.
  factory SldsRawTokenSet.light({bool reducedMotion = false}) {
    return SldsRawTokenSet(
      colors: SldsRawColorTokens.light(),
      motion: SldsMotionTokens(reducedMotion: reducedMotion),
    );
  }

  /// The dark theme's tokens.
  factory SldsRawTokenSet.dark({bool reducedMotion = false}) {
    return SldsRawTokenSet(
      colors: SldsRawColorTokens.dark(),
      motion: SldsMotionTokens(reducedMotion: reducedMotion),
    );
  }

  /// The high-contrast theme's tokens.
  factory SldsRawTokenSet.highContrast({bool reducedMotion = false}) {
    return SldsRawTokenSet(
      colors: SldsRawColorTokens.highContrast(),
      motion: SldsMotionTokens(reducedMotion: reducedMotion),
    );
  }

  /// Colour roles for this theme.
  final SldsRawColorTokens colors;

  /// Spacing, sizing, radii and elevation. Theme-independent.
  final SldsDimensionTokens dimensions;

  /// The type scale. Theme-independent.
  final SldsRawTypographyTokens typography;

  /// Animation durations.
  final SldsMotionTokens motion;

  /// Returns a copy with the given token groups replaced.
  SldsRawTokenSet copyWith({
    SldsRawColorTokens? colors,
    SldsDimensionTokens? dimensions,
    SldsRawTypographyTokens? typography,
    SldsMotionTokens? motion,
  }) {
    return SldsRawTokenSet(
      colors: colors ?? this.colors,
      dimensions: dimensions ?? this.dimensions,
      typography: typography ?? this.typography,
      motion: motion ?? this.motion,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SldsRawTokenSet &&
        other.colors == colors &&
        other.dimensions == dimensions &&
        other.typography == typography &&
        other.motion == motion;
  }

  @override
  int get hashCode => Object.hash(colors, dimensions, typography, motion);
}
