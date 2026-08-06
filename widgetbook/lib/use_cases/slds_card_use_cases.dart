import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: SldsCard)
Widget buildSldsCardUseCase(BuildContext context) {
  return const SldsCard(
    child: Text('Card content'),
  );
}
