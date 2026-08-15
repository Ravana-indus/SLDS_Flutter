import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/slds_components.dart' show SldsFilterButton;
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';
import 'package:slds_components/src/widgets/slds_checkbox.dart';
import 'package:slds_components/src/widgets/slds_filter_button.dart'
    show SldsFilterButton;
import 'package:slds_components/src/widgets/slds_radio.dart';

/// SLDS filter dropdown panel — a standalone option list (checkboxes for
/// [multiple], radios otherwise) in a bordered card with a Cancel/Apply
/// footer. Not attached to any field — show it yourself from whatever
/// trigger opens it (e.g. below an [SldsFilterButton], in a popover, bottom
/// sheet, or dialog).
///
/// Controlled and staged: [selectedValues] is what's currently checked
/// on-screen (uncommitted); [onApply] fires once, with the final selection,
/// when Apply is tapped. [onCancel] discards without calling [onApply].
class SldsFilterDropdown extends StatelessWidget {
  const SldsFilterDropdown({
    required this.options,
    required this.selectedValues,
    required this.onSelectionChanged,
    super.key,
    this.onApply,
    this.onCancel,
    this.multiple = true,
    this.cancelText,
    this.applyText,
    this.width,
  });

  final List<String> options;

  /// The in-progress (not yet applied) selection.
  final List<String> selectedValues;

  /// Fires as the user checks/unchecks or picks a radio option — update
  /// [selectedValues] from this to keep the panel controlled.
  final ValueChanged<List<String>> onSelectionChanged;

  /// Fires once with the final [selectedValues] when Apply is tapped.
  final ValueChanged<List<String>>? onApply;

  /// Fires when Cancel is tapped — typically close the panel without
  /// committing [selectedValues].
  final VoidCallback? onCancel;

  /// Checkboxes (multi-select) when true, radios (single-select) when false.
  final bool multiple;

  final String? cancelText;
  final String? applyText;

  /// Preferred width, clamped to the available parent width.
  final double? width;

  void _toggle(String option) {
    final next = List<String>.of(selectedValues);
    if (multiple) {
      if (next.contains(option)) {
        next.remove(option);
      } else {
        next.add(option);
      }
    } else {
      next
        ..clear()
        ..add(option);
    }
    onSelectionChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return LayoutBuilder(
      builder: (context, constraints) {
        const figmaReferenceWidth = 280.0;
        final requestedWidth =
            width ??
            (constraints.hasBoundedWidth
                ? constraints.maxWidth
                : figmaReferenceWidth);
        final resolvedWidth = constraints.hasBoundedWidth
            ? requestedWidth.clamp(0.0, constraints.maxWidth)
            : requestedWidth;

        return Container(
          width: resolvedWidth,
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            border: Border.all(color: colors.borderDefault),
            borderRadius: BorderRadius.circular(dimensions.radius2xl),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: dimensions.space8),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final selected = selectedValues.contains(option);
                    return InkWell(
                      onTap: () => _toggle(option),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: dimensions.space16,
                          vertical: dimensions.space12,
                        ),
                        child: Row(
                          children: [
                            if (multiple)
                              SldsCheckbox(
                                value: selected,
                                size: SldsCheckboxSize.small,
                                onChanged: (_) => _toggle(option),
                              )
                            else
                              SldsRadio<bool>(
                                value: true,
                                groupValue: selected ? true : null,
                                size: SldsRadioSize.small,
                                onChanged: (_) => _toggle(option),
                              ),
                            SizedBox(width: dimensions.space12),
                            Expanded(
                              child: Text(
                                option,
                                style: tokens.typography.body1.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(height: 1, color: colors.borderDefault),
              Padding(
                padding: EdgeInsets.all(dimensions.space12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SldsButton(
                      label: cancelText ?? context.sldsStrings.cancel,
                      onPressed: onCancel,
                      variant: SldsButtonVariant.text,
                    ),
                    SizedBox(width: dimensions.space8),
                    SldsButton(
                      label: applyText ?? context.sldsStrings.apply,
                      onPressed: () => onApply?.call(selectedValues),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
