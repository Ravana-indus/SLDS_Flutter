import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsTextArea,
  path: '[Forms & Inputs]',
)
Widget buildSldsTextAreaUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final labelOverride = context.knobs.string(
    label: 'Label',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final label = labelOverride.isEmpty ? copy['Description'] : labelOverride;
  final hintTextOverride = context.knobs.string(
    label: 'Hint',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final hintText = hintTextOverride.isEmpty
      ? copy['Description placeholder']
      : hintTextOverride;
  final helpTextOverride = context.knobs.string(
    label: 'Help text',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final helpText = helpTextOverride.isEmpty
      ? copy['Help Text']
      : helpTextOverride;
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
