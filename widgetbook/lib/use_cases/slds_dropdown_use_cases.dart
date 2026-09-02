import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

const _districts = [
  'Batticaloa',
  'Colombo',
  'Galle',
  'Gampaha',
  'Jaffna',
  'Kandy',
  'Kurunegala',
  'Matara',
];

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsDropdown,
  path: '[Forms & Inputs]',
)
Widget buildSldsDropdownUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final labelOverride = context.knobs.string(
    label: 'Label',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final label = labelOverride.isEmpty ? copy['District'] : labelOverride;
  // Empty means "unset" — see the note in the search bar use case.
  final hintText = context.knobs.string(label: 'Hint');
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

  return Padding(
    padding: const EdgeInsets.all(24),
    child: StatefulBuilder(
      builder: (context, setState) {
        String? value;
        return SldsDropdown<String>(
          label: label,
          hintText: hintText.isEmpty ? null : hintText,
          helpText: helpText,
          isRequired: isRequired,
          enabled: isEnabled,
          errorText: hasError ? 'Error Text' : null,
          items: _districts,
          itemLabel: (item) => item,
          value: value,
          onChanged: (v) => setState(() => value = v),
        );
      },
    ),
  );
}
