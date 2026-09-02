import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsChip,
  path: '[Display & Data]',
)
Widget buildSldsChipUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final labelOverride = context.knobs.string(
    label: 'Label',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final label = labelOverride.isEmpty ? copy['Label'] : labelOverride;
  final showAvatar = context.knobs.boolean(
    label: 'Show avatar',
    initialValue: true,
  );
  final showIcon = context.knobs.boolean(
    label: 'Show leading icon',
    initialValue: false,
  );
  final deletable = context.knobs.boolean(
    label: 'Deletable',
    initialValue: true,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsChip(
      label: label,
      avatar: showAvatar
          ? const SldsAvatar(initials: 'LK', size: SldsAvatarSize.small)
          : null,
      icon: !showAvatar && showIcon ? Icons.add : null,
      onDeleted: deletable ? () {} : null,
      onTap: () {},
    ),
  );
}
