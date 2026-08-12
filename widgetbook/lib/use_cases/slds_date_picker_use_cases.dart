import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsDatePicker,
  path: '[Forms & Inputs]',
)
Widget buildSldsDatePickerUseCase(BuildContext context) {
  final mode = context.knobs.object.dropdown<SldsDatePickerMode>(
    label: 'Mode',
    options: SldsDatePickerMode.values,
    labelBuilder: (m) => m.name,
    initialOption: SldsDatePickerMode.range,
  );

  return SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Center(
      child: SldsDatePicker(
        mode: mode,
        onDateSelected: (date) {},
        onRangeSelected: (range) {},
        onApply: (val) {},
      ),
    ),
  );
}
