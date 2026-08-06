import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsFab)
Widget buildSldsFabUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown<SldsButtonVariant>(
    label: 'Variant',
    options: [SldsButtonVariant.primary, SldsButtonVariant.secondary, SldsButtonVariant.destructive],
    labelBuilder: (v) => v.name,
  );
  final isLoading = context.knobs.boolean(label: 'Loading', initialValue: false);
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final showBadge = context.knobs.boolean(label: 'Badge', initialValue: false);
  final badgeCount = context.knobs.int.input(label: 'Badge count', initialValue: 3);

  return SldsFab(
    icon: Icons.add,
    variant: variant,
    isLoading: isLoading,
    tooltip: 'Add',
    badgeCount: showBadge ? badgeCount : null,
    onPressed: isEnabled ? () {} : null,
  );
}
