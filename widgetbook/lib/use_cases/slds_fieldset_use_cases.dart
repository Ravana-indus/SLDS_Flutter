import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsFieldset,
  path: '[Forms & Inputs]',
)
Widget buildSldsFieldsetUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final legendOverride = context.knobs.string(
    label: 'Legend',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final legend = legendOverride.isEmpty
      ? copy['Shipping address']
      : legendOverride;
  final descriptionOverride = context.knobs.string(
    label: 'Description',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final description = descriptionOverride.isEmpty
      ? copy['Where should we deliver your order?']
      : descriptionOverride;
  final isRequired = context.knobs.boolean(
    label: 'Required',
    initialValue: true,
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final hasError = context.knobs.boolean(label: 'Error', initialValue: false);

  return Padding(
    padding: EdgeInsets.all(24),
    child: SldsFieldset(
      legend: legend,
      description: description.isEmpty ? null : description,
      required: isRequired,
      enabled: isEnabled,
      helperText: copy['All fields in this group are required.'],
      errorText: hasError
          ? 'Please complete every field before continuing.'
          : null,
      children: [
        SldsInput(
          label: copy['Street address'],
          required: true,
          enabled: isEnabled,
        ),
        Row(
          children: [
            Expanded(
              child: SldsInput(
                label: copy['City'],
                required: true,
                enabled: isEnabled,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SldsInput(
                label: copy['Postal code'],
                required: true,
                enabled: isEnabled,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
