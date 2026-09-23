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
    final monthPill = Flexible(
      child: Container(
        // Figma's Base Button pill is exactly 36px tall.
        height: 36,
        // Figma's pill is p-6px all around (node 1091:8066), not just
        // horizontal — the vertical pad was missing, squeezing the icons
        // and text harder against the top/bottom border than spec.
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: colors.borderDefault),
          borderRadius: BorderRadius.circular(24),
          // Figma "Drop Shadow/xs" on the Base Button pill.
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
            Semantics(
              button: true,
              label: context.sldsStrings.previousMonth,
              child: SldsOverflowTapTarget(
                onTap: _previousMonth,
                child: const Icon(Icons.chevron_left, size: 14),
              ),
            ),
            Flexible(
              child: Padding(
                // Figma's month label Frame (1091:8068) is px-6 py-1, not
                // horizontal-only.
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 1,
                ),
                child: Text(
                  _monthNames[_displayedMonth.month - 1],
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.body2.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ),
            Semantics(
              button: true,
              label: context.sldsStrings.nextMonth,
              child: SldsOverflowTapTarget(
                onTap: _nextMonth,
                child: const Icon(Icons.chevron_right, size: 14),
              ),
            ),
          ],
        ),
      ),
    );

    // Year Selector Pill — SldsOverflowTapTarget, not SldsTapTarget, for
    // the same reason as the chevrons: this pill's own 36px height already
    // clears the 48dp tap floor vertically, so only the popup trigger
    // itself needs the hit-area boost, not a reserved 48px layout box.
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
      child: Container(
        height: 36,
        // Figma's pill is p-6px all around (node 1091:8059), matching the
        // month pill rather than a wider horizontal-only 10px.
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: colors.borderDefault),
          borderRadius: BorderRadius.circular(24),
          // Figma "Drop Shadow/xs" on the Base Button pill.
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
            Padding(
              // Figma's year label Frame (1091:8061) is px-6 py-1.
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 1,
              ),
              child: Text(
                '${_displayedMonth.year}',
                style: tokens.typography.body2.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 14),
          ],
        ),
      ),
    );

    // Weekdays Row — Figma's weekday cells are 40px tall, same as a day
    // cell, so the grid below lines up without a visual jump.
    final weekdaysRow = SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _weekdayNames
            .map(
              (day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: tokens.typography.body2.copyWith(
                      color: colors.textSecondary,
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
      // Figma "Date Pickers": a sunken surface, rounded-3xl, no border and
      // no panel-level shadow — the only shadows in the spec sit on the
      // month/year pills.
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        borderRadius: BorderRadius.circular(24),
      ),
      // Same fixed-height problem as the time picker: header, weekday row,
      // 6-week grid and footer come to ~500px, so any viewport shorter than
      // that overflows and the RenderFlex throws. The grid's cells must keep
      // their size to stay tappable, so scroll rather than shrink to fit.
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Figma: the header, weekday row and day grid sit in one block
            // with a bottom border (not a separate Divider) 12px below the
            // grid — the button row sits outside it, un-bordered.
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colors.borderDefault.withValues(alpha: 0.6),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Figma's "Month and Year" row (node 1090:7421) is
                  // gap-[8px] with no space-between — the pills sit close
                  // together, not pinned to opposite edges.
                  Row(
                    children: [
                      monthPill,
                      const SizedBox(width: 8),
                      yearPill,
                    ],
                  ),
                  // Figma: 8px from the header row to the weekday row.
                  const SizedBox(height: 8),
                  weekdaysRow,
                  // Figma: 8px from the weekday row to the day grid.
                  const SizedBox(height: 8),
                  _buildDaysGrid(
                    context,
                    primaryAccent,
                    rangeHighlight,
                    colors,
                  ),
                ],
              ),
            ),

            // Figma: 12px from the bordered block to the footer buttons.
            const SizedBox(height: 12),

            // Footer Action Bar — Figma has one layout at every width: Cancel
            // then Apply, side by side, each a fixed 80px at the Small
            // (28px) size. Flexible (not a bare SizedBox) lets a
            // long/translated label grow past that spec width instead of
            // overflowing the row.
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
      dayWidgets.add(
        Semantics(
          // The cell shows a bare "05". Announcing the full formatted date
          // is what makes the grid navigable — the month and year are only
          // in the header, and selection is conveyed by a colour swatch.
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

    // Render in 7-column Grid — Figma's "Date" row has a 1px row gap, tight
    // enough that adjacent range-highlight cells visually connect.
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 1,
      children: dayWidgets,
    );
  }
}

/// Base Date Cell representing all 5 distinct design states shown in the
/// specification:
/// 1. Neutral / Base day
/// 2. Hover / Highlighted day
/// 3. Selected day (vibrant circle badge, `buttonPrimaryBackground`)
/// 4. In-Range selection (connecting pill, `datePickerRangeHighlight`)
/// 5. Overflow / Muted day (faded text)
class _SldsBaseDateCell extends StatelessWidget {
  const _SldsBaseDateCell({
    required this.dayText,
    required this.primaryAccent,
    required this.rangeHighlight,
    this.isSelected = false,
    this.isRangeStart = false,
    this.isRangeEnd = false,
    this.isInRange = false,
    this.isOverflow = false,
    this.isDisabled = false,
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
          // No alpha: textTertiary is already the "de-emphasised" token and
          // clears 4.5:1 on its own. Compositing it at 40% dropped an
          // adjacent-month date to 1.74:1 — a real date, still selectable,
          // that a low-vision user could not read (WCAG 1.4.3).
          style: tokens.typography.body2.copyWith(color: colors.textTertiary),
        ),
      );
    }

    // The selected day sits on the gold accent circle, which is the same
    // colour in every palette, so its label is the static-black role rather
    // than the palette's own text colour.
    final textColor = isSelected
        ? colors.textStaticBlack
        : (isDisabled ? colors.disabledForeground : colors.textPrimary);

    // Range background decoration connecting start, in-between, and end
    BoxDecoration? rangeBackgroundDecoration;
    if (isInRange) {
      rangeBackgroundDecoration = BoxDecoration(color: rangeHighlight);
    } else if (isRangeStart && !isRangeEnd) {
      rangeBackgroundDecoration = BoxDecoration(
        color: rangeHighlight,
        // Directional: the range's first day is rounded on the leading edge,
        // which is the right-hand side when the calendar runs right-to-left.
        borderRadius: const BorderRadiusDirectional.horizontal(
          start: Radius.circular(20),
        ),
      );
    } else if (isRangeEnd && !isRangeStart) {
      rangeBackgroundDecoration = BoxDecoration(
        color: rangeHighlight,
        borderRadius: const BorderRadiusDirectional.horizontal(
          end: Radius.circular(20),
        ),
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
              style: tokens.typography.body2.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
