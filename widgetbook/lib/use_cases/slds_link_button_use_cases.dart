import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsLinkButton, path: '[Actions]')
Widget buildSldsLinkButtonUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Link button',
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return SldsLinkButton(label: label, onPressed: isEnabled ? () {} : null);
}
