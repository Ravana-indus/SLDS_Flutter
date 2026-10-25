import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_focus.dart';

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
    this.onVoiceSearch,
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

  /// Starts a voice search. When non-null, Figma's microphone shows at the
  /// trailing edge while the bar is idle and empty; null hides it, since the
  /// library has no speech input of its own.
  final VoidCallback? onVoiceSearch;

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

  /// Figma's back arrow: leaves the search, emptying the query and closing
  /// the keyboard, which returns the bar to its default state.
  void _exit() {
    _controller.clear();
    widget.onChanged?.call('');
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
    // Figma's Mobile Typing and Filled states swap the magnifier for a back
    // arrow; Default (idle and empty) keeps the magnifier (#113).
    final active = widget.enabled && (focused || hasText);

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
            // Figma Search Bar fill: Surface/Page #F7F7F7 (#110).
            color: widget.enabled
                ? colors.surfacePage
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
              if (active)
                _BarIcon(
                  icon: Icons.arrow_back,
                  label: context.sldsStrings.back,
                  onTap: _exit,
                )
              else
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
                    // Figma Search Bar Default/Typing: 14/18 text.
                    style: tokens.typography.fieldLabel.copyWith(
                      color: colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      // The decorated field paints taller, but the
                      // text node itself is the tappable target and
                      // must clear the 48dp floor (WCAG 2.5.8).
                      constraints: BoxConstraints(
                        minHeight: dimensions.tapTargetMin,
                      ),
                      // Figma pads 16px above and below: 16 + 18 + 16 fills
                      // the 52px bar inside its border, so the text centres
                      // on the icon. The old 12px left 4px of the 48dp
                      // minimum as slack under the text, lifting it 2px
                      // (#109).
                      contentPadding: EdgeInsets.symmetric(
                        vertical: dimensions.space16,
                      ),
                      hintText: widget.hintText ?? context.sldsStrings.search,
                      hintStyle: tokens.typography.fieldLabel.copyWith(
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
                )
              // Figma Mobile Default: a microphone at the trailing edge
              // while idle and empty (#112).
              else if (!focused &&
                  widget.enabled &&
                  widget.onVoiceSearch != null)
                _BarIcon(
                  icon: Icons.mic_none,
                  label: context.sldsStrings.voiceSearch,
                  onTap: widget.onVoiceSearch!,
                ),
            ],
          ),
        ),
        if (_panelOpen) ...[
          SizedBox(height: dimensions.space8),
          // Figma Search Suggestion (543:5302): #F7F7F7 panel, #DDDDDD 1px,
          // radius 12; suggestions inset 8px and 4px apart, a full-width
          // divider, then the recent-searches heading and rows (#113).
          Container(
            decoration: BoxDecoration(
              color: colors.surfacePage,
              border: Border.all(color: colors.borderDecorative),
              borderRadius: BorderRadius.circular(dimensions.radius2xl),
            ),
            padding: EdgeInsets.symmetric(vertical: dimensions.space4),
            // Ink paints on the nearest Material; without this one the
            // panel's own fill hides the hover row.
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.suggestions.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        dimensions.space8,
                        0,
                        dimensions.space8,
                        dimensions.space8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: dimensions.space4,
                        children: [
                          for (final suggestion in widget.suggestions)
                            _SuggestionRow(
                              label: suggestion,
                              highlighted: suggestion == _controller.text,
                              onTap: () => _select(suggestion),
                            ),
                        ],
                      ),
                    ),
                  if (widget.suggestions.isNotEmpty &&
                      widget.recentSearches.isNotEmpty)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colors.borderDecorative,
                    ),
                  if (widget.recentSearches.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        dimensions.space6 + dimensions.space8,
                        dimensions.space8 + 1,
                        dimensions.space6 + dimensions.space8,
                        0,
                      ),
                      child: Text(
                        widget.recentSearchesLabel ??
                            context.sldsStrings.recentSearches,
                        style: tokens.typography.caption1.copyWith(
                          height: 14 / 12,
                          color: colors.textSecondary,
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

  /// True for the suggestion row matching the current query — Figma fills
  /// it #EEEEEE, radius 8 (never applies to recent-search rows, which have
  /// no notion of "currently matches").
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
      // Figma's _dropdown list item: 8px padding round a 14/22 label, 38px
      // tall; recent rows lead with a 16px clock, 8px from the text. No
      // trailing check — Figma hides it in the search panel (#113).
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(tokens.dimensions.radiusXl),
        hoverColor: colors.surfaceHover,
        focusColor: colors.surfaceHover,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        child: Ink(
          decoration: BoxDecoration(
            color: highlighted ? colors.surfaceHover : null,
            borderRadius: BorderRadius.circular(tokens.dimensions.radiusXl),
          ),
          padding: EdgeInsets.all(tokens.dimensions.space8),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: tokens.dimensions.iconSizeSmall,
                  color: colors.textPrimary,
                ),
                SizedBox(width: tokens.dimensions.space8),
              ],
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.body2.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A 20px bar icon that acts as a button: Figma's back arrow and
/// microphone. The hit area grows to 48dp without widening the 52px bar.
class _BarIcon extends StatelessWidget {
  const _BarIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    return Semantics(
      button: true,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: SldsOverflowTapTarget(
        onTap: onTap,
        child: Icon(
          icon,
          size: tokens.dimensions.iconSizeMedium,
          color: tokens.colors.inputIcon,
        ),
      ),
    );
  }
}
