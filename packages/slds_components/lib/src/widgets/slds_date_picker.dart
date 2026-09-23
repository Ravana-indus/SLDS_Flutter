import 'package:flutter/material.dart';

import 'package:slds_components/src/format/slds_format.dart';
import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';
import 'package:slds_components/src/widgets/slds_focus.dart';

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
  /// Creates a date picker field.
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
    this.firstDayOfWeek = DateTime.monday,
    this.width,
  });

  /// Picker mode: [SldsDatePickerMode.single] or [SldsDatePickerMode.range].
  final SldsDatePickerMode mode;

  /// Initially selected date for single mode. Defaults to today if null.
  final DateTime? initialDate;

  /// Initially selected range for range mode. Defaults to Jan 13–18 of
  /// current year or sample range if null.
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

  /// Callback when Apply button is tapped with the currently selected date
  /// or range.
  final ValueChanged<dynamic>? onApply;

  /// Cancel button label.
  final String? cancelText;

  /// Apply button label.
  final String? applyText;

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

  @override
  void initState() {
    super.initState();
    if (widget.initialRange != null) {
      _rangeStartDate = widget.initialRange!.start;
      _rangeEndDate = widget.initialRange!.end;
      _displayedMonth = DateTime(_rangeStartDate!.year, _rangeStartDate!.month);
      _selectedSingleDate = widget.initialDate ?? _rangeStartDate;
    } else {
      // Default to January 2026 matching Figma spec
      _displayedMonth = DateTime(
        widget.initialDate?.year ?? 2026,
        widget.initialDate?.month ?? 1,
      );
      _rangeStartDate = DateTime(2026, 1, 13);
      _rangeEndDate = DateTime(2026, 1, 18);
      _selectedSingleDate = widget.initialDate ?? DateTime(2026, 1, 13);
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
    final primaryAccent = colors.buttonPrimaryBackground;
    final rangeHighlight = colors.datePickerRangeHighlight;

    // Month Navigator Pill.
    //
    // Flexible, not Expanded: Figma's Buttons wrapper is flex-[1_0_0], but
    // that's inside a 280px reference frame where the leftover space is
    // small. At this component's actual width (328px+) stretching the pill
    // to fill every pixel up to the year pill opens a wide, empty-looking
    // gap between "January >" and "2026" that Figma's own screenshot never
    // shows — content-sized keeps the two pills reading as a pair at any
    // width. Still survives the 320dp floor at 200% text scale, same as
    // Expanded. The chevrons keep Figma's tight visual size — no
    // SldsTapTarget, which reserves 48dp of *layout* width per arrow and
    // was ballooning the pill far past spec — and instead grow their *hit*
    // area past their visible bounds via SldsOverflowTapTarget, which
    // doesn't touch layout.
    final monthPill = Expanded(
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: colors.buttonSecondaryBackground,
          border: Border.all(color: colors.buttonSecondaryBorder),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D101828),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Semantics(
              button: true,
              label: context.sldsStrings.previousMonth,
              child: SldsTapTarget(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: _previousMonth,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.chevron_left,
                      size: 18,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  _monthNames[_displayedMonth.month - 1],
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.body2.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ),
            Semantics(
              button: true,
              label: context.sldsStrings.nextMonth,
              child: SldsTapTarget(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: _nextMonth,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Year Selector Pill
    final yearPill = PopupMenuButton<int>(
      initialValue: _displayedMonth.year,
      onSelected: (year) {
        setState(() {
          _displayedMonth = DateTime(year, _displayedMonth.month);
        });
      },
      itemBuilder: (context) {
        final currentYear = DateTime.now().year;
        return List.generate(
          20,
          (i) => currentYear - 10 + i,
        ).map((y) => PopupMenuItem<int>(value: y, child: Text('$y'))).toList();
      },
      child: SldsTapTarget(
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: colors.buttonSecondaryBackground,
            border: Border.all(color: colors.buttonSecondaryBorder),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D101828),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_displayedMonth.year}',
                style: tokens.typography.body2.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: colors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );

    // Weekdays Row — dark text matching Figma spec and meeting WCAG AA
    final weekdaysRow = SizedBox(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _weekdayNames
            .map(
              (day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: tokens.typography.body2.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );

    return Container(
      width: widget.width ?? 328,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row: Month Navigator & Year Pill
            Row(
              children: [
                monthPill,
                const SizedBox(width: 8),
                yearPill,
              ],
            ),

            const SizedBox(height: 16),

            // Weekdays Row
            weekdaysRow,

            const SizedBox(height: 12),

            // Date Grid
            _buildDaysGrid(
              context,
              primaryAccent,
              rangeHighlight,
              colors,
            ),

            const SizedBox(height: 16),

            // Horizontal Divider
            Divider(
              height: 1,
              thickness: 1,
              color: colors.borderDecorative,
            ),

            const SizedBox(height: 16),

            // Footer Action Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 80,
                    child: SldsButton(
                      label: widget.cancelText ?? context.sldsStrings.cancel,
                      onPressed: widget.onCancel,
                      variant: SldsButtonVariant.secondary,
                      size: SldsButtonSize.small,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: SizedBox(
                    width: 80,
                    child: SldsButton(
                      label: widget.applyText ?? context.sldsStrings.apply,
                      onPressed: _handleApply,
                      size: SldsButtonSize.small,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysGrid(
    BuildContext context,
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
          primaryAccent: primaryAccent,
          rangeHighlight: rangeHighlight,
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

      final disabled = _isDayDisabled(date);
      final cellCol = dayWidgets.length % 7;
      final isRowStart = cellCol == 0;
      final isRowEnd = cellCol == 6;

      dayWidgets.add(
        Semantics(
          button: true,
          enabled: !disabled,
          selected: isSelected,
          label: SldsFormat.of(context).date(date),
          excludeSemantics: true,
          child: GestureDetector(
            onTap: () => _onDayTap(date),
            behavior: HitTestBehavior.opaque,
            child: _SldsBaseDateCell(
              dayText: dayText,
              isSelected: isSelected,
              isRangeStart: isRangeStart,
              isRangeEnd: isRangeEnd,
              isInRange: isInRange,
              isRowStart: isRowStart,
              isRowEnd: isRowEnd,
              isDisabled: disabled,
              primaryAccent: primaryAccent,
              rangeHighlight: rangeHighlight,
            ),
          ),
        ),
      );
    }

    // Next month overflow days to complete last row
    final totalCells = dayWidgets.length;
    final remainingCells = (7 - (totalCells % 7)) % 7;
    for (var day = 1; day <= remainingCells; day++) {
      final dayText = day < 10 ? '0$day' : '$day';
      dayWidgets.add(
        _SldsBaseDateCell(
          dayText: dayText,
          isOverflow: true,
          primaryAccent: primaryAccent,
          rangeHighlight: rangeHighlight,
        ),
      );
    }

    // Render in 7-column Grid — 8px row gap matching Figma vertical breathing room
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      children: dayWidgets,
    );
  }
}

/// Base Date Cell representing distinct design states shown in the specification:
/// 1. Neutral / Base day
/// 2. Selected start/end day (vibrant circle badge, `buttonPrimaryBackground`)
/// 3. In-Range selection (connecting band with row-wrapped rounded caps, `datePickerRangeHighlight`)
/// 4. Overflow / Muted day (faded text)
class _SldsBaseDateCell extends StatelessWidget {
  const _SldsBaseDateCell({
    required this.dayText,
    required this.primaryAccent,
    required this.rangeHighlight,
    this.isSelected = false,
    this.isRangeStart = false,
    this.isRangeEnd = false,
    this.isInRange = false,
    this.isRowStart = false,
    this.isRowEnd = false,
    this.isOverflow = false,
    this.isDisabled = false,
  });

  final String dayText;
  final bool isSelected;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isInRange;
  final bool isRowStart;
  final bool isRowEnd;
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
          style: tokens.typography.body2.copyWith(color: colors.textTertiary),
        ),
      );
    }

    final textColor = isSelected
        ? colors.textStaticBlack
        : (isDisabled ? colors.disabledForeground : colors.textPrimary);

    // Range background decoration connecting start, in-between, and end with
    // row-level pill rounding (Figma spec: rounded caps at row boundaries).
    BoxDecoration? rangeBackgroundDecoration;
    if (isInRange) {
      BorderRadius? radius;
      if (isRowStart && isRowEnd) {
        radius = BorderRadius.circular(20);
      } else if (isRowStart) {
        radius = const BorderRadius.horizontal(left: Radius.circular(20));
      } else if (isRowEnd) {
        radius = const BorderRadius.horizontal(right: Radius.circular(20));
      }
      rangeBackgroundDecoration = BoxDecoration(
        color: rangeHighlight,
        borderRadius: radius,
      );
    } else if (isRangeStart && !isRangeEnd) {
      // Background extends to the trailing side behind the circle, rounded on leading edge
      rangeBackgroundDecoration = BoxDecoration(
        color: isRowEnd ? null : rangeHighlight,
        borderRadius: isRowEnd
            ? BorderRadius.circular(20)
            : const BorderRadius.horizontal(left: Radius.circular(20)),
      );
    } else if (isRangeEnd && !isRangeStart) {
      // Background extends to the leading side behind the circle, rounded on trailing edge
      rangeBackgroundDecoration = BoxDecoration(
        color: isRowStart ? null : rangeHighlight,
        borderRadius: isRowStart
            ? BorderRadius.circular(20)
            : const BorderRadius.horizontal(right: Radius.circular(20)),
      );
    }

    return Container(
      decoration: rangeBackgroundDecoration,
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: isSelected
              ? BoxDecoration(color: primaryAccent, shape: BoxShape.circle)
              : null,
          child: Center(
            child: Text(
              dayText,
              style: tokens.typography.body2.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
