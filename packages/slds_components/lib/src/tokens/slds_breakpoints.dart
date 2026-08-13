import 'package:flutter/widgets.dart';

/// SLDS responsive breakpoint — the single width threshold every component
/// and token (typography, button sizing, card padding, ...) switches on.
abstract final class SldsBreakpoints {
  /// Below this width is "mobile"; at or above it is "desktop/web".
  static const double mobile = 600;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;
}
