import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

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
  /// Creates a search bar.
  const SldsSearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.suggestions = const [],
    this.recentSearches = const [],
    this.recentSearchesLabel,
    this.onChanged,
    this.onSubmitted,
    this.onSuggestionSelected,
    this.focusNode,
    this.enabled = true,
    this.semanticLabel,
  });

  /// Supply one to read or drive the query externally. When null the bar
  /// owns an internal controller for its lifetime.
  final TextEditingController? controller;

  /// Placeholder shown while the query is empty.
  final String? hintText;

  /// Filtered suggestion labels shown at the top of the panel while focused
  /// and non-empty; recompute this list from [onChanged] as the query types.
  final List<String> suggestions;

  /// Prior search terms shown below [suggestions], each with a history icon.
  final List<String> recentSearches;

  /// Section heading above [recentSearches].
  final String? recentSearchesLabel;

  /// Called on every change to the query.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the query from the keyboard.
  final ValueChanged<String>? onSubmitted;

  /// Invoked when a row in [suggestions] or [recentSearches] is tapped —
  /// typically you'll set the query to the tapped value and close the panel.
  final ValueChanged<String>? onSuggestionSelected;

  /// Supply one to drive focus externally. When null the bar owns an
  /// internal node.
  final FocusNode? focusNode;

  /// Whether the bar accepts input.
  final bool enabled;

  /// Accessible name for the field. Defaults to the localized "Search" —
  /// pass this where more than one search field shares a screen.
  final String? semanticLabel;

  @override
  State<SldsSearchBar> createState() => _SldsSearchBarState();
}

class _SldsSearchBarState extends State<SldsSearchBar> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
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
      _focusNode.hasFocus &&
      (widget.suggestions.isNotEmpty || widget.recentSearches.isNotEmpty);

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
            color: widget.enabled
                ? colors.surfaceRaised
                : colors.disabledBackground,
            border: Border.all(
              color: borderColor,
              width: focused
                  ? dimensions.emphasizedBorderWidth
                  : dimensions.controlBorderWidth,
            ),
            borderRadius: BorderRadius.circular(dimensions.radius2xl),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: dimensions.iconSizeMedium,
                color: colors.inputIcon,
              ),
              SizedBox(width: dimensions.space8),
              Expanded(
                child: Semantics(
                  // The magnifier icon is the only thing marking this as a
                  // search field, and an icon announces nothing.
                  textField: true,
                  label:
                      widget.semanticLabel ??
                      widget.hintText ??
                      context.sldsStrings.search,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    style: tokens.typography.body1.copyWith(
                      color: colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: dimensions.space12,
                      ),
                      hintText: widget.hintText ?? context.sldsStrings.search,
                      hintStyle: tokens.typography.body1.copyWith(
                        color: colors.inputPlaceholder,
                      ),
                    ),
                  ),
                ),
              ),
              if (hasText)
                Semantics(
                  button: true,
                  label: context.sldsStrings.clearSearch,
                  child: GestureDetector(
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
                      child: Icon(
                        Icons.close,
                        size: dimensions.iconSizeMedium,
                        color: colors.inputIcon,
                      ),
                    ),
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
                if (widget.suggestions.isNotEmpty &&
                    widget.recentSearches.isNotEmpty) ...[
                  SizedBox(height: dimensions.space8),
                  Divider(height: 1, color: colors.borderDecorative),
                  SizedBox(height: dimensions.space8),
                ],
                if (widget.recentSearches.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: dimensions.space16,
                      vertical: dimensions.space4,
                    ),
                    child: Text(
                      widget.recentSearchesLabel ??
                          context.sldsStrings.recentSearches,
                      style: tokens.typography.caption2.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ),
                  for (final recent in widget.recentSearches)
                    _SuggestionRow(
                      label: recent,
                      icon: Icons.history,
                      isRecent: true,
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
  const _SuggestionRow({
    required this.label,
    required this.onTap,
    this.icon,
    this.highlighted = false,
    this.isRecent = false,
  });

  final String label;
  final IconData? icon;

  /// Drives the spoken prefix only: the history icon distinguishes a past
  /// search from a live suggestion visually, and announces nothing.
  final bool isRecent;

  /// True for the suggestion row matching the current query — gets a gray
  /// background and a trailing checkmark (never applies to recent-search
  /// rows, which have no notion of "currently matches").
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;

    return Semantics(
      button: true,
      selected: highlighted,
      label: isRecent
          ? context.sldsStrings.recentSearch(label)
          : context.sldsStrings.suggestion(label),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          color: highlighted ? colors.surfaceHover : null,
          padding: EdgeInsets.symmetric(
            horizontal: tokens.dimensions.space16,
            vertical: tokens.dimensions.space12,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: tokens.dimensions.iconSizeMedium,
                  color: colors.textTertiary,
                ),
                SizedBox(width: tokens.dimensions.space8),
              ],
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.body1.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              if (highlighted)
                Icon(
                  Icons.check,
                  size: tokens.dimensions.iconSizeMedium,
                  color: colors.textPrimary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
