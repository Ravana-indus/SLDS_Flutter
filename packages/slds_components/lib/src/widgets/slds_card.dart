import 'package:flutter/material.dart';

import '../tokens/slds_spacing.dart';

/// SLDS content card. Thin themed wrapper over [Card] with token padding —
/// shape/color come from [SldsTheme.light]/[SldsTheme.dark] via the
/// ambient [Theme] (so it follows light/dark mode). Pass [color] to
/// override the surface color for one instance.
class SldsCard extends StatelessWidget {
  const SldsCard({super.key, required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(SldsSpacing.lg),
        child: child,
      ),
    );
  }
}
