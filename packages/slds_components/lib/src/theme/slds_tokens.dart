// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_design_tokens.dart';

export 'slds_design_tokens.dart';

/// `context.slds` — the [SldsTokenSet] matching the ambient [Theme] and
/// [MediaQuery], re-derived on every read (not cached) so it tracks
/// light/dark toggles, the OS high-contrast setting and
/// [MediaQueryData.disableAnimations] automatically.
extension SldsTokensContext on BuildContext {
  /// The token set for the current theme and accessibility settings.
  ///
  /// High contrast wins over brightness: a citizen who has switched it on
  /// needs the high-contrast palette in either light or dark mode.
  SldsTokenSet get slds {
    final mediaQuery = MediaQuery.maybeOf(this);
    final reducedMotion = mediaQuery?.disableAnimations ?? false;
    final theme = Theme.of(this);

    // Prefer the set the ThemeData carries (§4), so an app that overrode
    // tokens via `theme.copyWith(extensions:)` gets its own values here
    // rather than the library's defaults.
    final fromTheme = theme.extension<SldsTokenSet>();
    if (fromTheme != null) {
      return reducedMotion
          ? fromTheme.copyWith(
              motion: const SldsMotionTokens(reducedMotion: true),
            )
          : fromTheme;
    }

    // Fallback for a host that installed no SLDS theme at all: derive from
    // brightness so components still render with real tokens rather than
    // throwing.
    if (mediaQuery?.highContrast ?? false) {
      return SldsTokenSet.highContrast(reducedMotion: reducedMotion);
    }
    return theme.brightness == Brightness.dark
        ? SldsTokenSet.dark(reducedMotion: reducedMotion)
        : SldsTokenSet.light(reducedMotion: reducedMotion);
  }

  /// Whether the viewport is narrower than [SldsDimensionTokens.breakpointMobile].
  ///
  /// The width itself is a token; this helper lives in `slds_components`
  /// because [BuildContext] is Flutter and the token package stays pure Dart.
  bool get sldsIsMobile =>
      MediaQuery.sizeOf(this).width < slds.dimensions.breakpointMobile;
}
