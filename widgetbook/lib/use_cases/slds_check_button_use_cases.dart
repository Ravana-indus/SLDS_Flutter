import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsCheckButton,
  path: '[Forms & Inputs]',
)
Widget buildSldsCheckButtonUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final labelOverride = context.knobs.string(
    label: 'Label',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final label = labelOverride.isEmpty ? copy['Option One'] : labelOverride;
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SizedBox(
      width: 220,
      child: _CheckButtonDemo(label: label, enabled: isEnabled),
    ),
  );
}

/// Real [State] (not a closure-local var) so the selection survives
/// rebuilds — see the SldsCheckbox playground bug this pattern avoids.
class _CheckButtonDemo extends StatefulWidget {
  const _CheckButtonDemo({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  State<_CheckButtonDemo> createState() => _CheckButtonDemoState();
}

class _CheckButtonDemoState extends State<_CheckButtonDemo> {
  bool _selected = true;

  @override
  Widget build(BuildContext context) {
    return SldsCheckButton(
      label: widget.label,
      selected: _selected,
      enabled: widget.enabled,
      onChanged: (v) => setState(() => _selected = v),
    );
  }
}
