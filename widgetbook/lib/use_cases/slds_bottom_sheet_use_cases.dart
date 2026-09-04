import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsBottomSheet,
  path: '[Navigation]',
)
Widget buildSldsBottomSheetUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  return Center(
    child: ElevatedButton(
      onPressed: () => SldsBottomSheet.show(
        context,
        title: copy['Title'],
        onBack: () {},
        child: Center(child: Text(copy['Sheet content goes here'])),
      ),
      child: Text(copy['Show bottom sheet']),
    ),
  );
}
