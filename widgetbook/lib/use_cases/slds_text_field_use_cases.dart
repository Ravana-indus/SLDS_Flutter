import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsTextField,
  path: '[Forms & Inputs]',
)
Widget buildSldsTextFieldUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final labelOverride = context.knobs.string(
    label: 'Label',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final label = labelOverride.isEmpty ? copy['Email'] : labelOverride;
  final hintText = context.knobs.string(
    label: 'Hint',
    initialValue: 'info@example.com',
  );
  final helpTextOverride = context.knobs.string(
    label: 'Help text',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final helpText = helpTextOverride.isEmpty
      ? copy['Help Text']
      : helpTextOverride;
  final compact = context.knobs.boolean(label: 'Compact', initialValue: false);
  final isRequired = context.knobs.boolean(
    label: 'Required',
    initialValue: true,
  );
  final hasError = context.knobs.boolean(label: 'Error', initialValue: false);
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final showLeadingIcon = context.knobs.boolean(
    label: 'Leading icon',
    initialValue: true,
  );
  final showTrailingIcon = context.knobs.boolean(
    label: 'Trailing icon',
    initialValue: true,
  );
  final showInfoButton = context.knobs.boolean(
    label: 'Info button',
    initialValue: true,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsTextField(
      label: label,
      hintText: hintText,
      helpText: helpText,
      compact: compact,
      isRequired: isRequired,
      enabled: isEnabled,
      errorText: hasError ? 'Error Text' : null,
      leadingIcon: showLeadingIcon ? Icons.star_border : null,
      trailingIcon: showTrailingIcon ? Icons.star_border : null,
      trailingIconTooltip: 'Favourite',
      infoIcon: showInfoButton ? Icons.info : null,
      infoTooltip: 'About this field',
      onInfoPressed: () {},
    ),
  );
}
