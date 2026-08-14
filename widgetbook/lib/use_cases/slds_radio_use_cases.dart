import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsRadio,
  path: '[Forms & Inputs]',
)
Widget buildSldsRadioUseCase(BuildContext context) {
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: SldsRadioSize.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsRadioSize.large,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: _RadioDemo(enabled: isEnabled, size: size),
  );
}

/// Real [State] (not a closure-local var) so the selection survives
/// rebuilds — see the SldsCheckbox playground bug this pattern avoids.
class _RadioDemo extends StatefulWidget {
  const _RadioDemo({required this.enabled, required this.size});

  final bool enabled;
  final SldsRadioSize size;

  @override
  State<_RadioDemo> createState() => _RadioDemoState();
}

class _RadioDemoState extends State<_RadioDemo> {
  String _value = 'a';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SldsRadio<String>(
          value: 'a',
          groupValue: _value,
          enabled: widget.enabled,
          size: widget.size,
          onChanged: (v) => setState(() => _value = v),
        ),
        const SizedBox(width: 24),
        SldsRadio<String>(
          value: 'b',
          groupValue: _value,
          enabled: widget.enabled,
          size: widget.size,
          onChanged: (v) => setState(() => _value = v),
        ),
      ],
    );
  }
}
