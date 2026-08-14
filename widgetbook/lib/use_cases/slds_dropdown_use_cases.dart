import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

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
  final label = context.knobs.string(label: 'Label', initialValue: 'District');
  final hintText = context.knobs.string(
    label: 'Hint',
    initialValue: 'Select district',
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

  return Padding(
    padding: const EdgeInsets.all(24),
    child: StatefulBuilder(
      builder: (context, setState) {
        String? value;
        return SldsDropdown<String>(
          label: label,
          hintText: hintText,
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
