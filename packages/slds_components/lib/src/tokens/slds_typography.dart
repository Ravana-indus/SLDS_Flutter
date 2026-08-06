import 'package:flutter/material.dart';

/// SLDS type scale — Desktop and Mobile variants, per the Foundation
/// Documentation spec (Google Sans, exact px/line-height/letter-spacing).
///
/// Sinhala/Tamil render via `fontFamilyFallback`; the Google Sans and Noto
/// Sans Sinhala/Tamil font asset files are NOT bundled yet — add them under
/// `packages/slds_components/fonts/` and register them in `pubspec.yaml`'s
/// `flutter.fonts` section, or these family names are inert and the OS's
/// own font substitution takes over.
abstract final class SldsTypography {
  static const _fontFamily = 'Google Sans';
  static const _fontFamilyFallback = ['Noto Sans Sinhala', 'Noto Sans Tamil'];

  static TextStyle _style({
    required double fontSize,
    required double lineHeight,
    required double letterSpacing,
    required FontWeight fontWeight,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: fontSize,
      height: lineHeight / fontSize,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
    );
  }

  /// Desktop breakpoint type scale (Display 1/2, Heading 1-4, Title 1,
  /// Body 1-3, Caption 1-2, Overline).
  static final TextTheme desktop = TextTheme(
    displayLarge: _style(fontSize: 56, lineHeight: 68, letterSpacing: -0.5, fontWeight: FontWeight.w700),
    displayMedium: _style(fontSize: 44, lineHeight: 56, letterSpacing: -0.3, fontWeight: FontWeight.w700),
    headlineLarge: _style(fontSize: 32, lineHeight: 44, letterSpacing: -0.3, fontWeight: FontWeight.w700),
    headlineMedium: _style(fontSize: 28, lineHeight: 40, letterSpacing: -0.2, fontWeight: FontWeight.w700),
    headlineSmall: _style(fontSize: 24, lineHeight: 36, letterSpacing: -0.2, fontWeight: FontWeight.w500),
    titleMedium: _style(fontSize: 24, lineHeight: 32, letterSpacing: -0.1, fontWeight: FontWeight.w500),
    titleSmall: _style(fontSize: 18, lineHeight: 28, letterSpacing: 0.0, fontWeight: FontWeight.w500),
    bodyLarge: _style(fontSize: 16, lineHeight: 26, letterSpacing: 0.0, fontWeight: FontWeight.w400),
    bodyMedium: _style(fontSize: 14, lineHeight: 22, letterSpacing: 0.0, fontWeight: FontWeight.w400),
    bodySmall: _style(fontSize: 14, lineHeight: 22, letterSpacing: 0.0, fontWeight: FontWeight.w400),
    labelLarge: _style(fontSize: 12, lineHeight: 18, letterSpacing: 0.2, fontWeight: FontWeight.w400),
    labelMedium: _style(fontSize: 11, lineHeight: 16, letterSpacing: 0.3, fontWeight: FontWeight.w400),
    labelSmall: _style(fontSize: 11, lineHeight: 16, letterSpacing: 1.0, fontWeight: FontWeight.w500),
  );

  /// Mobile breakpoint type scale (Deck Heading 1-4, Display 1, Heading 1-4,
  /// Title 1, Body 1-2, Caption 1-2, Overline).
  static final TextTheme mobile = TextTheme(
    displayLarge: _style(fontSize: 88, lineHeight: 96, letterSpacing: -5.0, fontWeight: FontWeight.w700),
    displayMedium: _style(fontSize: 72, lineHeight: 80, letterSpacing: -5.0, fontWeight: FontWeight.w700),
    displaySmall: _style(fontSize: 56, lineHeight: 64, letterSpacing: -4.0, fontWeight: FontWeight.w700),
    headlineLarge: _style(fontSize: 44, lineHeight: 52, letterSpacing: -4.0, fontWeight: FontWeight.w700),
    headlineMedium: _style(fontSize: 36, lineHeight: 44, letterSpacing: -2.0, fontWeight: FontWeight.w500),
    headlineSmall: _style(fontSize: 20, lineHeight: 40, letterSpacing: -0.5, fontWeight: FontWeight.w700),
    titleLarge: _style(fontSize: 22, lineHeight: 36, letterSpacing: -0.5, fontWeight: FontWeight.w700),
    titleMedium: _style(fontSize: 24, lineHeight: 32, letterSpacing: 0.0, fontWeight: FontWeight.w500),
    titleSmall: _style(fontSize: 26, lineHeight: 28, letterSpacing: 0.0, fontWeight: FontWeight.w500),
    bodyLarge: _style(fontSize: 18, lineHeight: 24, letterSpacing: 0.0, fontWeight: FontWeight.w500),
    bodyMedium: _style(fontSize: 16, lineHeight: 20, letterSpacing: 0.0, fontWeight: FontWeight.w400),
    bodySmall: _style(fontSize: 14, lineHeight: 24, letterSpacing: 0.0, fontWeight: FontWeight.w400),
    labelLarge: _style(fontSize: 12, lineHeight: 16, letterSpacing: 0.0, fontWeight: FontWeight.w400),
    labelMedium: _style(fontSize: 11, lineHeight: 20, letterSpacing: 0.0, fontWeight: FontWeight.w400),
    labelSmall: _style(fontSize: 11, lineHeight: 16, letterSpacing: 2.0, fontWeight: FontWeight.w500),
  );

  /// Below this width, [mobile] is used; at or above it, [desktop].
  static const double breakpoint = 600;

  /// Picks [desktop] or [mobile] from the current [MediaQuery] width.
  static TextTheme of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= breakpoint ? desktop : mobile;
  }
}
