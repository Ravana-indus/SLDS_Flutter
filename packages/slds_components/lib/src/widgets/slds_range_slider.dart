import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// SLDS range slider — a single-thumb slider (drag, tap-to-jump, and
/// keyboard-adjustable, courtesy of Flutter's own [Slider]) reskinned with
/// the gold accent thumb/active-track and gray inactive-track, matching the
/// SLDS look. Fills the available parent width — wrap it in a [SizedBox]
/// to cap the width, or drop it straight into a responsive layout as-is.
///
/// For a caller-owned label/value readout, wrap this yourself; this widget
/// is just the reskinned control.
class SldsRangeSlider extends StatelessWidget {
  const SldsRangeSlider({
    required this.value,
    required this.onChanged,
    super.key,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.enabled = true,
    this.semanticLabel,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  /// Number of discrete steps between [min]/[max]; null for a continuous slider.
  final int? divisions;
  final bool enabled;

  /// Accessible name announced alongside the current value.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final accent = colors.buttonPrimaryBackground;
    final interactive = enabled && onChanged != null;

    final activeColor = interactive ? accent : colors.disabledForeground;
    final inactiveColor = interactive
        ? colors.borderDefault
        : colors.disabledBackground;
    final thumbColor = interactive ? accent : colors.disabledForeground;

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 4,
        activeTrackColor: activeColor,
        inactiveTrackColor: inactiveColor,
        thumbColor: thumbColor,
        overlayColor: accent.withValues(alpha: 0.12),
        thumbShape: const RoundSliderThumbShape(),
        disabledActiveTrackColor: colors.disabledForeground,
        disabledInactiveTrackColor: colors.disabledBackground,
        disabledThumbColor: colors.disabledForeground,
      ),
      child: Slider(
        value: value.clamp(min, max),
        onChanged: interactive ? onChanged : null,
        min: min,
        max: max,
        divisions: divisions,
        semanticFormatterCallback: semanticLabel == null
            ? null
            : (value) => '$semanticLabel: ${value.round()}',
      ),
    );
  }
}
