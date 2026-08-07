import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsButton, path: '[Actions]')
Widget buildSldsButtonUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown<SldsButtonVariant>(
    label: 'Variant',
    options: SldsButtonVariant.values,
    labelBuilder: (v) => v.name,
  );
  final label = context.knobs.string(label: 'Label', initialValue: 'Continue');
  final showLeadingIcon = context.knobs.boolean(label: 'Leading icon', initialValue: false);
  final showTrailingIcon = context.knobs.boolean(label: 'Trailing icon', initialValue: true);
  final isLoading = context.knobs.boolean(label: 'Loading', initialValue: false);
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return SldsButton(
    label: label,
    variant: variant,
    isLoading: isLoading,
    leadingIcon: showLeadingIcon ? Icons.chevron_left : null,
    trailingIcon: showTrailingIcon ? Icons.chevron_right : null,
    onPressed: isEnabled ? () {} : null,
  );
}
