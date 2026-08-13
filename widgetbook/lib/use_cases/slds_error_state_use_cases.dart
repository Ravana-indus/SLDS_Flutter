import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _illustration = Icon(Icons.error_outline, size: 96, color: Colors.black26);

@widgetbook.UseCase(name: 'Playground', type: SldsErrorState, path: '[Feedback & Status]')
Widget buildSldsErrorStateUseCase(BuildContext context) {
  final kind = context.knobs.object.dropdown(
    label: 'Kind',
    options: SldsErrorKind.values,
    labelBuilder: (k) => k.name,
    initialOption: SldsErrorKind.notFound,
  );

  return SldsErrorState.forKind(kind, illustration: _illustration, onAction: () {});
}

@widgetbook.UseCase(name: 'Maintenance (no code)', type: SldsErrorState, path: '[Feedback & Status]')
Widget buildSldsErrorStateMaintenanceUseCase(BuildContext context) {
  return const SldsErrorState(
    illustration: _illustration,
    title: 'System is down for Maintenance',
    description: "We promise, we'll be right back!",
  );
}
