import 'package:flutter/material.dart';

/// SLDS primary action button. Thin themed wrapper over [FilledButton] —
/// all styling comes from [SldsTheme.light] via the ambient [Theme].
class SldsButton extends StatelessWidget {
  const SldsButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
