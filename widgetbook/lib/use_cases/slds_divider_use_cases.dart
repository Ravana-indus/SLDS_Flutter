import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsDivider, path: '[Layout]')
Widget buildSldsDividerUseCase(BuildContext context) {
  final showButton = context.knobs.boolean(label: 'Split with button', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SldsDivider(),
        const SizedBox(height: 24),
        SldsDivider(
          child: showButton
              ? SldsButton(
                  label: 'Button',
                  variant: SldsButtonVariant.tertiary,
                  leadingIcon: Icons.add,
                  onPressed: () {},
                )
              : null,
        ),
      ],
    ),
  );
}
