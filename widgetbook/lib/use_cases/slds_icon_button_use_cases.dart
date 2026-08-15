import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsIconButton, path: '[Actions]')
Widget buildSldsIconButtonUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown<SldsButtonVariant>(
    label: 'Variant',
    options: SldsButtonVariant.values,
    labelBuilder: (v) => v.name,
  );
  // Nullable: leaving this unset is the shipped default, where the button
  // picks extraLarge/large off the breakpoint. Drive the Viewport addon to
  // watch that switch, or pin a size here to override it.
  final size = context.knobs.objectOrNull.dropdown<SldsButtonSize>(
    label: 'Size',
    options: SldsButtonSize.values,
    labelBuilder: (v) => v.name,
    defaultToNull: true,
    description: 'Unset follows the breakpoint (mobile: XL, desktop: large)',
  );
  // The glyph is the whole control here, so it is worth a knob — the icon
  // scales with the size, which is easiest to see by swapping shapes.
  final icon = context.knobs.object.dropdown<IconData>(
    label: 'Icon',
    options: const [Icons.add, Icons.close, Icons.search, Icons.more_vert],
    labelBuilder: (v) => switch (v) {
      Icons.close => 'close',
      Icons.search => 'search',
      Icons.more_vert => 'more_vert',
      _ => 'add',
    },
  );
  final isLoading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  // Doubles as the accessible name, so it is editable rather than hardcoded.
  final tooltip = context.knobs.string(label: 'Tooltip', initialValue: 'Add');

  return SldsIconButton(
    icon: icon,
    variant: variant,
    size: size,
    isLoading: isLoading,
    tooltip: tooltip,
    onPressed: isEnabled ? () {} : null,
  );
}
