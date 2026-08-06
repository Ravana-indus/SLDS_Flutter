import 'package:flutter/material.dart';

/// SLDS color tokens.
///
/// PLACEHOLDER VALUES — GovTech Sri Lanka's official SLDS token spec was not
/// available at scaffold time. Swap these for the real published values;
/// the shape (names below) is the part meant to stay stable for consumers.
abstract final class SldsColors {
  static const primary = Color(0xFF0B4F6C);
  static const onPrimary = Color(0xFFFFFFFF);
  static const secondary = Color(0xFF01A7C2);
  static const onSecondary = Color(0xFF00201F);
  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF1A1C1E);
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
}
