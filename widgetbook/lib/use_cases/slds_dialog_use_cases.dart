import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsDialog, path: '[Feedback & Status]')
Widget buildSldsDialogUseCase(BuildContext context) {
  return Center(
    child: ElevatedButton(
      onPressed: () => SldsDialog.show(
        context,
        title: 'Basic dialog title',
        message: 'A dialog is a modal window that appears in front of app content to provide '
            'critical information or ask for a decision',
        cancelLabel: 'Cancel',
        onCancel: () => Navigator.of(context).pop(),
        confirmLabel: 'Continue',
        onConfirm: () => Navigator.of(context).pop(),
      ),
      child: const Text('Show dialog'),
    ),
  );
}
