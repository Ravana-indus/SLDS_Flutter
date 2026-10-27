import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsDivider,
  path: '[Display & Data]',
)
Widget buildSldsDividerUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Default — a plain unbroken rule.
        const SldsDivider(),
        const SizedBox(height: 24),
        // 2. Split around arbitrary content (e.g. "or" between two sign-in
        // options).
        const SldsDivider(child: Text('or')),
        const SizedBox(height: 24),
        // 3. Figma's "With Button" variant (502:3758) — the dedicated
        // factory builds the ghost "+ Button" to spec.
        SldsDivider.withButton(buttonLabel: 'Button', onButtonPressed: () {}),
      ],
    ),
  );
}
