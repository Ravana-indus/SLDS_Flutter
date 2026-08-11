import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// SLDS search bar — a pill-shaped field with a leading search icon and a
/// clear (×) trailing icon once text is entered, a gold focus ring, and an
/// optional suggestions panel that opens below while focused: a filtered
/// [suggestions] list plus a [recentSearches] section (clock icon per row).
///
/// Controlled like the rest of this package's search/select fields — no
/// suggestion source or persistence is baked in. Wire [controller]/
/// [onChanged] to filter [suggestions] yourself, and manage [recentSearches]
/// (e.g. persisted in shared_preferences) in your app.
///
/// ```dart
/// SldsSearchBar(
///   controller: _controller,
///   suggestions: _filtered,           // recompute from _controller.text
///   recentSearches: _recent,
///   onSuggestionSelected: (s) => _select(s),
///   onChanged: (q) => setState(() => _filtered = _filter(q)),
/// )
/// ```
class SldsSearchBar extends StatefulWidget {
  const SldsSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search',
    this.suggestions = const [],
    this.recentSearches = const [],
    this.recentSearchesLabel = 'RECENT SEARCHES',
    this.onChanged,
    this.onSubmitted,
    this.onSuggestionSelected,
    this.focusNode,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String hintText;

  /// Filtered suggestion labels shown at the top of the panel while focused
  /// and non-empty; recompute this list from [onChanged] as the query types.
  final List<String> suggestions;

  /// Prior search terms shown below [suggestions], each with a history icon.
  final List<String> recentSearches;

  /// Section heading above [recentSearches].
  final String recentSearchesLabel;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Invoked when a row in [suggestions] or [recentSearches] is tapped —
  /// typically you'll set the query to the tapped value and close the panel.
  final ValueChanged<String>? onSuggestionSelected;

  final FocusNode? focusNode;
  final bool enabled;

  @override
  State<SldsSearchBar> createState() => _SldsSearchBarState();
}

class _SldsSearchBarState extends State<SldsSearchBar> {
  late final TextEditingController _controller = widget.controller ?? TextEditingController();
  late final bool _ownsController = widget.controller == null;
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  late final bool _ownsFocusNode = widget.focusNode == null;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() => setState(() {});
  void _onFocusChanged() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    _focusNode.removeListener(_onFocusChanged);
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _select(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    widget.onSuggestionSelected?.call(value);
    _focusNode.unfocus();
  }

  bool get _panelOpen =>
      _focusNode.hasFocus && (widget.suggestions.isNotEmpty || widget.recentSearches.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final focused = _focusNode.hasFocus;
    final hasText = _controller.text.isNotEmpty;

    final borderColor = !widget.enabled
        ? colors.inputBorderDisabled
        : focused
            ? colors.inputBorderFocused
            : colors.inputBorderDefault;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: dimensions.space12),
          decoration: BoxDecoration(
            // Resting gray fill (not surfaceCard/white) — matches the
            // reference's neutral search-field look, not an active input.
            color: widget.enabled ? colors.surfaceRaised : colors.disabledBackground,
            border: Border.all(color: borderColor, width: focused ? dimensions.emphasizedBorderWidth : dimensions.controlBorderWidth),
            borderRadius: BorderRadius.circular(dimensions.radius2xl),
          ),
          child: Row(
            children: [
              Icon(Icons.search, size: dimensions.iconSizeMedium, color: colors.inputIcon),
              SizedBox(width: dimensions.space8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  style: tokens.typography.body1.copyWith(color: colors.textPrimary),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: dimensions.space12),
                    hintText: widget.hintText,
                    hintStyle: tokens.typography.body1.copyWith(color: colors.inputPlaceholder),
                  ),
                ),
              ),
              if (hasText)
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                  },
                  child: Container(
                    width: dimensions.iconButtonMedium,
                    height: dimensions.iconButtonMedium,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.borderDefault),
                    ),
                    child: Icon(Icons.close, size: dimensions.iconSizeMedium, color: colors.inputIcon),
                  ),
                ),
            ],
          ),
        ),
        if (_panelOpen) ...[
          SizedBox(height: dimensions.space8),
          Container(
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              border: Border.all(color: colors.borderDefault),
              borderRadius: BorderRadius.circular(dimensions.radius2xl),
            ),
            padding: EdgeInsets.symmetric(vertical: dimensions.space8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final suggestion in widget.suggestions)
                  _SuggestionRow(
                    label: suggestion,
                    highlighted: suggestion == _controller.text,
                    onTap: () => _select(suggestion),
                  ),
                if (widget.suggestions.isNotEmpty && widget.recentSearches.isNotEmpty) ...[
                  SizedBox(height: dimensions.space8),
                  Divider(height: 1, color: colors.borderDecorative),
                  SizedBox(height: dimensions.space8),
                ],
                if (widget.recentSearches.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: dimensions.space16, vertical: dimensions.space4),
                    child: Text(
                      widget.recentSearchesLabel,
                      style: tokens.typography.caption2.copyWith(color: colors.textTertiary),
                    ),
                  ),
                  for (final recent in widget.recentSearches)
                    _SuggestionRow(
                      label: recent,
                      icon: Icons.history,
                      onTap: () => _select(recent),
                    ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.label, this.icon, this.highlighted = false, required this.onTap});

  final String label;
  final IconData? icon;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: highlighted ? colors.surfaceHover : null,
        padding: EdgeInsets.symmetric(horizontal: tokens.dimensions.space16, vertical: tokens.dimensions.space12),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: tokens.dimensions.iconSizeMedium, color: colors.textTertiary),
              SizedBox(width: tokens.dimensions.space8),
            ],
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: tokens.typography.body1.copyWith(color: colors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
