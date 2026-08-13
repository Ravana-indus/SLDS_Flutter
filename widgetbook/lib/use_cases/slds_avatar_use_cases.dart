import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum _Content { initials, icon }

@widgetbook.UseCase(name: 'Playground', type: SldsAvatar, path: '[Display & Data]')
Widget buildSldsAvatarUseCase(BuildContext context) {
  final initials = context.knobs.string(label: 'Initials', initialValue: 'LK');
  final content = context.knobs.object.dropdown(
    label: 'Content',
    options: _Content.values,
    labelBuilder: (c) => c.name,
    initialOption: _Content.initials,
  );
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: SldsAvatarSize.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsAvatarSize.medium,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsAvatar(
      initials: content == _Content.initials ? initials : null,
      size: size,
    ),
  );
}
