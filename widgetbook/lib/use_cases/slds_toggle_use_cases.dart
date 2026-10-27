import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/focused_demo.dart';

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
  // Shows Figma's Default/Checked - Focus states (#163).
  final isFocused = context.knobs.boolean(
    label: 'Focused',
    initialValue: false,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: FocusedDemo(
      focused: isFocused,
      builder: (focusNode) =>
          _ToggleDemo(enabled: isEnabled, size: size, focusNode: focusNode),
    ),
  );
}

/// Real [State] (not a closure-local var) so the value survives rebuilds —
/// see the SldsCheckbox playground bug this pattern avoids.
class _ToggleDemo extends StatefulWidget {
  const _ToggleDemo({
    required this.enabled,
    required this.size,
    required this.focusNode,
  });

  final bool enabled;
  final SldsToggleSize size;
  final FocusNode focusNode;

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
      focusNode: widget.focusNode,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}
