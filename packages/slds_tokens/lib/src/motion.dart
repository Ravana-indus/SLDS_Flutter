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
    this.transientMessageDuration = const Duration(seconds: 4),
  });

  /// Whether the platform has asked for reduced motion.
  ///
  /// Mirrors `MediaQuery.disableAnimations`.
  final bool reducedMotion;

  /// Duration for short transitions, before [reducedMotion] is applied.
  final Duration fastDuration;

  /// Duration for standard transitions, before [reducedMotion] is applied.
  final Duration normalDuration;

  /// How long a transient message — a snack bar, a toast — stays on screen.
  ///
  /// Deliberately not a getter that honours [reducedMotion]: this is dwell
  /// time, not animation. Collapsing it to zero would dismiss the message
  /// before it could be read, which is the opposite of what the reduced-motion
  /// setting asks for. WCAG 2.2.1 also expects the reader to control timing,
  /// so a host that needs longer should raise this rather than remove it.
  final Duration transientMessageDuration;

  /// Short transition duration, honouring [reducedMotion].
  Duration get fast => reducedMotion ? Duration.zero : fastDuration;

  /// Standard transition duration, honouring [reducedMotion].
  Duration get normal => reducedMotion ? Duration.zero : normalDuration;

  /// Returns a copy with the given values replaced.
  SldsMotionTokens copyWith({
    bool? reducedMotion,
    Duration? fastDuration,
    Duration? normalDuration,
    Duration? transientMessageDuration,
  }) {
    return SldsMotionTokens(
      reducedMotion: reducedMotion ?? this.reducedMotion,
      fastDuration: fastDuration ?? this.fastDuration,
      normalDuration: normalDuration ?? this.normalDuration,
      transientMessageDuration:
          transientMessageDuration ?? this.transientMessageDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SldsMotionTokens &&
        other.reducedMotion == reducedMotion &&
        other.fastDuration == fastDuration &&
        other.normalDuration == normalDuration &&
        other.transientMessageDuration == transientMessageDuration;
  }

  @override
  int get hashCode => Object.hash(
    reducedMotion,
    fastDuration,
    normalDuration,
    transientMessageDuration,
  );
}
