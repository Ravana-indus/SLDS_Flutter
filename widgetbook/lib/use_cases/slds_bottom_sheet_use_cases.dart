import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsBottomSheet,
  path: '[Navigation]',
)
Widget buildSldsBottomSheetUseCase(BuildContext context) {
  return Center(
    child: ElevatedButton(
      onPressed: () => SldsBottomSheet.show(
        context,
        title: 'Title',
        onBack: () {},
        child: const Center(child: Text('Sheet content goes here')),
      ),
      child: const Text('Show bottom sheet'),
    ),
  );
}
