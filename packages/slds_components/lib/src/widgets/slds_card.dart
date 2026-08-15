import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// SLDS content card. Thin themed wrapper over [Card] with token padding —
/// shape and surface colour resolve from the ambient [Theme], so the card
/// follows light, dark and high-contrast modes automatically.
///
/// Padding tightens below the mobile breakpoint and relaxes at or above it.
class SldsCard extends StatelessWidget {
  /// Creates a content card around [child].
  const SldsCard({required this.child, super.key});

  /// The card's contents.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.slds.dimensions;
    final padding = context.sldsIsMobile
        ? dimensions.space12
        : dimensions.space16;
    return Card(
      child: Padding(padding: EdgeInsets.all(padding), child: child),
    );
  }
}
