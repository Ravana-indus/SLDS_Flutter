import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsProgressBar, path: '[Feedback & Status]')
Widget buildSldsProgressBarUseCase(BuildContext context) {
  final value = context.knobs.double.slider(label: 'Value', initialValue: 0.4, min: 0, max: 1);
  final showLabel = context.knobs.boolean(label: 'Show label', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsProgressBar(value: value, showLabel: showLabel),
  );
}

@widgetbook.UseCase(name: 'Every 10%', type: SldsProgressBar, path: '[Feedback & Status]')
Widget buildSldsProgressBarStepsUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i <= 10; i++) ...[
          if (i > 0) const SizedBox(height: 24),
          SldsProgressBar(value: i / 10),
        ],
      ],
    ),
  );
}
