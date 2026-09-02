import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsSnackBar,
  path: '[Feedback & Status]',
)
Widget buildSldsSnackBarUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final titleOverride = context.knobs.string(
    label: 'Title',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final title = titleOverride.isEmpty ? copy['Title Text'] : titleOverride;
  final messageOverride = context.knobs.string(
    label: 'Message',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final message = messageOverride.isEmpty
      ? copy['Enter the description text']
      : messageOverride;
  final actionLabel = context.knobs.string(
    label: 'Action label',
    initialValue: 'Button',
  );

  return Scaffold(
    body: Center(
      child: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => SldsSnackBar.show(
            context,
            title: title,
            message: message.isEmpty ? null : message,
            actionLabel: actionLabel.isEmpty ? null : actionLabel,
            onAction: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
          child: Text(copy['Show snack bar']),
        ),
      ),
    ),
  );
}
