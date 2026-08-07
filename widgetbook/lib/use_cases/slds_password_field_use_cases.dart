import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsPasswordField, path: '[Forms & Inputs]')
Widget buildSldsPasswordFieldUseCase(BuildContext context) {
  final helpText = context.knobs.string(label: 'Help text', initialValue: 'Help Text');
  final isRequired = context.knobs.boolean(label: 'Required', initialValue: true);
  final hasError = context.knobs.boolean(label: 'Error', initialValue: false);
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsPasswordField(
      helpText: helpText,
      isRequired: isRequired,
      enabled: isEnabled,
      errorText: hasError ? 'Error Text' : null,
    ),
  );
}
