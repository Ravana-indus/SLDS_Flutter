import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsSnackBar, path: '[Feedback & Status]')
Widget buildSldsSnackBarUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Title Text');
  final message = context.knobs.string(label: 'Message', initialValue: 'Enter the description text');
  final actionLabel = context.knobs.string(label: 'Action label', initialValue: 'Button');

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
          child: const Text('Show snack bar'),
        ),
      ),
    ),
  );
}
