// Design tokens for SLDS opacities.

/// The SLDS opacity scale.
///
/// Opacity lives in its own token group rather than alongside the colour
/// palette: these are composition factors applied *to* a colour, not colours
/// themselves, and the Figma token export treats them as a separate set.
///
/// Prefer a designed colour token where one exists — [disabled] is for the
/// cases where a control dims a caller-supplied or state-derived colour and
/// no fixed disabled token can express it.
class SldsOpacityTokens {
  /// Creates opacity tokens.
  const SldsOpacityTokens({this.disabled = 0.38, this.scrim = 0.32});

  /// The shipped opacity scale.
  static const SldsOpacityTokens standard = SldsOpacityTokens();

  /// Applied to a control's colours when it is disabled.
  ///
  /// Disabled controls are exempt from the WCAG 1.4.3 contrast minimum, so
  /// pairs composited at this alpha are excluded from the contrast check.
  final double disabled;

  /// Applied behind modal surfaces to dim the content beneath.
  final double scrim;

  /// Returns a copy with the given values replaced.
  SldsOpacityTokens copyWith({double? disabled, double? scrim}) {
    return SldsOpacityTokens(
      disabled: disabled ?? this.disabled,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SldsOpacityTokens &&
        other.disabled == disabled &&
        other.scrim == scrim;
  }

  @override
  int get hashCode => Object.hash(disabled, scrim);
}
