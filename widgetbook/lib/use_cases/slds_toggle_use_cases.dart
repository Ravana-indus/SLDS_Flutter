import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsToggle,
  path: '[Forms & Inputs]',
)
Widget buildSldsToggleUseCase(BuildContext context) {
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: SldsToggleSize.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsToggleSize.large,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: _ToggleDemo(enabled: isEnabled, size: size),
  );
}

/// Real [State] (not a closure-local var) so the value survives rebuilds —
/// see the SldsCheckbox playground bug this pattern avoids.
class _ToggleDemo extends StatefulWidget {
  const _ToggleDemo({required this.enabled, required this.size});

  final bool enabled;
  final SldsToggleSize size;

  @override
  State<_ToggleDemo> createState() => _ToggleDemoState();
}

class _ToggleDemoState extends State<_ToggleDemo> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return SldsToggle(
      value: _value,
      enabled: widget.enabled,
      size: widget.size,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}
