import 'package:flutter/material.dart';

import 'slds_design_tokens.g.dart';

export 'slds_design_tokens.g.dart';

/// `context.slds` — the [SldsTokenSet] matching the ambient [Theme]'s
/// brightness, re-derived on every read (not cached) so it tracks
/// light/dark toggles and [MediaQuery.disableAnimations] automatically.
extension SldsTokensContext on BuildContext {
  SldsTokenSet get slds {
    final reducedMotion = MediaQuery.maybeOf(this)?.disableAnimations ?? false;
    return Theme.of(this).brightness == Brightness.dark
        ? SldsTokenSet.dark(reducedMotion: reducedMotion)
        : SldsTokenSet.light(reducedMotion: reducedMotion);
  }
}
