import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';
import 'package:slds_components/src/widgets/slds_text_field.dart';

/// Which unit is currently being edited in [SldsTimePickerDialog].
enum SldsTimePickerUnit { hour, minute }

/// SLDS Time Picker Dialog — the analog & digital modal dialog portion
/// of the time picker.
class SldsTimePickerDialog extends StatefulWidget {
  const SldsTimePickerDialog({
    super.key,
    this.initialTime = const TimeOfDay(hour: 7, minute: 0),
    this.onTimeChanged,
    this.onCancel,
    this.onApply,
    this.titleText = 'Set Your Time',
    this.cancelText = 'Cancel',
    this.applyText = 'Apply',
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
  final String titleText;

  /// Cancel button label.
  final String cancelText;

  /// Apply button label.
  final String applyText;

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

  static const Color _defaultLightYellow = Color(0xFFFFF7D6);

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
                  widget.titleText,
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
              GestureDetector(
                onTap: () =>
                    setState(() => _activeUnit = SldsTimePickerUnit.hour),
                child: Container(
                  width: 54,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _activeUnit == SldsTimePickerUnit.hour
                        ? _defaultLightYellow
                        : colors.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _activeUnit == SldsTimePickerUnit.hour
                          ? primaryAccent
                          : colors.borderDefault,
                      width: _activeUnit == SldsTimePickerUnit.hour ? 1.5 : 1.0,
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

              Text(
                ':',
                style: tokens.typography.heading4.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),

              // Minute Box
              GestureDetector(
                onTap: () =>
                    setState(() => _activeUnit = SldsTimePickerUnit.minute),
                child: Container(
                  width: 54,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _activeUnit == SldsTimePickerUnit.minute
                        ? _defaultLightYellow
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

              const SizedBox(width: 8),

              // AM/PM Segmented Control
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _setPeriod(DayPeriod.am),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: Text(
                        'AM',
                        style: tokens.typography.body1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _period == DayPeriod.am
                              ? primaryAccent
                              : colors.textSecondary.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _setPeriod(DayPeriod.pm),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: Text(
                        'PM',
                        style: tokens.typography.body1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _period == DayPeriod.pm
                              ? primaryAccent
                              : colors.textSecondary.withValues(alpha: 0.6),
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
                child: _buildInteractiveClockOverlay(primaryAccent),
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
                  label: widget.applyText,
                  onPressed: () => widget.onApply?.call(_currentTimeOfDay),
                ),
                const SizedBox(height: 12),
                SldsButton(
                  label: widget.cancelText,
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
                  label: widget.cancelText,
                  onPressed: widget.onCancel,
                  variant: SldsButtonVariant.secondary,
                ),
                const SizedBox(width: 12),
                SldsButton(
                  label: widget.applyText,
                  onPressed: () => widget.onApply?.call(_currentTimeOfDay),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInteractiveClockOverlay(Color primaryAccent) {
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
          left: cx - 18,
          top: cy - 18,
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
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF1C1B1F)
                        : const Color(0xFF1C1B1F),
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
    this.titleText = 'Set Your Time',
    this.cancelText = 'Cancel',
    this.applyText = 'Apply',
  });

  final String label;
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay>? onTimeChanged;
  final String hintText;
  final String? helpText;
  final String? errorText;
  final bool enabled;
  final bool isRequired;
  final String titleText;
  final String cancelText;
  final String applyText;

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
    _controller = TextEditingController(text: _formatTime(_selectedTime));
  }

  @override
  void didUpdateWidget(SldsTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTime != oldWidget.initialTime) {
      _selectedTime = widget.initialTime;
      _controller.text = _formatTime(_selectedTime);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
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
            cancelText: widget.cancelText,
            applyText: widget.applyText,
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
        _controller.text = _formatTime(picked);
      });
      widget.onTimeChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
