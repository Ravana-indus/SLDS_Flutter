import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsFieldset, path: '[Forms & Inputs]')
Widget buildSldsFieldsetUseCase(BuildContext context) {
  final legend = context.knobs.string(label: 'Legend', initialValue: 'Shipping address');
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Where should we deliver your order?',
  );
  final isRequired = context.knobs.boolean(label: 'Required', initialValue: true);
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final hasError = context.knobs.boolean(label: 'Error', initialValue: false);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsFieldset(
      legend: legend,
      description: description.isEmpty ? null : description,
      required: isRequired,
      enabled: isEnabled,
      helperText: 'All fields in this group are required.',
      errorText: hasError ? 'Please complete every field before continuing.' : null,
      children: [
        SldsInput(label: 'Street address', required: true, enabled: isEnabled),
        Row(
          children: [
            Expanded(child: SldsInput(label: 'City', required: true, enabled: isEnabled)),
            const SizedBox(width: 12),
            Expanded(child: SldsInput(label: 'Postal code', required: true, enabled: isEnabled)),
          ],
        ),
      ],
    ),
  );
}
