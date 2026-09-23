import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:slds_components/src/format/slds_format.dart';
import 'package:slds_components/src/l10n/slds_strings.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';
import 'package:slds_components/src/widgets/slds_focus.dart';
import 'package:slds_components/src/widgets/slds_text_field.dart';

/// Which unit is currently being edited in [SldsTimePickerDialog].
enum SldsTimePickerUnit {
  /// The hour ring is being edited.
  hour,

  /// The minute ring is being edited.
  minute,
}

/// SLDS Time Picker Dialog — the analog & digital modal dialog portion
/// of the time picker.
class SldsTimePickerDialog extends StatefulWidget {
  /// Creates the time picker dialog.
  const SldsTimePickerDialog({
    super.key,
    this.initialTime = const TimeOfDay(hour: 7, minute: 0),
    this.onTimeChanged,
    this.onCancel,
    this.onApply,
    this.titleText,
    this.cancelText,
    this.applyText,
    this.width,
  });

  /// Initially selected time of day. Defaults to 7:00 AM.
  final TimeOfDay initialTime;

  /// Callback when time changes.
  final ValueChanged<TimeOfDay>? onTimeChanged;

  /// Callback when Cancel button is tapped.
  final VoidCallback? onCancel;

  /// Callback when Apply button is tapped with selected [TimeOfDay].
  final ValueChanged<TimeOfDay>? onApply;

  /// Header title text.
  final String? titleText;

  /// Cancel button label.
  final String? cancelText;

  /// Apply button label.
  final String? applyText;

  /// Custom width constraint for responsiveness.
  final double? width;

  @override
  State<SldsTimePickerDialog> createState() => _SldsTimePickerDialogState();
}

class _SldsTimePickerDialogState extends State<SldsTimePickerDialog> {
  late int _selectedHour12;
  late int _selectedMinute;
  late DayPeriod _period;
  SldsTimePickerUnit _activeUnit = SldsTimePickerUnit.hour;

  @override
  void initState() {
    super.initState();
    final hour = widget.initialTime.hour;
    _period = hour >= 12 ? DayPeriod.pm : DayPeriod.am;
    _selectedHour12 = hour % 12 == 0 ? 12 : hour % 12;
    _selectedMinute = widget.initialTime.minute;
  }

  TimeOfDay get _currentTimeOfDay {
    int hour24;
    if (_period == DayPeriod.am) {
      hour24 = _selectedHour12 == 12 ? 0 : _selectedHour12;
    } else {
      hour24 = _selectedHour12 == 12 ? 12 : _selectedHour12 + 12;
    }
    return TimeOfDay(hour: hour24, minute: _selectedMinute);
  }

  void _notifyChanged() {
    widget.onTimeChanged?.call(_currentTimeOfDay);
  }

  void _setPeriod(DayPeriod newPeriod) {
    if (_period != newPeriod) {
      setState(() {
        _period = newPeriod;
      });
      _notifyChanged();
    }
  }

  void _selectHour(int hour) {
    setState(() {
      _selectedHour12 = hour;
    });
    _notifyChanged();
  }

  void _selectMinute(int minute) {
    setState(() {
      _selectedMinute = minute;
    });
    _notifyChanged();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final primaryAccent = context.slds.colors.buttonPrimaryBackground;

    return Container(
      // Figma's dialog (node 1093:12338) is a fixed 258px card — not a
      // 320px one; the widget's own default only applies when the caller
      // doesn't size it explicitly.
      width: widget.width ?? 258,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        // Figma: radius-3xl (16px), not a hardcoded 24.
        borderRadius: BorderRadius.circular(tokens.dimensions.radius3xl),
        border: Border.all(color: colors.borderDefault.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Clock Icon + Title. Figma's "Titel" row (1093:10789) is
          // a plain 24px clock glyph next to body_1 (16px) text, both
          // sitting on the border-bottom divider's padding — no circular
          // ring around the icon, and no separate heading-scale type.
          Row(
            children: [
              Icon(Icons.access_time, size: 24, color: colors.textPrimary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.titleText ?? context.sldsStrings.setYourTime,
                  style: tokens.typography.body1.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Divider
          Divider(
            color: colors.borderDefault.withValues(alpha: 0.6),
            height: 1,
          ),

          const SizedBox(height: 16),

          // Digital Time Input & AM/PM Row — Figma's Time row (1093:10792)
          // is a full-width Row: the hour/minute frame takes its intrinsic
          // width (4px between its boxes and the colon), and the AM/PM
          // group is flex-1 with justify-end, so it fills the rest and sits
          // hard against the card's right edge.
          Row(
            children: [
              // Hour Box
              Semantics(
                button: true,
                selected: _activeUnit == SldsTimePickerUnit.hour,
                label: context.sldsStrings.selectHour,
                value: '$_selectedHour12',
                excludeSemantics: true,
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _activeUnit = SldsTimePickerUnit.hour),
                  child: _buildTimeUnitBox(
                    tokens,
                    colors,
                    selected: _activeUnit == SldsTimePickerUnit.hour,
                    text: _selectedHour12 < 10
                        ? '0$_selectedHour12'
                        : '$_selectedHour12',
                  ),
                ),
              ),

              const SizedBox(width: 4),

              Text(
                ':',
                style: tokens.typography.heading4.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),

              const SizedBox(width: 4),

              // Minute Box
              Semantics(
                button: true,
                selected: _activeUnit == SldsTimePickerUnit.minute,
                label: context.sldsStrings.selectMinute,
                value: '$_selectedMinute',
                excludeSemantics: true,
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _activeUnit = SldsTimePickerUnit.minute),
                  child: _buildTimeUnitBox(
                    tokens,
                    colors,
                    selected: _activeUnit == SldsTimePickerUnit.minute,
                    text: _selectedMinute < 10
                        ? '0$_selectedMinute'
                        : '$_selectedMinute',
                  ),
                ),
              ),

              // AM/PM Segmented Control — Expanded + right alignment is
              // Figma's flex-1/justify-end. A tight 10px sits between the
              // two words, with no padding around them: the tap area comes
              // from SldsOverflowTapTarget, which meets the WCAG 2.5.8
              // floor invisibly instead of pushing AM and PM apart.
              //
              // FittedBox so the pair scales down rather than overflowing
              // this fixed 258px card once a 200% text scale (or a longer
              // localized marker) outgrows the space left beside the boxes.
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Semantics(
                          // A segmented control: the reader must hear which
                          // of the two is active, which the design shows
                          // only in colour.
                          inMutuallyExclusiveGroup: true,
                          selected: _period == DayPeriod.am,
                          button: true,
                          label: context.sldsStrings.timePeriodAm,
                          excludeSemantics: true,
                          child: SldsOverflowTapTarget(
                            onTap: () => _setPeriod(DayPeriod.am),
                            child: Text(
                              context.sldsStrings.timePeriodAm,
                              style: tokens.typography.title1.copyWith(
                                // Figma (1093:10797) paints the selected
                                // period in the gold accent directly —
                                // 1.56:1 against this white card, below WCAG
                                // 1.4.3's 3:1 floor even at this size and
                                // weight. Matched to spec on explicit
                                // design-system-owner sign-off; a colour
                                // vision or low-vision user relying on
                                // contrast alone won't be able to tell AM
                                // from PM here.
                                color: _period == DayPeriod.am
                                    ? colors.buttonPrimaryBackground
                                    : colors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Semantics(
                          // A segmented control: the reader must hear which
                          // of the two is active, which the design shows
                          // only in colour.
                          inMutuallyExclusiveGroup: true,
                          selected: _period == DayPeriod.pm,
                          button: true,
                          label: context.sldsStrings.timePeriodPm,
                          excludeSemantics: true,
                          child: SldsOverflowTapTarget(
                            onTap: () => _setPeriod(DayPeriod.pm),
                            child: Text(
                              context.sldsStrings.timePeriodPm,
                              style: tokens.typography.title1.copyWith(
                                color: _period == DayPeriod.pm
                                    ? colors.buttonPrimaryBackground
                                    : colors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Analog Radial Clock Dial — Figma's Clock frame (1093:10800) is
          // 204x204.
          Center(
            child: SizedBox(
              width: 204,
              height: 204,
              child: CustomPaint(
                painter: _RadialClockDialPainter(
                  activeUnit: _activeUnit,
                  selectedValue: _activeUnit == SldsTimePickerUnit.hour
                      ? _selectedHour12
                      : _selectedMinute,
                  primaryColor: primaryAccent,
                  borderColor: colors.borderDefault,
                  textColor: colors.textPrimary,
                ),
                child: _buildInteractiveClockOverlay(
                  primaryAccent,
                  colors.textStaticBlack,
                  dialSize: 204,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Footer Action Bar — Figma (1093:10906) has one layout at every
          // width: Cancel then Apply, side by side, each flex-[1_0_0] (equal
          // width, filling the row). Small button scale (28px tall,
          // radius-xl, body_2 text) matches this compact card rather than
          // SldsButton's own responsive full-width default.
          Row(
            children: [
              Expanded(
                child: SldsButton(
                  label: widget.cancelText ?? context.sldsStrings.cancel,
                  onPressed: widget.onCancel,
                  variant: SldsButtonVariant.secondary,
                  size: SldsButtonSize.small,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SldsButton(
                  label: widget.applyText ?? context.sldsStrings.apply,
                  onPressed: () => widget.onApply?.call(_currentTimeOfDay),
                  size: SldsButtonSize.small,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// The hour/minute digit box (Figma node 1093:10960/1093:10973): selected
  /// is a gold-tinted fill with no border, unselected is a plain white fill
  /// with a 1px default border — both share the same radius, padding and
  /// text style, content-sized rather than a fixed box.
  Widget _buildTimeUnitBox(
    SldsTokenSet tokens,
    SldsColorTokens colors, {
    required bool selected,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: selected ? colors.badgePendingBackground : colors.surfaceCard,
        borderRadius: BorderRadius.circular(tokens.dimensions.radiusXl),
        border: selected ? null : Border.all(color: colors.borderDefault),
      ),
      child: Text(
        text,
        style: tokens.typography.body2.copyWith(
          color: selected ? colors.buttonPrimaryBackground : colors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInteractiveClockOverlay(
    Color primaryAccent,
    Color numeralColor, {
    required double dialSize,
  }) {
    final isHour = _activeUnit == SldsTimePickerUnit.hour;
    final totalItems = isHour ? 12 : 12; // 12 numbers on clock face
    final center = dialSize / 2;
    // Matches _RadialClockDialPainter's hand length (outerRadius - 23), so
    // the tap targets land on the same ring the hand's numerals sit on.
    final labelRadius = center - 23;

    return Stack(
      children: List.generate(totalItems, (i) {
        final val = isHour ? (i == 0 ? 12 : i) : (i * 5);
        final angle = (i * 30 - 90) * (math.pi / 180);

        final cx = center + labelRadius * math.cos(angle);
        final cy = center + labelRadius * math.sin(angle);

        final isSelected = isHour
            ? (_selectedHour12 == val)
            : ((_selectedMinute / 5).round() * 5 % 60 == val);

        return Positioned(
          // Deliberately absolute, not PositionedDirectional: cx comes from
          // an angle on a clock face, and a clock reads clockwise in every
          // locale. Mirroring this would put 3 o'clock on the left.
          left: cx - 18,
          top: cy - 18,
          child: Semantics(
            button: true,
            selected: isSelected,
            label: '$val',
            excludeSemantics: true,
            child: GestureDetector(
              onTap: () {
                if (isHour) {
                  _selectHour(val);
                } else {
                  _selectMinute(val);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 36,
                height: 36,
                decoration: isSelected
                    ? BoxDecoration(
                        color: primaryAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryAccent.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      )
                    : null,
                child: Center(
                  child: Text(
                    isHour ? '$val' : (val < 10 ? '0$val' : '$val'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      // Both dial numerals sit on the clock face, which keeps
                      // its colour across palettes; selection is signalled by
                      // weight and the accent circle, not by colour.
                      color: numeralColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _RadialClockDialPainter extends CustomPainter {
  _RadialClockDialPainter({
    required this.activeUnit,
    required this.selectedValue,
    required this.primaryColor,
    required this.borderColor,
    required this.textColor,
  });

  final SldsTimePickerUnit activeUnit;
  final int selectedValue;
  final Color primaryColor;
  final Color borderColor;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;

    // Outer Circle Border
    final circlePaint = Paint()
      ..color = borderColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, outerRadius - 2, circlePaint);

    // Calculate angle for hand
    double angle;
    if (activeUnit == SldsTimePickerUnit.hour) {
      final hour = selectedValue % 12 == 0 ? 12 : selectedValue % 12;
      angle = (hour * 30 - 90) * (math.pi / 180);
    } else {
      angle = (selectedValue * 6 - 90) * (math.pi / 180);
    }

    final handRadius = outerRadius - 23;
    final handEnd = Offset(
      center.dx + handRadius * math.cos(angle),
      center.dy + handRadius * math.sin(angle),
    );

    // Clock hand line
    final handPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, handEnd, handPaint);

    // Pivot dot at center
    final pivotPaint = Paint()..color = primaryColor;
    canvas.drawCircle(center, 5, pivotPaint);
  }

  @override
  bool shouldRepaint(covariant _RadialClockDialPainter oldDelegate) {
    return oldDelegate.selectedValue != selectedValue ||
        oldDelegate.activeUnit != activeUnit ||
        oldDelegate.primaryColor != primaryColor;
  }
}

/// SLDS Time Picker field — an input field that displays the selected time
/// and opens the [SldsTimePickerDialog] when tapped.
class SldsTimePicker extends StatefulWidget {
  /// Creates a time picker field.
  const SldsTimePicker({
    required this.label,
    super.key,
    this.initialTime,
    this.onTimeChanged,
    this.hintText = 'HH:MM',
    this.helpText,
    this.errorText,
    this.enabled = true,
    this.isRequired = false,
    this.titleText,
    this.cancelText,
    this.applyText,
  });

  /// Visible label above the field, and its default accessible name.
  final String label;

  /// Time selected when the dialog first opens. Null leaves the field empty
  /// and starts the dialog at its own default.
  final TimeOfDay? initialTime;

  /// Called with the chosen time when the user applies the dialog.
  final ValueChanged<TimeOfDay>? onTimeChanged;

  /// Placeholder shown while no time is selected. Defaults to `HH:MM`.
  final String hintText;

  /// Guidance shown below the field. Hidden while [errorText] is set.
  final String? helpText;

  /// Validation message shown below the field. Non-null puts the field in
  /// its error state and announces it as an error.
  final String? errorText;

  /// Whether the field opens the dialog when tapped.
  final bool enabled;

  /// Marks the field as required, appending the required marker to the
  /// label and announcing it as required to a screen reader.
  final bool isRequired;

  /// Dialog heading. Null uses the library's localized default.
  final String? titleText;

  /// Label for the dialog's dismiss action. Null uses the localized default.
  final String? cancelText;

  /// Label for the dialog's confirm action. Null uses the localized default.
  final String? applyText;

  @override
  State<SldsTimePicker> createState() => _SldsTimePickerState();
}

class _SldsTimePickerState extends State<SldsTimePicker> {
  TimeOfDay? _selectedTime;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Not initState: the formatted value carries a localized AM/PM marker,
    // and Localizations cannot be read until dependencies are available.
    // Running here also re-formats the field when the locale changes.
    _controller.text = _formatTime(context, _selectedTime);
  }

  @override
  void didUpdateWidget(SldsTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTime != oldWidget.initialTime) {
      _selectedTime = widget.initialTime;
      _controller.text = _formatTime(context, _selectedTime);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(BuildContext context, TimeOfDay? time) {
    if (time == null) return '';
    final strings = context.sldsStrings;
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    // Numeric H:mm goes through the shared intl-backed formatter (§6)
    // rather than hand-built padding; the AM/PM marker stays the library's
    // own reviewed string (see SldsFormat.timeOfDay12 dartdoc).
    final numeric = context.sldsFormat.timeOfDay12(hour, time.minute);
    final period = time.period == DayPeriod.am
        ? strings.timePeriodAm
        : strings.timePeriodPm;
    return '$numeric $period';
  }

  Future<void> _showTimePicker(BuildContext context) async {
    // Resolved here, from this State's own context, rather than inside the
    // builder below: the builder runs against the dialog route's context,
    // where SldsLocalizations is not reliably in scope (Widgetbook installs
    // its delegates below the Navigator, so reading them there throws).
    final strings = context.sldsStrings;
    final cancelLabel = widget.cancelText ?? strings.cancel;
    final applyLabel = widget.applyText ?? strings.apply;

    final picked = await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // The dialog is a fixed ~500px column (header, digital row, 210px
          // dial, footer). On a short viewport — a landscape phone, or any
          // Widgetbook device preset under ~500px tall — that overflows the
          // screen and the RenderFlex throws. Scroll instead of clipping:
          // the dial must keep its size to stay tappable, so the content
          // cannot shrink to fit.
          child: SingleChildScrollView(
            child: SldsTimePickerDialog(
              initialTime: _selectedTime ?? const TimeOfDay(hour: 7, minute: 0),
              titleText: widget.titleText,
              cancelText: cancelLabel,
              applyText: applyLabel,
              onApply: (TimeOfDay time) {
                Navigator.of(context).pop(time);
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _controller.text = _formatTime(context, picked);
      });
      widget.onTimeChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // AbsorbPointer blocks the inner field's own tap semantics, so the
      // control is a button that opens a picker, not an editable field.
      button: true,
      enabled: widget.enabled,
      label: widget.label,
      value: _controller.text,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: widget.enabled ? () => _showTimePicker(context) : null,
        child: AbsorbPointer(
          child: SldsTextField(
            label: widget.label,
            controller: _controller,
            hintText: widget.hintText,
            helpText: widget.helpText,
            errorText: widget.errorText,
            enabled: widget.enabled,
            isRequired: widget.isRequired,
            trailingIcon: Icons.access_time,
          ),
        ),
      ),
    );
  }
}
