import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: SldsButton)
Widget buildSldsButtonUseCase(BuildContext context) {
  return SldsButton(
    label: 'Continue',
    onPressed: () {},
  );
}

@widgetbook.UseCase(name: 'Disabled', type: SldsButton)
Widget buildSldsButtonDisabledUseCase(BuildContext context) {
  return const SldsButton(
    label: 'Continue',
    onPressed: null,
  );
}
