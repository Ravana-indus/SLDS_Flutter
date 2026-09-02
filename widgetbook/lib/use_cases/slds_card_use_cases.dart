import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(name: 'Default', type: SldsCard, path: '[Layout]')
Widget buildSldsCardUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  return SldsCard(child: Text(copy['Card content']));
}
