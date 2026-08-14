import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsRangeSlider,
  path: '[Forms & Inputs]',
)
Widget buildSldsRangeSliderUseCase(BuildContext context) {
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final min = context.knobs.double.input(label: 'Min', initialValue: 0);
  final max = context.knobs.double.input(label: 'Max', initialValue: 100);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: _RangeSliderDemo(enabled: isEnabled, min: min, max: max),
  );
}

/// Real [State] (not a closure-local var) so the value survives rebuilds —
/// see the SldsCheckbox playground bug this pattern avoids.
class _RangeSliderDemo extends StatefulWidget {
  const _RangeSliderDemo({
    required this.enabled,
    required this.min,
    required this.max,
  });

  final bool enabled;
  final double min;
  final double max;

  @override
  State<_RangeSliderDemo> createState() => _RangeSliderDemoState();
}

class _RangeSliderDemoState extends State<_RangeSliderDemo> {
  double _value = 40;

  @override
  Widget build(BuildContext context) {
    return SldsRangeSlider(
      value: _value.clamp(widget.min, widget.max),
      min: widget.min,
      max: widget.max,
      enabled: widget.enabled,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}
