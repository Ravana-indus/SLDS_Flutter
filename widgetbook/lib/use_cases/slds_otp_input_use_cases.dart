import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsOtpInput, path: '[Forms & Inputs]')
Widget buildSldsOtpInputUseCase(BuildContext context) {
  final length = context.knobs.int.slider(
    label: 'Length',
    initialValue: 6,
    min: 4,
    max: 6,
  );
  final hasError = context.knobs.boolean(label: 'Error', initialValue: false);
  final success = context.knobs.boolean(label: 'Success', initialValue: false);
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: SldsOtpInputSize.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsOtpInputSize.large,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsOtpInput(
      length: length,
      size: size,
      enabled: isEnabled,
      success: success,
      errorText: hasError ? 'Error Text' : null,
    ),
  );
}
