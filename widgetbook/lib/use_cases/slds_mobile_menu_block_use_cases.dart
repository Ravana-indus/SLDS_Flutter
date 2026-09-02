import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

/// The trailing affordances, as a knob-friendly list.
enum _Trailing { none, navigate, badge, validated, toggle, radio }

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsMobileMenuBlock,
  path: '[Navigation]',
)
Widget buildSldsMobileMenuBlockUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final titleOverride = context.knobs.string(
    label: 'Title',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final title = titleOverride.isEmpty ? copy['My Account'] : titleOverride;
  final subtitle = context.knobs.stringOrNull(
    label: 'Subtitle',
    initialValue: 'Name . Preferences',
  );
  final showLeadingIcon = context.knobs.boolean(
    label: 'Leading icon',
    initialValue: true,
  );
  final count = context.knobs.stringOrNull(
    label: 'Count',
    initialValue: '03',
    description: 'The gold bubble; leave empty to hide it',
  );
  final trailing = context.knobs.object.dropdown<_Trailing>(
    label: copy['Trailing'],
    options: _Trailing.values,
    initialOption: _Trailing.navigate,
    labelBuilder: (v) => v.name,
  );
  final showDivider = context.knobs.boolean(
    label: 'Divider',
    initialValue: true,
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return SldsMobileMenuBlock(
    title: title,
    subtitle: subtitle,
    leadingIcon: showLeadingIcon ? Icons.account_circle_outlined : null,
    count: (count?.isEmpty ?? true) ? null : count,
    enabled: isEnabled,
    showDivider: showDivider,
    trailing: switch (trailing) {
      _Trailing.none => null,
      _Trailing.navigate => SldsMobileMenuTrailing.navigate(),
      _Trailing.badge => SldsMobileMenuTrailing.badge(label: copy['Accepted']),
      _Trailing.validated => SldsMobileMenuTrailing.validated(),
      _Trailing.toggle => SldsMobileMenuTrailing.control(
        SldsToggle(value: true, onChanged: (_) {}, semanticLabel: title),
      ),
      _Trailing.radio => SldsMobileMenuTrailing.control(
        SldsRadio<bool>(
          value: true,
          groupValue: true,
          onChanged: (_) {},
          semanticLabel: title,
        ),
      ),
    },
    // A row whose trailing control owns the interaction takes no onTap of
    // its own, so the two do not compete for the same gesture.
    onTap:
        isEnabled && trailing != _Trailing.toggle && trailing != _Trailing.radio
        ? () {}
        : null,
  );
}
