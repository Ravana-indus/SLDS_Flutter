import 'package:flutter/material.dart';

import 'package:slds_components/slds_components.dart' show SldsTextField;
import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_text_field.dart'
    show SldsTextField;

/// SLDS searchable dropdown/select — label (with required marker), a
/// closed-state field showing the current selection or a placeholder, and
/// an inline panel (search box + scrollable option list) that opens below
/// the field on tap and closes on selection. Same label/required/help/error
/// chrome as [SldsTextField].
///
/// Colors resolve from the ambient [Theme]'s [ColorScheme], so the field
/// follows light, dark and high-contrast modes.
class SldsDropdown<T> extends StatefulWidget {
  /// Creates a searchable dropdown over [items].
  const SldsDropdown({
    required this.label,
    required this.items,
    required this.itemLabel,
    super.key,
    this.value,
    this.onChanged,
    this.isRequired = false,
    this.helpText,
    this.errorText,
    this.hintText,
    this.searchHintText,
    this.enabled = true,
    this.semanticLabel,
  });

  /// Visible label above the field, and its default accessible name.
  final String label;

  /// The full option list; [searchHintText]'s search box filters this by
  /// [itemLabel] client-side (case-insensitive substring match).
  final List<T> items;

  /// How an item is rendered as text — used for both the visible row and
  /// the search filter.
  final String Function(T item) itemLabel;

  /// The current selection. Null shows [hintText] instead.
  final T? value;

  /// Called with the newly selected item when the user picks one.
  final ValueChanged<T?>? onChanged;

  /// Marks the field as required, appending the required marker to the
  /// label and announcing it as required to a screen reader.
  final bool isRequired;

  /// Guidance shown below the field. Hidden while [errorText] is set.
  final String? helpText;

  /// Validation message shown below the field. Non-null puts the field in
  /// its error state and announces it as an error.
  final String? errorText;

  /// Placeholder shown in the closed field while nothing is selected.
  final String? hintText;

  /// Placeholder for the panel's search box. Null hides the search box, so
  /// the full [items] list is always shown.
  final String? searchHintText;

  /// Whether the field opens its panel when tapped.
  final bool enabled;

  /// Overrides the accessible name. Defaults to [label].
  final String? semanticLabel;

  @override
  State<SldsDropdown<T>> createState() => _SldsDropdownState<T>();
}

class _SldsDropdownState<T> extends State<SldsDropdown<T>> {
  bool _open = false;
  String _query = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  List<T> get _filtered {
    if (_query.isEmpty) return widget.items;
    final q = _query.toLowerCase();
    return widget.items
        .where((i) => widget.itemLabel(i).toLowerCase().contains(q))
        .toList();
  }

  void _toggle() {
    if (!widget.enabled) return;
    setState(() {
      _open = !_open;
      if (!_open) {
        _query = '';
        _searchController.clear();
      }
    });
  }

  void _select(T item) {
    widget.onChanged?.call(item);
    setState(() {
      _open = false;
      _query = '';
      _searchController.clear();
    });
  }

  /// The dropdown's accessible name: the label plus the state the design
  /// shows only in colour or glyph — the required asterisk, the error text,
  /// and whether the panel is open.
  String _semanticLabel(BuildContext context) {
    final strings = context.sldsStrings;
    final buffer = StringBuffer(widget.semanticLabel ?? widget.label);
    if (widget.isRequired) buffer.write(', ${strings.required}');
    buffer.write(', ${_open ? strings.expanded : strings.collapsed}');
    if (_hasError) buffer.write(', ${strings.error}: ${widget.errorText}');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    // Figma's open/"Filling" state (node 543:6451) keeps the field on its
    // plain default border — opening the panel isn't focus, so unlike
    // SldsInput/SldsTextField it never turns gold just for being open.
    final borderColor = !widget.enabled
        ? colors.inputBorderDisabled
        : _hasError
        ? colors.inputBorderError
        : colors.inputBorderDefault;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            style: tokens.typography.fieldLabel.copyWith(
              color: colors.inputLabel,
            ),
            children: [
              TextSpan(text: widget.label),
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: colors.inputBorderError),
                ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: dimensions.space4),
        Semantics(
          // Without this the node's name came from the value Text below —
          // so an empty dropdown announced as "Select an option" with no
          // hint of which field it was. The name is the label; the current
          // selection is the value, and open/closed is a state, not a name.
          button: true,
          enabled: widget.enabled,
          label: _semanticLabel(context),
          value: widget.value != null
              ? widget.itemLabel(widget.value as T)
              : '',
          // Without this the placeholder Text merges its own semantics in
          // and the name becomes "District, collapsed / Select an option" —
          // the very placeholder-as-name problem this wrapper exists to fix.
          excludeSemantics: true,
          child: InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(dimensions.radius2xl),
            child: Container(
              // Figma's Content node (543:6445) is a fixed 52px — matches
              // every other SLDS field (SldsInput/SldsTextField).
              height: dimensions.inputHeight,
              padding: EdgeInsets.symmetric(horizontal: dimensions.space12),
              decoration: BoxDecoration(
                color: widget.enabled
                    ? colors.surfaceCard
                    : colors.disabledBackground,
                // Figma: radius-2xl (12px), not 8.
                borderRadius: BorderRadius.circular(dimensions.radius2xl),
                border: Border.all(
                  color: borderColor,
                  width: widget.enabled
                      ? dimensions.controlBorderWidth
                      : dimensions.inputDisabledBorderWidth,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.value != null
                          ? widget.itemLabel(widget.value as T)
                          : widget.hintText ??
                                context.sldsStrings.selectAnOption,
                      style: tokens.typography.body1.copyWith(
                        color: widget.value != null
                            ? (widget.enabled
                                  ? colors.textPrimary
                                  : colors.disabledForeground)
                            : colors.inputPlaceholder,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 20,
                    color: widget.enabled
                        ? colors.textSecondary
                        : colors.disabledForeground,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_open) ...[
          SizedBox(height: dimensions.space8),
          Container(
            // Figma's "Open" panel (543:6460): surface/page bg,
            // border/decorative border, radius-3xl (16px) corner.
            decoration: BoxDecoration(
              color: colors.surfacePage,
              borderRadius: BorderRadius.circular(dimensions.radius3xl),
              border: Border.all(color: colors.borderDecorative),
            ),
            padding: EdgeInsets.symmetric(vertical: dimensions.space8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: dimensions.space8,
                  ),
                  child: Semantics(
                    textField: true,
                    label: widget.searchHintText ?? context.sldsStrings.search,
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (v) => setState(() => _query = v),
                      style: tokens.typography.body2.copyWith(
                        color: colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            widget.searchHintText ?? context.sldsStrings.search,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: colors.inputPlaceholder,
                        ),
                        isDense: true,
                        // The decorated field paints taller, but the
                        // text node itself is the tappable target and
                        // must clear the 48dp floor (WCAG 2.5.8).
                        constraints: BoxConstraints(
                          minHeight: dimensions.tapTargetMin,
                        ),
                        filled: true,
                        // Figma's Search Bar (node 543:6462) is
                        // surface/page — the same tone as the panel behind
                        // it, not a brighter card — with a plain
                        // border/decorative border throughout; it never
                        // turns gold, autofocus notwithstanding.
                        fillColor: colors.surfacePage,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: dimensions.space12,
                          vertical: dimensions.space8,
                        ),
                        // Same border in every state — Figma's search bar
                        // never shows a distinct focused style.
                        border: _searchBorder(dimensions, colors),
                        enabledBorder: _searchBorder(dimensions, colors),
                        focusedBorder: _searchBorder(dimensions, colors),
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: _filtered.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(dimensions.space16),
                          child: Text(
                            context.sldsStrings.noResults,
                            style: tokens.typography.body2.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: _filtered.length,
                          itemBuilder: (context, index) {
                            final item = _filtered[index];
                            final selected = item == widget.value;
                            return Semantics(
                              // Each row is a choice in a list: the reader
                              // needs to hear which one is already selected,
                              // not just the option's text.
                              button: true,
                              inMutuallyExclusiveGroup: true,
                              selected: selected,
                              label: widget.itemLabel(item),
                              child: InkWell(
                                onTap: () => _select(item),
                                child: Container(
                                  width: double.infinity,
                                  // Figma's list item (535:2487) is 44px
                                  // tall (h-[38px] row + 6px vertical
                                  // padding via py-12 on the 12px-lineheight
                                  // text) — match with a min height rather
                                  // than a hardcoded number.
                                  constraints: BoxConstraints(
                                    minHeight: dimensions.tapTargetMin,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: dimensions.space12,
                                    vertical: dimensions.space8,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: dimensions.space8,
                                  ),
                                  decoration: selected
                                      ? BoxDecoration(
                                          color: colors.buttonGhostHover,
                                          borderRadius: BorderRadius.circular(
                                            dimensions.radiusXl,
                                          ),
                                        )
                                      : null,
                                  child: Text(
                                    widget.itemLabel(item),
                                    style: tokens.typography.body2.copyWith(
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
        if (_hasError ||
            (widget.helpText != null && widget.helpText!.isNotEmpty)) ...[
          SizedBox(height: dimensions.space4),
          Text(
            _hasError ? widget.errorText! : widget.helpText!,
            style: tokens.typography.caption1.copyWith(
              color: _hasError ? colors.error : colors.inputHelper,
            ),
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _searchBorder(
    SldsDimensionTokens dimensions,
    SldsColorTokens colors,
  ) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(dimensions.radius2xl),
    borderSide: BorderSide(color: colors.borderDecorative),
  );
}
