import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsBadge,
  path: '[Feedback & Status]',
)
Widget buildSldsBadgeUseCase(BuildContext context) {
  final status = context.knobs.object.dropdown(
    label: 'Status',
    options: SldsBadgeStatus.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsBadgeStatus.inReview,
  );
  final label = context.knobs.string(
    label: 'Label (blank = status default)',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );

  return Center(
    child: label.isEmpty
        ? SldsBadge.status(status)
        : SldsBadge(label: label, status: status),
  );
}

@widgetbook.UseCase(
  name: 'All statuses',
  type: SldsBadge,
  path: '[Feedback & Status]',
)
Widget buildSldsBadgeAllUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final status in SldsBadgeStatus.values) ...[
          SldsBadge.status(status),
          const SizedBox(height: 8),
        ],
      ],
    ),
  );
}
