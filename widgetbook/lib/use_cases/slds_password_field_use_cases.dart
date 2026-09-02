import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsPasswordField,
  path: '[Forms & Inputs]',
)
Widget buildSldsPasswordFieldUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
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
  final compact = context.knobs.boolean(label: 'Compact', initialValue: false);
  final hasError = context.knobs.boolean(label: 'Error', initialValue: false);
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsPasswordField(
      helpText: helpText,
      compact: compact,
      isRequired: isRequired,
      enabled: isEnabled,
      errorText: hasError ? 'Error Text' : null,
    ),
  );
}
