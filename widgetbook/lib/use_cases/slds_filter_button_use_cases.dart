import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsFilterButton,
  path: '[Forms & Inputs]',
)
Widget buildSldsFilterButtonUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Date posted',
  );
  final count = context.knobs.int.slider(
    label: 'Count',
    initialValue: 3,
    min: 0,
    max: 9,
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsFilterButton(
      label: label,
      count: count == 0 ? null : count,
      enabled: isEnabled,
      onTap: () {},
    ),
  );
}
