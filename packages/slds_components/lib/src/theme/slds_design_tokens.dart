// Material, not widgets: [SldsTypographyTokens.materialTextTheme] returns a
// [TextTheme], which ThemeData needs and package:flutter/widgets.dart does
// not export.
import 'package:flutter/material.dart';
import 'package:slds_tokens/slds_tokens.dart';

export 'package:slds_tokens/slds_tokens.dart'
    show
        SldsDimensionTokens,
        SldsMotionTokens,
        SldsOpacityTokens,
        SldsTextStyleToken;

/// The package that ships the font assets.
///
/// Flutter resolves a font declared by a package only when the family is
/// qualified this way, so a consuming app gets the bundled font without
/// having to re-declare it in its own pubspec.
const String _fontPackage = 'slds_components';

/// Materialises a [SldsTextStyleToken] into a Flutter [TextStyle].
///
/// No `fontFamilyFallback` is set: the bundled Google Sans covers Latin,
/// Sinhala and Tamil in one family, so every locale the platform supports
/// renders from the same metrics with no substitution.
extension SldsTextStyleTokenX on SldsTextStyleToken {
  /// Builds the [TextStyle] for this token in [fontFamily].
  TextStyle toTextStyle(String fontFamily) {
    return TextStyle(
      fontFamily: fontFamily,
      package: _fontPackage,
      fontSize: fontSize,
      height: heightFactor,
      fontWeight: FontWeight.values[(fontWeight ~/ 100) - 1],
      letterSpacing: letterSpacing,
    );
  }
}

/// The SLDS colour palette as Flutter [Color]s.
///
/// Wraps the raw [SldsColorTokens] from `slds_tokens`; equality delegates to
/// that object, so comparing two palettes is one integer-field comparison
/// per role rather than a deep [Color] walk.
@immutable
class SldsColorTokens {
  /// Wraps [tokens] for use in a widget tree.
  const SldsColorTokens(this.tokens);

  /// The light palette.
  factory SldsColorTokens.light() =>
      SldsColorTokens(SldsRawColorTokens.light());

  /// The dark palette.
  factory SldsColorTokens.dark() => SldsColorTokens(SldsRawColorTokens.dark());

  /// The high-contrast palette.
  factory SldsColorTokens.highContrast() =>
      SldsColorTokens(SldsRawColorTokens.highContrast());

  /// The underlying raw tokens.
  final SldsRawColorTokens tokens;

  /// Primary text.
  Color get textPrimary => Color(tokens.textPrimary);

  /// Secondary text.
  Color get textSecondary => Color(tokens.textSecondary);

  /// Tertiary text.
  Color get textTertiary => Color(tokens.textTertiary);

  /// Root page surface.
  Color get surfacePage => Color(tokens.surfacePage);

  /// Card and overlay surface.
  Color get surfaceCard => Color(tokens.surfaceCard);

  /// hover). Figma calls this out as distinct from the white card surface.
  Color get surfaceRaised => Color(tokens.surfaceRaised);

  /// Hover surface.
  Color get surfaceHover => Color(tokens.surfaceHover);

  /// Control fill surface.
  Color get surfacePrimary => Color(tokens.surfacePrimary);

  /// Default border.
  Color get borderDefault => Color(tokens.borderDefault);

  /// Decorative border.
  Color get borderDecorative => Color(tokens.borderDecorative);

  /// decorative border used elsewhere.
  Color get cardBorder => Color(tokens.cardBorder);

  /// Focus ring.
  Color get focusRing => Color(tokens.focusRing);

  /// Focus halo.
  Color get focusHalo => Color(tokens.focusHalo);

  /// Figma Focus/Error ring — destructive Button/Icon Button focus outline.
  Color get focusRingError => Color(tokens.focusRingError);

  /// Figma Focus/Error halo — destructive Button/Icon Button focus glow.
  Color get focusHaloError => Color(tokens.focusHaloError);

  /// elevation alpha rather than tinting from the text colour.
  Color get shadowColor => Color(tokens.shadowColor);

  /// Top navigation surface.
  Color get headerBackground => Color(tokens.headerBackground);

  /// Government masthead surface.
  Color get mastheadBackground => Color(tokens.mastheadBackground);

  /// Leading icon colour for a Service Card.
  Color get serviceCardIcon => Color(tokens.serviceCardIcon);

  /// Summary Box outline, icon, and title colour.
  Color get summaryBoxAccent => Color(tokens.summaryBoxAccent);

  /// Approved Tag fill from Figma.
  Color get tagApproved => Color(tokens.tagApproved);

  /// Notice Tag fill from Figma.
  Color get tagNotice => Color(tokens.tagNotice);

  /// Top navigation divider.
  Color get headerBorder => Color(tokens.headerBorder);

  /// Incomplete top navigation progress segment.
  Color get headerProgressTrack => Color(tokens.headerProgressTrack);

  /// Primary button background.
  Color get buttonPrimaryBackground => Color(tokens.buttonPrimaryBackground);

  /// Primary button label.
  Color get buttonPrimaryLabel => Color(tokens.buttonPrimaryLabel);

  /// Primary button hover background.
  Color get buttonPrimaryHover => Color(tokens.buttonPrimaryHover);

  /// Primary button pressed background.
  Color get buttonPrimaryPressed => Color(tokens.buttonPrimaryPressed);

  /// Secondary button background.
  Color get buttonSecondaryBackground =>
      Color(tokens.buttonSecondaryBackground);

  /// Secondary button label.
  Color get buttonSecondaryLabel => Color(tokens.buttonSecondaryLabel);

  /// Secondary button border.
  Color get buttonSecondaryBorder => Color(tokens.buttonSecondaryBorder);

  /// Secondary button hover background.
  Color get buttonSecondaryHover => Color(tokens.buttonSecondaryHover);

  /// Secondary button pressed background.
  Color get buttonSecondaryPressed => Color(tokens.buttonSecondaryPressed);

  /// Ghost button label.
  Color get buttonGhostLabel => Color(tokens.buttonGhostLabel);

  /// Ghost button hover background.
  Color get buttonGhostHover => Color(tokens.buttonGhostHover);

  /// Ghost button pressed background.
  Color get buttonGhostPressed => Color(tokens.buttonGhostPressed);

  /// Inline text link label.
  Color get linkLabel => Color(tokens.linkLabel);

  /// Inline text link label on hover.
  Color get linkLabelHover => Color(tokens.linkLabelHover);

  /// Destructive inline text link label.
  Color get linkDestructiveLabel => Color(tokens.linkDestructiveLabel);

  /// Destructive inline text link label on hover.
  Color get linkDestructiveLabelHover =>
      Color(tokens.linkDestructiveLabelHover);

  /// Destructive button background.
  Color get buttonDestructiveBackground =>
      Color(tokens.buttonDestructiveBackground);

  /// Destructive button label.
  Color get buttonDestructiveLabel => Color(tokens.buttonDestructiveLabel);

  /// Destructive button hover background.
  Color get buttonDestructiveHover => Color(tokens.buttonDestructiveHover);

  /// Destructive button pressed background.
  Color get buttonDestructivePressed => Color(tokens.buttonDestructivePressed);

  /// Disabled fill.
  Color get disabledBackground => Color(tokens.disabledBackground);

  /// Disabled foreground.
  Color get disabledForeground => Color(tokens.disabledForeground);

  /// Figma Button/Disabled/Border — lighter than [disabledBackground].
  Color get disabledBorder => Color(tokens.disabledBorder);

  /// Figma Text/Static Black — label colour on amber/gold fills.
  Color get textStaticBlack => Color(tokens.textStaticBlack);

  /// Figma Red/500 — the small notification-count badge on Bottom Tab Bar.
  Color get notificationBadgeBackground =>
      Color(tokens.notificationBadgeBackground);

  /// Figma Banner/Warning/Title — darker than the warning icon/border.
  Color get bannerWarningTitle => Color(tokens.bannerWarningTitle);

  /// Figma Badge/Archived/Text — lighter than the shared Neutral/Draft text.
  Color get badgeArchivedText => Color(tokens.badgeArchivedText);

  /// Figma List/Background — Service Card and List Item resting fill.
  Color get listBackground => Color(tokens.listBackground);

  /// Figma List/Background/Hover.
  Color get listBackgroundHover => Color(tokens.listBackgroundHover);

  /// Input label.
  Color get inputLabel => Color(tokens.inputLabel);

  /// Input placeholder.
  Color get inputPlaceholder => Color(tokens.inputPlaceholder);

  /// Input helper text.
  Color get inputHelper => Color(tokens.inputHelper);

  /// Input leading/trailing icon.
  Color get inputIcon => Color(tokens.inputIcon);

  /// Input default border.
  Color get inputBorderDefault => Color(tokens.inputBorderDefault);

  /// Input focus border.
  Color get inputBorderFocused => Color(tokens.inputBorderFocused);

  /// Input error border.
  Color get inputBorderError => Color(tokens.inputBorderError);

  /// Input disabled border.
  Color get inputBorderDisabled => Color(tokens.inputBorderDisabled);

  /// Error color.
  Color get error => Color(tokens.error);

  /// Success color.
  Color get success => Color(tokens.success);

  /// Warning color.
  Color get warning => Color(tokens.warning);

  /// Info color.
  Color get info => Color(tokens.info);

  /// Success badge text.
  Color get badgeSuccessText => Color(tokens.badgeSuccessText);

  /// Success badge background.
  Color get badgeSuccessBackground => Color(tokens.badgeSuccessBackground);

  /// Pending badge text.
  Color get badgePendingText => Color(tokens.badgePendingText);

  /// Pending badge background.
  Color get badgePendingBackground => Color(tokens.badgePendingBackground);

  /// Error badge text.
  Color get badgeErrorText => Color(tokens.badgeErrorText);

  /// Error badge background.
  Color get badgeErrorBackground => Color(tokens.badgeErrorBackground);

  /// Info badge text.
  Color get badgeInfoText => Color(tokens.badgeInfoText);

  /// Info badge background.
  Color get badgeInfoBackground => Color(tokens.badgeInfoBackground);

  /// Neutral badge text.
  Color get badgeNeutralText => Color(tokens.badgeNeutralText);

  /// Neutral badge background.
  Color get badgeNeutralBackground => Color(tokens.badgeNeutralBackground);

  /// Submitted badge text.
  Color get badgeSubmittedText => Color(tokens.badgeSubmittedText);

  /// Submitted badge background.
  Color get badgeSubmittedBackground => Color(tokens.badgeSubmittedBackground);

  /// In review badge text.
  Color get badgeInReviewText => Color(tokens.badgeInReviewText);

  /// In review badge background.
  Color get badgeInReviewBackground => Color(tokens.badgeInReviewBackground);

  /// Approved badge text.
  Color get badgeApprovedText => Color(tokens.badgeApprovedText);

  /// Approved badge background.
  Color get badgeApprovedBackground => Color(tokens.badgeApprovedBackground);

  /// Escalated badge text.
  Color get badgeEscalatedText => Color(tokens.badgeEscalatedText);

  /// Escalated badge background.
  Color get badgeEscalatedBackground => Color(tokens.badgeEscalatedBackground);

  /// On hold badge text.
  Color get badgeOnHoldText => Color(tokens.badgeOnHoldText);

  /// On hold badge background.
  Color get badgeOnHoldBackground => Color(tokens.badgeOnHoldBackground);

  /// Tooltip surface.
  Color get tooltipBackground => Color(tokens.tooltipBackground);

  /// Tooltip text.
  Color get tooltipText => Color(tokens.tooltipText);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SldsColorTokens && other.tokens == tokens);

  @override
  int get hashCode => tokens.hashCode;
}

/// The SLDS type scale as Flutter [TextStyle]s.
@immutable
class SldsTypographyTokens {
  /// Wraps [tokens] for use in a widget tree.
  const SldsTypographyTokens(this.tokens);

  /// The shipped type scale.
  static const SldsTypographyTokens standard = SldsTypographyTokens(
    SldsRawTypographyTokens.standard,
  );

  /// The underlying raw tokens.
  final SldsRawTypographyTokens tokens;

  /// Primary font family name.
  String get fontFamily => tokens.fontFamily;

  /// Bottom Navigation label (Figma: 12px/18px regular, +0.2 tracking).
  TextStyle get bottomNavigationLabel =>
      tokens.bottomNavigationLabel.toTextStyle(tokens.fontFamily);

  /// Mobile body 1 style.
  TextStyle get body1 => tokens.body1.toTextStyle(tokens.fontFamily);

  /// Desktop body 2 style.
  TextStyle get body2 => tokens.body2.toTextStyle(tokens.fontFamily);

  /// Caption style.
  TextStyle get caption1 => tokens.caption1.toTextStyle(tokens.fontFamily);

  /// Desktop caption 2 style.
  TextStyle get caption2 => tokens.caption2.toTextStyle(tokens.fontFamily);

  /// Mobile caption 2 style.
  TextStyle get mobileCaption2 =>
      tokens.mobileCaption2.toTextStyle(tokens.fontFamily);

  /// Mobile display 1 style used by numeric error-state codes.
  TextStyle get mobileDisplay1 =>
      tokens.mobileDisplay1.toTextStyle(tokens.fontFamily);

  /// Desktop display 2 style.
  TextStyle get display2 => tokens.display2.toTextStyle(tokens.fontFamily);

  /// Desktop heading 4 style.
  TextStyle get heading4 => tokens.heading4.toTextStyle(tokens.fontFamily);

  /// Snackbar caption style.
  TextStyle get snackbarCaption =>
      tokens.snackbarCaption.toTextStyle(tokens.fontFamily);

  /// Mobile title style.
  TextStyle get title1 => tokens.title1.toTextStyle(tokens.fontFamily);

  /// Mobile heading 1 style.
  TextStyle get heading1 => tokens.heading1.toTextStyle(tokens.fontFamily);

  /// Mobile heading 2 style.
  TextStyle get heading2 => tokens.heading2.toTextStyle(tokens.fontFamily);

  /// Desktop heading 2 style.
  TextStyle get desktopHeading2 =>
      tokens.desktopHeading2.toTextStyle(tokens.fontFamily);

  /// Mobile heading 3 style.
  TextStyle get heading3 => tokens.heading3.toTextStyle(tokens.fontFamily);

  /// Desktop title style.
  TextStyle get desktopTitle1 =>
      tokens.desktopTitle1.toTextStyle(tokens.fontFamily);

  /// Input and selection-field label (Figma: 16px/20px regular).
  TextStyle get fieldLabel => tokens.fieldLabel.toTextStyle(tokens.fontFamily);

  /// Compact component label (Figma: 16px/20px regular).
  TextStyle get compactLabel =>
      tokens.compactLabel.toTextStyle(tokens.fontFamily);

  /// Compact component description (Figma: 14px/22px regular).
  TextStyle get compactDescription =>
      tokens.compactDescription.toTextStyle(tokens.fontFamily);

  /// This type scale expressed in Material's [TextTheme] slot names.
  ///
  /// Widgets read SLDS names ([heading3], [body2]) directly. This mapping
  /// exists for the one place that cannot: [ThemeData.textTheme], which is
  /// keyed by Material slots and is what `Text` falls back to when a widget
  /// passes no explicit style.
  ///
  /// The pairing is by metric, not by name — each slot takes the SLDS token
  /// whose size, line height and tracking already match what Material puts
  /// there. Slots with no SLDS equivalent are left unset so they inherit
  /// Material's default rather than being filled with an approximation.
  TextTheme get materialTextTheme => TextTheme(
    // Display — the largest scale, used by numeric error codes and hero text.
    displayLarge: display2,
    displayMedium: display2,
    displaySmall: mobileDisplay1,
    // Headline — section headings.
    headlineLarge: desktopHeading2,
    headlineMedium: desktopHeading2,
    headlineSmall: heading2,
    // Title — card and dialog titles.
    titleLarge: heading4,
    titleMedium: desktopTitle1,
    titleSmall: title1,
    // Body — running text. body1 is 16px, body2 is 14px.
    bodyLarge: body1,
    bodyMedium: body2,
    bodySmall: caption1,
    // Label — control labels and captions.
    labelLarge: fieldLabel,
    labelMedium: caption1,
    labelSmall: caption2,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SldsTypographyTokens && other.tokens == tokens);

  @override
  int get hashCode => tokens.hashCode;
}

/// Every SLDS token for one theme, ready for use in widgets.
///
/// Read this from a [BuildContext] via the `slds` extension rather than
/// constructing it.
@immutable
class SldsTokenSet {
  /// Creates a token set.
  const SldsTokenSet({
    required this.colors,
    required this.motion,
    this.dimensions = SldsDimensionTokens.standard,
    this.typography = SldsTypographyTokens.standard,
    this.opacities = SldsOpacityTokens.standard,
  });

  /// The light theme.
  factory SldsTokenSet.light({bool reducedMotion = false}) {
    return SldsTokenSet(
      colors: SldsColorTokens.light(),
      motion: SldsMotionTokens(reducedMotion: reducedMotion),
    );
  }

  /// The dark theme.
  factory SldsTokenSet.dark({bool reducedMotion = false}) {
    return SldsTokenSet(
      colors: SldsColorTokens.dark(),
      motion: SldsMotionTokens(reducedMotion: reducedMotion),
    );
  }

  /// The high-contrast theme.
  factory SldsTokenSet.highContrast({bool reducedMotion = false}) {
    return SldsTokenSet(
      colors: SldsColorTokens.highContrast(),
      motion: SldsMotionTokens(reducedMotion: reducedMotion),
    );
  }

  /// Colour roles for this theme.
  final SldsColorTokens colors;

  /// Spacing, sizing, radii and elevation. Theme-independent.
  final SldsDimensionTokens dimensions;

  /// The type scale. Theme-independent.
  final SldsTypographyTokens typography;

  /// Animation durations.
  final SldsMotionTokens motion;

  /// Composition factors such as the disabled dim. Theme-independent.
  final SldsOpacityTokens opacities;

  /// Returns a copy with the given token groups replaced.
  SldsTokenSet copyWith({
    SldsColorTokens? colors,
    SldsDimensionTokens? dimensions,
    SldsTypographyTokens? typography,
    SldsMotionTokens? motion,
    SldsOpacityTokens? opacities,
  }) {
    return SldsTokenSet(
      colors: colors ?? this.colors,
      dimensions: dimensions ?? this.dimensions,
      typography: typography ?? this.typography,
      motion: motion ?? this.motion,
      opacities: opacities ?? this.opacities,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SldsTokenSet &&
        other.colors == colors &&
        other.dimensions == dimensions &&
        other.typography == typography &&
        other.motion == motion &&
        other.opacities == opacities;
  }

  @override
  int get hashCode =>
      Object.hash(colors, dimensions, typography, motion, opacities);
}
