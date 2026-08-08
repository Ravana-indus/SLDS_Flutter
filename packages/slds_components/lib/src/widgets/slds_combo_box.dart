import 'package:flutter/material.dart';

import '../tokens/slds_colors.dart';
import '../tokens/slds_spacing.dart';
import 'slds_checkbox.dart';

/// SLDS multi-select combo box — like [SldsDropdown] but [value] is a
/// `List<T>`: the closed field shows each selection as a removable chip
/// (wrapping onto new lines as more are picked), and the panel's option
/// list rows carry checkboxes instead of a single highlighted row.
///
/// Colors resolve from the ambient [Theme]'s [ColorScheme] (light/dark
/// aware); pass [color] to override the focus/accent color for one instance.
class SldsComboBox<T> extends StatefulWidget {
  const SldsComboBox({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    this.value = const [],
    this.onChanged,
    this.isRequired = false,
    this.helpText,
    this.errorText,
    this.hintText = 'Select district',
    this.searchHintText = 'Search',
    this.enabled = true,
    this.color,
  });

  final String label;

  /// The full option list; [searchHintText]'s search box filters this by
  /// [itemLabel] client-side (case-insensitive substring match).
  final List<T> items;
  final String Function(T item) itemLabel;
  final List<T> value;
  final ValueChanged<List<T>>? onChanged;
  final bool isRequired;
  final String? helpText;
  final String? errorText;
  final String hintText;
  final String searchHintText;
  final bool enabled;

  /// Overrides the token-driven focus/accent color for this instance only.
  final Color? color;

  @override
  State<SldsComboBox<T>> createState() => _SldsComboBoxState<T>();
}

class _SldsComboBoxState<T> extends State<SldsComboBox<T>> {
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

  void _toggleOpen() {
    if (!widget.enabled) return;
    setState(() {
      _open = !_open;
      if (!_open) {
        _query = '';
        _searchController.clear();
      }
    });
  }

  void _toggleItem(T item) {
    final next = List<T>.from(widget.value);
    if (next.contains(item)) {
      next.remove(item);
    } else {
      next.add(item);
    }
    widget.onChanged?.call(next);
  }

  void _remove(T item) {
    final next = List<T>.from(widget.value)..remove(item);
    widget.onChanged?.call(next);
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
          onTap: _toggleOpen,
          borderRadius: BorderRadius.circular(SldsSpacing.sm),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(
              horizontal: SldsSpacing.md,
              vertical: SldsSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: widget.enabled ? scheme.surface : scheme.onSurface.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(SldsSpacing.sm),
              border: Border.all(color: borderColor, width: _open ? 2 : 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: widget.value.isEmpty
                      ? Text(
                          widget.hintText,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: scheme.onSurface.withValues(alpha: 0.5),
                              ),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Wrap(
                          spacing: SldsSpacing.xs,
                          runSpacing: SldsSpacing.xs,
                          children: [
                            for (final item in widget.value)
                              _SelectedChip(
                                label: widget.itemLabel(item),
                                enabled: widget.enabled,
                                onRemove: () => _remove(item),
                              ),
                          ],
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
                            final selected = widget.value.contains(item);
                            return InkWell(
                              onTap: () => _toggleItem(item),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SldsSpacing.md,
                                  vertical: SldsSpacing.md,
                                ),
                                color: selected ? scheme.onSurface.withValues(alpha: 0.06) : null,
                                child: Row(
                                  children: [
                                    SldsCheckbox(
                                      value: selected,
                                      onChanged: (_) => _toggleItem(item),
                                      size: SldsCheckboxSize.small,
                                      color: widget.color,
                                    ),
                                    const SizedBox(width: SldsSpacing.sm),
                                    Text(
                                      widget.itemLabel(item),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: scheme.onSurface),
                                    ),
                                  ],
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

class _SelectedChip extends StatelessWidget {
  const _SelectedChip({required this.label, required this.enabled, required this.onRemove});

  final String label;
  final bool enabled;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SldsSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(SldsSpacing.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: enabled ? scheme.onSurface : scheme.onSurface.withValues(alpha: SldsColors.disabledOpacity),
                ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: enabled ? onRemove : null,
            child: Icon(Icons.close, size: 14, color: scheme.onSurface.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}
