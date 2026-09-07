import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsNotificationIcon,
  path: '[Feedback & Status]',
)
Widget buildSldsNotificationIconUseCase(BuildContext context) {
  final type = context.knobs.object.dropdown(
    label: 'Type',
    options: SldsNotificationType.values,
    labelBuilder: (t) => t.name,
    initialOption: SldsNotificationType.document,
  );
  final semanticLabel = context.knobs.string(
    label: 'Semantic label (blank = decorative)',
    initialValue: '',
    description: 'Blank leaves the icon decorative for screen readers.',
  );

  return Center(
    child: SldsNotificationIcon(
      type: type,
      semanticLabel: semanticLabel.isEmpty ? null : semanticLabel,
    ),
  );
}

@widgetbook.UseCase(
  name: 'All types',
  type: SldsNotificationIcon,
  path: '[Feedback & Status]',
)
Widget buildSldsNotificationIconAllUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final type in SldsNotificationType.values) ...[
          SldsNotificationIcon(type: type),
          const SizedBox(height: 8),
        ],
      ],
    ),
  );
}
