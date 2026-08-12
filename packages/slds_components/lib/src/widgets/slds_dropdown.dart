import 'package:flutter/material.dart';

import '../tokens/slds_colors.dart';
import '../tokens/slds_spacing.dart';

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
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    this.value,
    this.onChanged,
    this.isRequired = false,
    this.helpText,
    this.errorText,
    this.hintText = 'Select an option',
    this.searchHintText = 'Search',
    this.enabled = true,
    this.color,
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
  final String hintText;
  final String searchHintText;
  final bool enabled;

  /// Overrides the token-driven focus/accent color for this instance only.
  final Color? color;

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

  bool get _hasError => widget.errorText != null && widget.errorText!.isNotEmpty;

  List<T> get _filtered {
    if (_query.isEmpty) return widget.items;
    final q = _query.toLowerCase();
    return widget.items.where((i) => widget.itemLabel(i).toLowerCase().contains(q)).toList();
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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = widget.color ?? scheme.primary;

    final borderColor = !widget.enabled
        ? scheme.outline.withValues(alpha: SldsColors.disabledOpacity)
        : _hasError
            ? scheme.error
            : (_open ? accent : scheme.outline);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: scheme.onSurface),
            children: [
              TextSpan(text: widget.label),
              if (widget.isRequired) TextSpan(text: ' *', style: TextStyle(color: scheme.error)),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: SldsSpacing.xs),
        InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(SldsSpacing.sm),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SldsSpacing.md,
              vertical: SldsSpacing.md,
            ),
            decoration: BoxDecoration(
              color: widget.enabled ? scheme.surface : scheme.onSurface.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(SldsSpacing.sm),
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
                    widget.value != null ? widget.itemLabel(widget.value as T) : widget.hintText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: widget.value != null
                              ? (widget.enabled
                                  ? scheme.onSurface
                                  : scheme.onSurface.withValues(alpha: SldsColors.disabledOpacity))
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
                      : scheme.onSurface.withValues(alpha: SldsColors.disabledOpacity),
                ),
              ],
            ),
          ),
        ),
        if (_open) ...[
          const SizedBox(height: SldsSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(SldsSpacing.sm),
              border: Border.all(color: scheme.outline),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(SldsSpacing.sm),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: (v) => setState(() => _query = v),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: widget.searchHintText,
                      prefixIcon: Icon(Icons.search, size: 20, color: scheme.onSurface.withValues(alpha: 0.5)),
                      isDense: true,
                      filled: true,
                      fillColor: scheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: SldsSpacing.md,
                        vertical: SldsSpacing.sm,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SldsSpacing.sm),
                        borderSide: BorderSide(color: scheme.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SldsSpacing.sm),
                        borderSide: BorderSide(color: scheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SldsSpacing.sm),
                        borderSide: BorderSide(color: accent),
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: _filtered.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(SldsSpacing.lg),
                          child: Text(
                            'No results',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurface.withValues(alpha: 0.5),
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
                            return InkWell(
                              onTap: () => _select(item),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SldsSpacing.md,
                                  vertical: SldsSpacing.md,
                                ),
                                color: selected ? scheme.onSurface.withValues(alpha: 0.06) : null,
                                child: Text(
                                  widget.itemLabel(item),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
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
        if (_hasError || (widget.helpText != null && widget.helpText!.isNotEmpty)) ...[
          const SizedBox(height: SldsSpacing.xs),
          Text(
            _hasError ? widget.errorText! : widget.helpText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _hasError
                      ? scheme.error
                      : scheme.onSurface.withValues(alpha: widget.enabled ? 0.6 : SldsColors.disabledOpacity),
                ),
          ),
        ],
      ],
    );
  }
}
