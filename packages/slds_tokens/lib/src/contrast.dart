// WCAG contrast maths over packed ARGB values.
//
// Lives in the tokens package because it operates on the raw ints, which is
// what lets the compliance check in `test/` run as a plain Dart test with no
// widget binding (§8).

import 'dart:math' as math;

/// The relative luminance of an opaque ARGB colour, per WCAG 2.x.
///
/// The alpha channel is ignored: a translucent colour's effective luminance
/// depends on what it is composited over, which this function cannot know.
/// Composite first, then measure.
double relativeLuminance(int argb) {
  double channel(int shift) {
    final srgb = ((argb >> shift) & 0xff) / 255;
    return srgb <= 0.03928
        ? srgb / 12.92
        : math.pow((srgb + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * channel(16) + 0.7152 * channel(8) + 0.0722 * channel(0);
}

/// The WCAG contrast ratio between two opaque ARGB colours.
///
/// Ranges from 1 (identical) to 21 (black on white). Order does not matter.
double contrastRatio(int a, int b) {
  final la = relativeLuminance(a);
  final lb = relativeLuminance(b);
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

/// Composites a translucent `foreground` over an opaque `background`.
///
/// Use before [contrastRatio] when a token is applied at partial opacity, such
/// as a disabled-state foreground.
int compositeOver(int foreground, int background, double alpha) {
  int channel(int shift) {
    final f = (foreground >> shift) & 0xff;
    final b = (background >> shift) & 0xff;
    return (f * alpha + b * (1 - alpha)).round().clamp(0, 255);
  }

  return 0xff000000 | (channel(16) << 16) | (channel(8) << 8) | channel(0);
}
