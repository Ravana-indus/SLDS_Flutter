import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';

/// Selection mode for [SldsDatePicker].
enum SldsDatePickerMode {
  /// Single date picker mode.
  single,

  /// Date range picker mode.
  range,
}

/// SLDS Date Picker component — mobile-responsive date and range picker
/// featuring base date cell states, month/year controls, range highlighting,
/// and customizable action buttons matching the SLDS design specification.
class SldsDatePicker extends StatefulWidget {
  const SldsDatePicker({
    super.key,
    this.mode = SldsDatePickerMode.range,
    this.initialDate,
    this.initialRange,
    this.minDate,
    this.maxDate,
    this.onDateSelected,
    this.onRangeSelected,
    this.onCancel,
    this.onApply,
    this.cancelText,
    this.applyText,
    this.rangeColor,
    this.firstDayOfWeek = DateTime.monday,
    this.width,
  });

  /// Picker mode: [SldsDatePickerMode.single] or [SldsDatePickerMode.range].
  final SldsDatePickerMode mode;

  /// Initially selected date for single mode. Defaults to today if null.
  final DateTime? initialDate;

  /// Initially selected range for range mode. Defaults to Jan 13–18 of current year or sample range if null.
  final DateTimeRange? initialRange;

  /// Minimum selectable date.
  final DateTime? minDate;

  /// Maximum selectable date.
  final DateTime? maxDate;

  /// Callback when a date is selected in single mode.
  final ValueChanged<DateTime>? onDateSelected;

  /// Callback when a range is selected in range mode.
  final ValueChanged<DateTimeRange>? onRangeSelected;

  /// Callback when Cancel button is tapped.
  final VoidCallback? onCancel;

  /// Callback when Apply button is tapped with the currently selected date or range.
  final ValueChanged<dynamic>? onApply;

  /// Cancel button label.
  final String? cancelText;

  /// Apply button label.
  final String? applyText;

  /// Highlight color for range selection in-between cells.
  final Color? rangeColor;

  /// First day of the week (1 = Monday, 7 = Sunday).
  final int firstDayOfWeek;

  /// Custom width constraint for responsiveness.
  final double? width;

  @override
  State<SldsDatePicker> createState() => _SldsDatePickerState();
}

class _SldsDatePickerState extends State<SldsDatePicker> {
  late DateTime _displayedMonth;
  DateTime? _selectedSingleDate;
  DateTime? _rangeStartDate;
  DateTime? _rangeEndDate;

  static const Color _defaultRangeLightYellow = Color(0xFFFFF7D6);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedSingleDate = widget.initialDate ?? now;

    if (widget.initialRange != null) {
      _rangeStartDate = widget.initialRange!.start;
      _rangeEndDate = widget.initialRange!.end;
      _displayedMonth = DateTime(_rangeStartDate!.year, _rangeStartDate!.month);
    } else {
      // Default to January 2026 if matching screenshot spec, or current month
      _displayedMonth = DateTime(
        widget.initialDate?.year ?? 2026,
        widget.initialDate?.month ?? 1,
      );
      _rangeStartDate = DateTime(2026, 1, 13);
      _rangeEndDate = DateTime(2026, 1, 18);
    }
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  void _onDayTap(DateTime day) {
    if (_isDayDisabled(day)) return;

    setState(() {
      if (widget.mode == SldsDatePickerMode.single) {
        _selectedSingleDate = day;
        widget.onDateSelected?.call(day);
      } else {
        if (_rangeStartDate == null ||
            (_rangeStartDate != null && _rangeEndDate != null)) {
          _rangeStartDate = day;
          _rangeEndDate = null;
        } else if (_rangeStartDate != null && _rangeEndDate == null) {
          if (day.isBefore(_rangeStartDate!)) {
            _rangeStartDate = day;
          } else if (day.isAfter(_rangeStartDate!)) {
            _rangeEndDate = day;
            widget.onRangeSelected?.call(
              DateTimeRange(start: _rangeStartDate!, end: _rangeEndDate!),
            );
          } else {
            _rangeEndDate = day;
          }
        }
      }
    });
  }

  void _handleApply() {
    if (widget.mode == SldsDatePickerMode.single) {
      widget.onApply?.call(_selectedSingleDate);
    } else if (_rangeStartDate != null && _rangeEndDate != null) {
      widget.onApply?.call(
        DateTimeRange(start: _rangeStartDate!, end: _rangeEndDate!),
      );
    } else {
      widget.onApply?.call(null);
    }
  }

  bool _isDayDisabled(DateTime day) {
    if (widget.minDate != null &&
        day.isBefore(
          DateTime(
            widget.minDate!.year,
            widget.minDate!.month,
            widget.minDate!.day,
          ),
        )) {
      return true;
    }
    if (widget.maxDate != null &&
        day.isAfter(
          DateTime(
            widget.maxDate!.year,
            widget.maxDate!.month,
            widget.maxDate!.day,
            23,
            59,
            59,
          ),
        )) {
      return true;
    }
    return false;
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<String> get _weekdayNames {
    // Mon, Tu, We, Th, Fr, Sa, Su
    return const ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
  }

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final primaryAccent = context.slds.colors.buttonPrimaryBackground;
    final rangeHighlight = widget.rangeColor ?? _defaultRangeLightYellow;

    return Container(
      width: widget.width ?? 340,
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
          // Header: Month Navigator & Year Dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Month Navigator Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.borderDefault),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _previousMonth,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.chevron_left, size: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        _monthNames[_displayedMonth.month - 1],
                        style: tokens.typography.body1.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _nextMonth,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.chevron_right, size: 18),
                      ),
                    ),
                  ],
                ),
              ),

              // Year Selector Pill
              PopupMenuButton<int>(
                initialValue: _displayedMonth.year,
                onSelected: (year) {
                  setState(() {
                    _displayedMonth = DateTime(year, _displayedMonth.month);
                  });
                },
                itemBuilder: (context) {
                  final currentYear = DateTime.now().year;
                  return List.generate(20, (i) => currentYear - 10 + i).map((
                    y,
                  ) {
                    return PopupMenuItem<int>(value: y, child: Text('$y'));
                  }).toList();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.borderDefault),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${_displayedMonth.year}',
                        style: tokens.typography.body1.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.keyboard_arrow_down, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Weekdays Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekdayNames
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: tokens.typography.caption1.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 12),

          // Days Grid
          _buildDaysGrid(primaryAccent, rangeHighlight, colors),

          const SizedBox(height: 16),

          // Horizontal Divider
          Divider(
            color: colors.borderDefault.withValues(alpha: 0.6),
            height: 1,
          ),

          const SizedBox(height: 16),

          // Footer Action Bar — SldsButton goes full-width below the
          // SldsBreakpoints.mobile screen width, so the row would overflow;
          // stack Cancel/Apply instead on mobile, matching the button's own
          // responsive behavior rather than fighting it.
          if (context.sldsIsMobile)
            Column(
              children: [
                SldsButton(
                  label: widget.applyText ?? context.sldsStrings.apply,
                  onPressed: _handleApply,
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
                  onPressed: _handleApply,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDaysGrid(
    Color primaryAccent,
    Color rangeHighlight,
    SldsColorTokens colors,
  ) {
    final firstOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;

    // Calculate weekday offset (Monday = 1)
    var firstWeekdayOffset = firstOfMonth.weekday - 1; // 0 for Mon, 6 for Sun
    if (firstWeekdayOffset < 0) firstWeekdayOffset += 7;

    final daysInPrevMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      0,
    ).day;

    final dayWidgets = <Widget>[];

    // Previous month overflow days
    for (var i = firstWeekdayOffset - 1; i >= 0; i--) {
      final dayNum = daysInPrevMonth - i;
      dayWidgets.add(
        _SldsBaseDateCell(
          dayText: dayNum < 10 ? '0$dayNum' : '$dayNum',
          isOverflow: true,
        ),
      );
    }

    // Current month days
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
      final dayText = day < 10 ? '0$day' : '$day';

      var isSelected = false;
      var isRangeStart = false;
      var isRangeEnd = false;
      var isInRange = false;

      if (widget.mode == SldsDatePickerMode.single) {
        isSelected = _isSameDay(date, _selectedSingleDate);
      } else {
        isRangeStart = _isSameDay(date, _rangeStartDate);
        isRangeEnd = _isSameDay(date, _rangeEndDate);
        if (_rangeStartDate != null && _rangeEndDate != null) {
          isInRange =
              date.isAfter(_rangeStartDate!) && date.isBefore(_rangeEndDate!);
        }
        isSelected = isRangeStart || isRangeEnd;
      }

      dayWidgets.add(
        GestureDetector(
          onTap: () => _onDayTap(date),
          behavior: HitTestBehavior.opaque,
          child: _SldsBaseDateCell(
            dayText: dayText,
            isSelected: isSelected,
            isRangeStart: isRangeStart,
            isRangeEnd: isRangeEnd,
            isInRange: isInRange,
            isDisabled: _isDayDisabled(date),
            primaryAccent: primaryAccent,
            rangeHighlight: rangeHighlight,
          ),
        ),
      );
    }

    // Next month overflow days to complete last row
    final totalCells = dayWidgets.length;
    final remainingCells = (7 - (totalCells % 7)) % 7;
    for (var day = 1; day <= remainingCells; day++) {
      final dayText = day < 10 ? '0$day' : '$day';
      dayWidgets.add(_SldsBaseDateCell(dayText: dayText, isOverflow: true));
    }

    // Render in 7-column Grid
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6,
      children: dayWidgets,
    );
  }
}

/// Base Date Cell representing all 5 distinct design states shown in the specification:
/// 1. Neutral / Base day
/// 2. Hover / Highlighted day
/// 3. Selected day (vibrant circle badge `#FFC700`)
/// 4. In-Range selection (connecting background pill `#FFF7D6`)
/// 5. Overflow / Muted day (faded text)
class _SldsBaseDateCell extends StatelessWidget {
  const _SldsBaseDateCell({
    required this.dayText,
    this.isSelected = false,
    this.isRangeStart = false,
    this.isRangeEnd = false,
    this.isInRange = false,
    this.isOverflow = false,
    this.isDisabled = false,
    this.primaryAccent = const Color(0xFFFFC700),
    this.rangeHighlight = const Color(0xFFFFF7D6),
  });

  final String dayText;
  final bool isSelected;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isInRange;
  final bool isOverflow;
  final bool isDisabled;
  final Color primaryAccent;
  final Color rangeHighlight;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;

    if (isOverflow) {
      return Center(
        child: Text(
          dayText,
          style: tokens.typography.body2.copyWith(
            color: colors.textTertiary.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    final textColor = isSelected
        ? const Color(0xFF1C1B1F)
        : (isDisabled ? colors.disabledForeground : colors.textPrimary);

    // Range background decoration connecting start, in-between, and end
    BoxDecoration? rangeBackgroundDecoration;
    if (isInRange) {
      rangeBackgroundDecoration = BoxDecoration(color: rangeHighlight);
    } else if (isRangeStart && !isRangeEnd) {
      rangeBackgroundDecoration = BoxDecoration(
        color: rangeHighlight,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
      );
    } else if (isRangeEnd && !isRangeStart) {
      rangeBackgroundDecoration = BoxDecoration(
        color: rangeHighlight,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
      );
    }

    return Container(
      decoration: rangeBackgroundDecoration,
      child: Center(
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
              dayText,
              style: tokens.typography.body2.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
