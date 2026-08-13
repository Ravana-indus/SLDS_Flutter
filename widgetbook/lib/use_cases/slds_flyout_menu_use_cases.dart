import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _items = [
  SldsFlyoutMenuItem(
    label: 'Navigation 01',
    groups: [
      SldsFlyoutMenuGroup(
        header: 'Powerful and Simple Analytics',
        entries: [
          SldsFlyoutMenuEntry(icon: Icons.person_outline, label: 'Interactive Reports'),
          SldsFlyoutMenuEntry(icon: Icons.home_outlined, label: 'Team Dashboard & Alerts'),
          SldsFlyoutMenuEntry(icon: Icons.description_outlined, label: 'Group Analytics'),
        ],
      ),
      SldsFlyoutMenuGroup(
        header: 'Tools for Trusted Data',
        entries: [
          SldsFlyoutMenuEntry(icon: Icons.security_outlined, label: 'Data Integrations'),
          SldsFlyoutMenuEntry(icon: Icons.storage_outlined, label: 'Data Management'),
          SldsFlyoutMenuEntry(icon: Icons.shield_outlined, label: 'Security & Privacy'),
        ],
      ),
    ],
  ),
  SldsFlyoutMenuItem(label: 'Navigation 02'),
  SldsFlyoutMenuItem(label: 'Navigation 03'),
  SldsFlyoutMenuItem(label: 'Navigation 04'),
  SldsFlyoutMenuItem(label: 'Navigation 05'),
];

@widgetbook.UseCase(name: 'Playground', type: SldsFlyoutMenu, path: '[Navigation]')
Widget buildSldsFlyoutMenuUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsFlyoutMenu(items: _items),
  );
}

@widgetbook.UseCase(name: 'Modal', type: SldsFlyoutMenu, path: '[Navigation]')
Widget buildSldsFlyoutMenuModalUseCase(BuildContext context) {
  return Center(
    child: Builder(
      builder: (context) => SldsButton(
        label: 'Open menu',
        onPressed: () => showSldsFlyoutMenu(context, items: _items),
      ),
    ),
  );
}
