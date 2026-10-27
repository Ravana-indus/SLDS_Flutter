import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/focused_demo.dart';

import '../support/demo_copy.dart';

@widgetbook.UseCase(name: 'Playground', type: SldsButton, path: '[Actions]')
Widget buildSldsButtonUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
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
  // Empty default rather than hardcoded English, so the Locale addon drives
  // the preview. Widgetbook resolves a knob from the URL query group when one
  // is present, so seeding `initialValue` with localized text would go stale
  // the moment the knob is written to the URL — the fallback must happen at
  // render time. Typing in the knob still overrides it.
  final labelOverride = context.knobs.string(
    label: 'Label',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final label = labelOverride.isEmpty ? copy['Continue'] : labelOverride;
  final showLeadingIcon = context.knobs.boolean(
    label: 'Leading icon',
    initialValue: false,
  );
  final showTrailingIcon = context.knobs.boolean(
    label: 'Trailing icon',
    initialValue: true,
  );
  final isLoading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  // Flutter buttons take focus from the keyboard, not from a click, and
  // tabbing to the canvas means tabbing through the whole Widgetbook UI
  // first — so this knob moves focus onto the button directly.
  final isFocused = context.knobs.boolean(
    label: 'Focused',
    initialValue: false,
  );

  return FocusedDemo(
    focused: isFocused,
    builder: (focusNode) => SldsButton(
      focusNode: focusNode,
      label: label,
      variant: variant,
      size: size,
      isLoading: isLoading,
      leadingIcon: showLeadingIcon ? Icons.chevron_left : null,
      trailingIcon: showTrailingIcon ? Icons.chevron_right : null,
      onPressed: isEnabled ? () {} : null,
    ),
  );
}
