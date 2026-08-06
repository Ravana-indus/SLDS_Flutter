import 'package:flutter/material.dart';

/// SLDS type scale, built on Material 3's [TextTheme] shape so it drops
/// straight into [ThemeData.textTheme].
///
/// PLACEHOLDER VALUES — replace with GovTech's published type scale
/// (including any Sinhala/Tamil font family requirements) once available.
abstract final class SldsTypography {
  static const _fontFamily = null; // ponytail: default system font, set once GovTech names an official typeface

  static const TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(fontFamily: _fontFamily, fontSize: 32, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontFamily: _fontFamily, fontSize: 28, fontWeight: FontWeight.w700),
    titleLarge: TextStyle(fontFamily: _fontFamily, fontSize: 22, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w600),
  );
}
