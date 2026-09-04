import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsDialog,
  path: '[Feedback & Status]',
)
Widget buildSldsDialogUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  return Center(
    child: ElevatedButton(
      onPressed: () => SldsDialog.show(
        context,
        title: copy['Basic dialog title'],
        message:
            'A dialog is a modal window that appears in front of app content to provide '
            'critical information or ask for a decision',
        cancelLabel: copy['Cancel'],
        onCancel: () => Navigator.of(context).pop(),
        confirmLabel: copy['Continue'],
        onConfirm: () => Navigator.of(context).pop(),
      ),
      child: Text(copy['Show dialog']),
    ),
  );
}
