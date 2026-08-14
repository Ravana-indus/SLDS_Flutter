// Design tokens for SLDS motion.

/// The SLDS animation durations.
///
/// When [reducedMotion] is set, [fast] and [normal] both collapse to
/// [Duration.zero] so non-essential animation is skipped. Callers read the
/// getters rather than the raw fields for that reason.
class SldsMotionTokens {
  /// Creates motion tokens.
  const SldsMotionTokens({
    required this.reducedMotion,
    this.fastDuration = const Duration(milliseconds: 120),
    this.normalDuration = const Duration(milliseconds: 180),
  });

  /// Whether the platform has asked for reduced motion.
  ///
  /// Mirrors `MediaQuery.disableAnimations`.
  final bool reducedMotion;

  /// Duration for short transitions, before [reducedMotion] is applied.
  final Duration fastDuration;

  /// Duration for standard transitions, before [reducedMotion] is applied.
  final Duration normalDuration;

  /// Short transition duration, honouring [reducedMotion].
  Duration get fast => reducedMotion ? Duration.zero : fastDuration;

  /// Standard transition duration, honouring [reducedMotion].
  Duration get normal => reducedMotion ? Duration.zero : normalDuration;

  /// Returns a copy with the given values replaced.
  SldsMotionTokens copyWith({
    bool? reducedMotion,
    Duration? fastDuration,
    Duration? normalDuration,
  }) {
    return SldsMotionTokens(
      reducedMotion: reducedMotion ?? this.reducedMotion,
      fastDuration: fastDuration ?? this.fastDuration,
      normalDuration: normalDuration ?? this.normalDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SldsMotionTokens &&
        other.reducedMotion == reducedMotion &&
        other.fastDuration == fastDuration &&
        other.normalDuration == normalDuration;
  }

  @override
  int get hashCode => Object.hash(reducedMotion, fastDuration, normalDuration);
}
