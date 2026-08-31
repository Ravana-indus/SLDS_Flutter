import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/slds_components.dart' show SldsTextField;
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_text_field.dart'
    show SldsTextField;

/// SLDS searchable dropdown/select — label (with required marker), a
/// closed-state field showing the current selection or a placeholder, and
/// an inline panel (search box + scrollable option list) that opens below
/// the field on tap and closes on selection. Same label/required/help/error
/// chrome as [SldsTextField].
///
/// Colors resolve from the ambient [Theme]'s [ColorScheme] (light/dark
/// aware); pass [color] to override the focus/accent color for one instance.
class SldsDropdown<T> extends StatefulWidget {
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

  final String label;

  /// The full option list; [searchHintText]'s search box filters this by
  /// [itemLabel] client-side (case-insensitive substring match).
  final List<T> items;
  final String Function(T item) itemLabel;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool isRequired;
  final String? helpText;
  final String? errorText;
  final String? hintText;
  final String? searchHintText;
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
    final scheme = Theme.of(context).colorScheme;
    final dimensions = context.slds.dimensions;
    final accent = scheme.primary;

    final borderColor = !widget.enabled
        ? scheme.outline.withValues(alpha: context.slds.opacities.disabled)
        : _hasError
        ? scheme.error
        : (_open ? accent : scheme.outline);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: scheme.onSurface),
            children: [
              TextSpan(text: widget.label),
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: scheme.error),
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
            borderRadius: BorderRadius.circular(dimensions.space8),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: dimensions.space12,
                vertical: dimensions.space12,
              ),
              decoration: BoxDecoration(
                color: widget.enabled
                    ? scheme.surface
                    : scheme.onSurface.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(dimensions.space8),
                // 1.5 matches every other field's focused-border weight
                // (SldsInput/SldsMobileNumberInput/SldsSearchBar's
                // emphasizedBorderWidth token) — this widget predates that
                // token system, so it's hardcoded here to stay in lockstep.
                border: Border.all(color: borderColor, width: _open ? 1.5 : 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.value != null
                          ? widget.itemLabel(widget.value as T)
                          : widget.hintText ??
                                context.sldsStrings.selectAnOption,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: widget.value != null
                            ? (widget.enabled
                                  ? scheme.onSurface
                                  : scheme.onSurface.withValues(
                                      alpha: context.slds.opacities.disabled,
                                    ))
                            : scheme.onSurface.withValues(alpha: 0.5),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 20,
                    color: widget.enabled
                        ? scheme.onSurface
                        : scheme.onSurface.withValues(
                            alpha: context.slds.opacities.disabled,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_open) ...[
          SizedBox(height: dimensions.space8),
          Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(dimensions.space8),
              border: Border.all(color: scheme.outline),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(dimensions.space8),
                  child: Semantics(
                    textField: true,
                    label: widget.searchHintText ?? context.sldsStrings.search,
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (v) => setState(() => _query = v),
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText:
                            widget.searchHintText ?? context.sldsStrings.search,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: scheme.onSurface.withValues(alpha: 0.5),
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: scheme.surface,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: dimensions.space12,
                          vertical: dimensions.space8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            dimensions.space8,
                          ),
                          borderSide: BorderSide(color: scheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            dimensions.space8,
                          ),
                          borderSide: BorderSide(color: scheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            dimensions.space8,
                          ),
                          borderSide: BorderSide(color: accent),
                        ),
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
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: scheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: dimensions.space12,
                                    vertical: dimensions.space12,
                                  ),
                                  color: selected
                                      ? scheme.onSurface.withValues(alpha: 0.06)
                                      : null,
                                  child: Text(
                                    widget.itemLabel(item),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: scheme.onSurface),
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _hasError
                  ? scheme.error
                  : scheme.onSurface.withValues(
                      alpha: widget.enabled
                          ? 0.6
                          : context.slds.opacities.disabled,
                    ),
            ),
          ),
        ],
      ],
    );
  }
}
