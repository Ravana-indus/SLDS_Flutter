import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsIconButton, path: '[Actions]')
Widget buildSldsIconButtonUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown<SldsButtonVariant>(
    label: 'Variant',
    options: SldsButtonVariant.values,
    labelBuilder: (v) => v.name,
  );
  final isLoading = context.knobs.boolean(label: 'Loading', initialValue: false);
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return SldsIconButton(
    icon: Icons.add,
    variant: variant,
    isLoading: isLoading,
    tooltip: 'Add',
    onPressed: isEnabled ? () {} : null,
  );
}
