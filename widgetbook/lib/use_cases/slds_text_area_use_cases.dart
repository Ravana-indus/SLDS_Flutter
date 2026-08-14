import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsTextArea,
  path: '[Forms & Inputs]',
)
Widget buildSldsTextAreaUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Description',
  );
  final hintText = context.knobs.string(
    label: 'Hint',
    initialValue: 'Description placeholder',
  );
  final helpText = context.knobs.string(
    label: 'Help text',
    initialValue: 'Help Text',
  );
  final isRequired = context.knobs.boolean(
    label: 'Required',
    initialValue: true,
  );
  final hasError = context.knobs.boolean(label: 'Error', initialValue: false);
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final maxLength = context.knobs.int.input(
    label: 'Max length',
    initialValue: 300,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsTextArea(
      label: label,
      hintText: hintText,
      helpText: helpText,
      isRequired: isRequired,
      enabled: isEnabled,
      errorText: hasError ? 'Error Text' : null,
      maxLength: maxLength,
    ),
  );
}
