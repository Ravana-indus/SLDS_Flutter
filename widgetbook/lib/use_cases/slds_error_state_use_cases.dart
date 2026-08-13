import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsErrorState, path: '[Feedback & Status]')
Widget buildSldsErrorStateUseCase(BuildContext context) {
  final kind = context.knobs.object.dropdown(
    label: 'Kind',
    options: SldsErrorKind.values,
    labelBuilder: (k) => k.name,
    initialOption: SldsErrorKind.notFound,
  );

  // No illustration passed — SldsErrorState.forKind fills in its built-in
  // icon composition per kind.
  return SldsErrorState.forKind(kind, onAction: () {});
}

@widgetbook.UseCase(name: 'Maintenance (no code)', type: SldsErrorState, path: '[Feedback & Status]')
Widget buildSldsErrorStateMaintenanceUseCase(BuildContext context) {
  return const SldsErrorState(
    illustration: Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.construction, size: 72, color: Colors.black26),
        Positioned(
          right: 4,
          top: 0,
          child: Icon(Icons.warning_amber_rounded, size: 28, color: Colors.amber),
        ),
      ],
    ),
    title: 'System is down for Maintenance',
    description: "We promise, we'll be right back!",
  );
}
