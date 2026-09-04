import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:slds_components/src/format/slds_format.dart';
import 'package:slds_components/src/l10n/slds_strings.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';
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
      width: widget.width ?? 320,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
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
          // Header: Clock Icon + Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.textPrimary, width: 1.5),
                ),
                child: Icon(
                  Icons.access_time,
                  size: 18,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.titleText ?? context.sldsStrings.setYourTime,
                  style: tokens.typography.title1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Divider
          Divider(
            color: colors.borderDefault.withValues(alpha: 0.6),
            height: 1,
          ),

          const SizedBox(height: 16),

          // Digital Time Input & AM/PM Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  child: Container(
                    width: 54,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _activeUnit == SldsTimePickerUnit.hour
                          ? colors.datePickerRangeHighlight
                          : colors.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _activeUnit == SldsTimePickerUnit.hour
                            ? primaryAccent
                            : colors.borderDefault,
                        width: _activeUnit == SldsTimePickerUnit.hour
                            ? 1.5
                            : 1.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _selectedHour12 < 10
                            ? '0$_selectedHour12'
                            : '$_selectedHour12',
                        style: tokens.typography.heading4.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Text(
                ':',
                style: tokens.typography.heading4.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),

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
                  child: Container(
                    width: 54,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _activeUnit == SldsTimePickerUnit.minute
                          ? colors.datePickerRangeHighlight
                          : colors.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _activeUnit == SldsTimePickerUnit.minute
                            ? primaryAccent
                            : colors.borderDefault,
                        width: _activeUnit == SldsTimePickerUnit.minute
                            ? 1.5
                            : 1.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _selectedMinute < 10
                            ? '0$_selectedMinute'
                            : '$_selectedMinute',
                        style: tokens.typography.heading4.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // AM/PM Segmented Control
              Row(
                children: [
                  Semantics(
                    // A segmented control: the reader must hear which of the
                    // two is active, which the design shows only in colour.
                    inMutuallyExclusiveGroup: true,
                    selected: _period == DayPeriod.am,
                    button: true,
                    label: context.sldsStrings.timePeriodAm,
                    excludeSemantics: true,
                    child: GestureDetector(
                      onTap: () => _setPeriod(DayPeriod.am),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Text(
                          context.sldsStrings.timePeriodAm,
                          style: tokens.typography.body1.copyWith(
                            fontWeight: FontWeight.bold,
                            // The gold accent measures 1.56:1 on the card, so
                            // painting the *selected* period in it made the
                            // active option the unreadable one. Selection is
                            // carried by weight and text colour instead; the
                            // unselected option drops the 0.6 alpha that put
                            // it at 2.93:1 (WCAG 1.4.3).
                            color: _period == DayPeriod.am
                                ? colors.textPrimary
                                : colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Semantics(
                    // A segmented control: the reader must hear which of the
                    // two is active, which the design shows only in colour.
                    inMutuallyExclusiveGroup: true,
                    selected: _period == DayPeriod.pm,
                    button: true,
                    label: context.sldsStrings.timePeriodPm,
                    excludeSemantics: true,
                    child: GestureDetector(
                      onTap: () => _setPeriod(DayPeriod.pm),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Text(
                          context.sldsStrings.timePeriodPm,
                          style: tokens.typography.body1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _period == DayPeriod.pm
                                ? colors.textPrimary
                                : colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Analog Radial Clock Dial
          Center(
            child: SizedBox(
              width: 210,
              height: 210,
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
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Footer Action Bar — SldsButton goes full-width below the
          // SldsBreakpoints.mobile screen width, so the row would overflow;
          // stack Cancel/Apply instead on mobile, matching the button's own
          // responsive behavior rather than fighting it.
          if (context.sldsIsMobile)
            Column(
              children: [
                SldsButton(
                  label: widget.applyText ?? context.sldsStrings.apply,
                  onPressed: () => widget.onApply?.call(_currentTimeOfDay),
                ),
                const SizedBox(height: 12),
                SldsButton(
                  label: widget.cancelText ?? context.sldsStrings.cancel,
                  onPressed: widget.onCancel,
                  variant: SldsButtonVariant.secondary,
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SldsButton(
                  label: widget.cancelText ?? context.sldsStrings.cancel,
                  onPressed: widget.onCancel,
                  variant: SldsButtonVariant.secondary,
                ),
                const SizedBox(width: 12),
                SldsButton(
                  label: widget.applyText ?? context.sldsStrings.apply,
                  onPressed: () => widget.onApply?.call(_currentTimeOfDay),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInteractiveClockOverlay(
    Color primaryAccent,
    Color numeralColor,
  ) {
    final isHour = _activeUnit == SldsTimePickerUnit.hour;
    final totalItems = isHour ? 12 : 12; // 12 numbers on clock face

    return Stack(
      children: List.generate(totalItems, (i) {
        final val = isHour ? (i == 0 ? 12 : i) : (i * 5);
        final angle = (i * 30 - 90) * (math.pi / 180);
        const radius = 82.0;

        final cx = 105.0 + radius * math.cos(angle);
        final cy = 105.0 + radius * math.sin(angle);

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
    final picked = await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SldsTimePickerDialog(
            initialTime: _selectedTime ?? const TimeOfDay(hour: 7, minute: 0),
            titleText: widget.titleText,
            cancelText: widget.cancelText ?? context.sldsStrings.cancel,
            applyText: widget.applyText ?? context.sldsStrings.apply,
            onApply: (TimeOfDay time) {
              Navigator.of(context).pop(time);
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
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
