import 'package:flutter/material.dart';

import '../tokens/slds_breakpoints.dart';
import '../tokens/slds_spacing.dart';

/// SLDS content card. Thin themed wrapper over [Card] with token padding —
/// shape/color come from [SldsTheme.light]/[SldsTheme.dark] via the
/// ambient [Theme] (so it follows light/dark mode). Pass [color] to
/// override the surface color for one instance.
///
/// Padding is [SldsSpacing.md] below [SldsBreakpoints.mobile], [SldsSpacing.lg]
/// at/above it.
class SldsCard extends StatelessWidget {
  const SldsCard({super.key, required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final padding = SldsBreakpoints.isMobile(context) ? SldsSpacing.md : SldsSpacing.lg;
    return Card(
      color: color,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}
