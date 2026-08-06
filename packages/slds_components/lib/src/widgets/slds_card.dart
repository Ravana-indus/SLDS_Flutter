import 'package:flutter/material.dart';

import '../tokens/slds_spacing.dart';

/// SLDS content card. Thin themed wrapper over [Card] with token padding —
/// shape/color come from [SldsTheme.light] via the ambient [Theme].
class SldsCard extends StatelessWidget {
  const SldsCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(SldsSpacing.lg),
        child: child,
      ),
    );
  }
}
