import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsCheckbox, path: '[Forms & Inputs]')
Widget buildSldsCheckboxUseCase(BuildContext context) {
  final isIndeterminate = context.knobs.boolean(label: 'Indeterminate', initialValue: false);
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: SldsCheckboxSize.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsCheckboxSize.large,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: _CheckboxDemo(
      initialValue: isIndeterminate ? null : false,
      enabled: isEnabled,
      size: size,
    ),
  );
}

/// Holds the checked state in real [State] (not a closure-local var) so it
/// survives rebuilds instead of resetting to [initialValue] on every tap.
class _CheckboxDemo extends StatefulWidget {
  const _CheckboxDemo({required this.initialValue, required this.enabled, required this.size});

  final bool? initialValue;
  final bool enabled;
  final SldsCheckboxSize size;

  @override
  State<_CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<_CheckboxDemo> {
  late bool? _value = widget.initialValue;

  @override
  void didUpdateWidget(_CheckboxDemo old) {
    super.didUpdateWidget(old);
    // Knobs changed (e.g. the Indeterminate toggle) — re-sync to the new default.
    if (old.initialValue != widget.initialValue) _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SldsCheckbox(
      value: _value,
      enabled: widget.enabled,
      size: widget.size,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}
