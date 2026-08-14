import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// A soft outer glow in the token-defined focus halo color — the same
/// visual language as a browser's native `:focus-visible` ring, sized to
/// sit just outside a field's border rather than overlapping it.
List<BoxShadow> sldsFocusRing(SldsTokenSet tokens) => [
  BoxShadow(
    color: tokens.colors.focusHalo,
    blurRadius: 0,
    spreadRadius: tokens.dimensions.focusRingSpread,
  ),
];
