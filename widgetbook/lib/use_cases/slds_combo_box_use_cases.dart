import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _districts = [
  'Batticaloa',
  'Colombo',
  'Galle',
  'Jaffna',
  'Kegalle',
  'Trincomalee',
  'Kurunegala',
  'Mannar',
  'Kilinochchi',
];

@widgetbook.UseCase(name: 'Playground', type: SldsComboBox, path: '[Forms & Inputs]')
Widget buildSldsComboBoxUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'District');
  final helpText = context.knobs.string(label: 'Help text', initialValue: 'Help Text');
  final isRequired = context.knobs.boolean(label: 'Required', initialValue: true);
  final hasError = context.knobs.boolean(label: 'Error', initialValue: false);
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: StatefulBuilder(
      builder: (context, setState) {
        List<String> value = const [];
        return SldsComboBox<String>(
          label: label,
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
