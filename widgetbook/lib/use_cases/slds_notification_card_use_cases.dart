import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsNotificationCard, path: '[Notification]')
Widget buildSldsNotificationCardUseCase(BuildContext context) {
  final type = context.knobs.object.dropdown(
    label: 'Type',
    options: SldsNotificationType.values,
    labelBuilder: (t) => t.name,
    initialOption: SldsNotificationType.document,
  );
  final unread = context.knobs.boolean(label: 'Unread', initialValue: true);
  final showAction = context.knobs.boolean(label: 'Show action button', initialValue: true);
  final swipeToDismiss = context.knobs.boolean(label: 'Swipe to dismiss', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(16),
    child: SldsNotificationCard(
      title: 'Your Birth Certificate is ready',
      body: 'Download it now or collect it from your selected office.',
      timestamp: 'Today, 12:00pm',
      type: type,
      unread: unread,
      actionLabel: showAction ? 'Download' : null,
      onAction: () {},
      onDismissed: swipeToDismiss ? (_) {} : null,
    ),
  );
}
