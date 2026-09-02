import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsTimePicker,
  path: '[Forms & Inputs]',
)
Widget buildSldsTimePickerUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Time');
  // Empty means "unset" — see the note in the search bar use case.
  final title = context.knobs.string(label: 'Dialog Title');
  final hintText = context.knobs.string(
    label: 'Hint Text',
    initialValue: 'HH:MM',
  );
  final helpText = context.knobs.string(label: 'Help Text', initialValue: '');
  final errorText = context.knobs.string(label: 'Error Text', initialValue: '');
  final isRequired = context.knobs.boolean(
    label: 'Is Required',
    initialValue: false,
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Center(
      child: SldsTimePicker(
        label: label,
        titleText: title.isEmpty ? null : title,
        hintText: hintText,
        helpText: helpText.isEmpty ? null : helpText,
        errorText: errorText.isEmpty ? null : errorText,
        isRequired: isRequired,
        enabled: isEnabled,
        onTimeChanged: (time) {},
      ),
    ),
  );
}
