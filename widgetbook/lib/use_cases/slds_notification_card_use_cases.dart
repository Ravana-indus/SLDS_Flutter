import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsNotificationCard,
  path: '[Feedback & Status]',
)
Widget buildSldsNotificationCardUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final type = context.knobs.object.dropdown(
    label: 'Type',
    options: SldsNotificationType.values,
    labelBuilder: (t) => t.name,
    initialOption: SldsNotificationType.document,
  );
  final unread = context.knobs.boolean(label: 'Unread', initialValue: true);
  final showAction = context.knobs.boolean(
    label: 'Show action button',
    initialValue: true,
  );
  final swipeToDismiss = context.knobs.boolean(
    label: 'Swipe to dismiss',
    initialValue: true,
  );

  return Padding(
    padding: EdgeInsets.all(16),
    child: SldsNotificationCard(
      title: copy['Your Birth Certificate is ready'],
      body: copy['Download it now or collect it from your selected office.'],
      timestamp: 'Today, 12:00pm',
      type: type,
      unread: unread,
      actionLabel: showAction ? 'Download' : null,
      onAction: () {},
      onDismissed: swipeToDismiss ? (_) {} : null,
    ),
  );
}
