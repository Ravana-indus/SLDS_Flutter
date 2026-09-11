import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

/// The default message for each severity, so switching the Severity knob
/// shows copy that matches the tone rather than one string in four colours.
const _messages = <SldsBannerSeverity, String>{
  SldsBannerSeverity.success: 'Your changes have been saved successfully.',
  SldsBannerSeverity.warning: 'Your session will expire soon. Please save '
      'your work.',
  SldsBannerSeverity.error: 'Something went wrong. Please try again later.',
  SldsBannerSeverity.info: 'New updates are available. Refresh to see changes.',
};

const _actions = <SldsBannerSeverity, String>{
  SldsBannerSeverity.success: 'View details',
  SldsBannerSeverity.warning: 'Save now',
  SldsBannerSeverity.error: 'Try again',
  SldsBannerSeverity.info: 'Refresh',
};

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsBanner,
  path: '[Feedback & Status]',
)
Widget buildSldsBannerUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final severity = context.knobs.object.dropdown(
    label: 'Severity',
    options: SldsBannerSeverity.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsBannerSeverity.success,
  );
  final messageOverride = context.knobs.string(
    label: 'Message',
    initialValue: '',
    description: 'Blank follows the Severity and Locale addons; type to '
        'override.',
  );
  final showAction = context.knobs.boolean(
    label: 'Show action',
    initialValue: true,
  );
  final showDismiss = context.knobs.boolean(
    label: 'Show dismiss',
    initialValue: true,
  );

  final message = messageOverride.isEmpty
      ? copy[_messages[severity]!]
      : messageOverride;

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Align(
      alignment: Alignment.topCenter,
      child: SldsBanner(
        message: message,
        severity: severity,
        actionLabel: showAction ? copy[_actions[severity]!] : null,
        onAction: showAction ? () {} : null,
        onDismiss: showDismiss ? () {} : null,
      ),
    ),
  );
}
