// Design tokens for SLDS typography.
//
// Styles are stored as raw metrics rather than `TextStyle` so this package
// stays Flutter-free (§2). `slds_components` materialises each one into a
// `TextStyle`, which is also where the Sinhala/Tamil font fallback chain is
// applied.

/// The metrics of a single SLDS text style.
class SldsTextStyleToken {
  /// Creates a text style token.
  const SldsTextStyleToken({
    required this.fontSize,
    required this.lineHeight,
    required this.fontWeight,
    this.letterSpacing = 0,
  });

  /// Font size in logical pixels.
  final double fontSize;

  /// Line height in logical pixels, as designed.
  final double lineHeight;

  /// Numeric font weight (400 regular, 500 medium, 700 bold).
  final int fontWeight;

  /// Additional letter spacing in logical pixels.
  final double letterSpacing;

  /// Line height as a multiple of [fontSize], the form Flutter wants.
  double get heightFactor => lineHeight / fontSize;

  /// Returns a copy with the given metrics replaced.
  SldsTextStyleToken copyWith({
    double? fontSize,
    double? lineHeight,
    int? fontWeight,
    double? letterSpacing,
  }) {
    return SldsTextStyleToken(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontWeight: fontWeight ?? this.fontWeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SldsTextStyleToken &&
        other.fontSize == fontSize &&
        other.lineHeight == lineHeight &&
        other.fontWeight == fontWeight &&
        other.letterSpacing == letterSpacing;
  }

  @override
  int get hashCode =>
      Object.hash(fontSize, lineHeight, fontWeight, letterSpacing);
}

/// The SLDS type scale.
class SldsRawTypographyTokens {
  /// Creates a type scale with every style specified.
  const SldsRawTypographyTokens({
    this.fontFamily = 'Google Sans',
    required this.bottomNavigationLabel,
    required this.body1,
    required this.body2,
    required this.caption1,
    required this.caption2,
    required this.mobileCaption2,
    required this.mobileDisplay1,
    required this.display2,
    required this.heading4,
    required this.snackbarCaption,
    required this.title1,
    required this.heading1,
    required this.heading2,
    required this.desktopHeading2,
    required this.heading3,
    required this.desktopTitle1,
    required this.fieldLabel,
    required this.compactLabel,
    required this.compactDescription,
  });

  /// The shipped SLDS type scale.
  static const SldsRawTypographyTokens standard = SldsRawTypographyTokens(
    bottomNavigationLabel: SldsTextStyleToken(
      fontSize: 12,
      lineHeight: 18,
      fontWeight: 400,
      letterSpacing: 0.2,
    ),
    body1: SldsTextStyleToken(fontSize: 16, lineHeight: 20, fontWeight: 400),
    body2: SldsTextStyleToken(fontSize: 14, lineHeight: 22, fontWeight: 400),
    caption1: SldsTextStyleToken(fontSize: 12, lineHeight: 16, fontWeight: 400),
    caption2: SldsTextStyleToken(
      fontSize: 11,
      lineHeight: 16,
      fontWeight: 400,
      letterSpacing: 0.3,
    ),
    mobileCaption2: SldsTextStyleToken(
      fontSize: 11,
      lineHeight: 20,
      fontWeight: 400,
    ),
    mobileDisplay1: SldsTextStyleToken(
      fontSize: 36,
      lineHeight: 44,
      fontWeight: 500,
      letterSpacing: -2,
    ),
    display2: SldsTextStyleToken(
      fontSize: 44,
      lineHeight: 56,
      fontWeight: 700,
      letterSpacing: -0.3,
    ),
    heading4: SldsTextStyleToken(
      fontSize: 24,
      lineHeight: 32,
      fontWeight: 500,
      letterSpacing: -0.1,
    ),
    snackbarCaption: SldsTextStyleToken(
      fontSize: 12,
      lineHeight: 18,
      fontWeight: 400,
      letterSpacing: 0.2,
    ),
    title1: SldsTextStyleToken(fontSize: 18, lineHeight: 24, fontWeight: 500),
    heading1: SldsTextStyleToken(fontSize: 26, lineHeight: 28, fontWeight: 500),
    heading2: SldsTextStyleToken(fontSize: 24, lineHeight: 32, fontWeight: 500),
    desktopHeading2: SldsTextStyleToken(
      fontSize: 28,
      lineHeight: 40,
      fontWeight: 700,
      letterSpacing: -0.2,
    ),
    heading3: SldsTextStyleToken(
      fontSize: 22,
      lineHeight: 36,
      fontWeight: 700,
      letterSpacing: -0.5,
    ),
    desktopTitle1: SldsTextStyleToken(
      fontSize: 18,
      lineHeight: 28,
      fontWeight: 500,
    ),
    fieldLabel: SldsTextStyleToken(
      fontSize: 16,
      lineHeight: 20,
      fontWeight: 400,
    ),
    compactLabel: SldsTextStyleToken(
      fontSize: 16,
      lineHeight: 20,
      fontWeight: 400,
    ),
    compactDescription: SldsTextStyleToken(
      fontSize: 14,
      lineHeight: 22,
      fontWeight: 400,
    ),
  );

  /// Primary font family name.
  final String fontFamily;

  /// Bottom Navigation label (Figma: 12px/18px regular, +0.2 tracking).
  final SldsTextStyleToken bottomNavigationLabel;

  /// Mobile body 1 style.
  final SldsTextStyleToken body1;

  /// Desktop body 2 style.
  final SldsTextStyleToken body2;

  /// Caption style.
  final SldsTextStyleToken caption1;

  /// Desktop caption 2 style.
  final SldsTextStyleToken caption2;

  /// Mobile caption 2 style.
  final SldsTextStyleToken mobileCaption2;

  /// Mobile display 1 style used by numeric error-state codes.
  final SldsTextStyleToken mobileDisplay1;

  /// Desktop display 2 style.
  final SldsTextStyleToken display2;

  /// Desktop heading 4 style.
  final SldsTextStyleToken heading4;

  /// Snackbar caption style.
  final SldsTextStyleToken snackbarCaption;

  /// Mobile title style.
  final SldsTextStyleToken title1;

  /// Mobile heading 1 style.
  final SldsTextStyleToken heading1;

  /// Mobile heading 2 style.
  final SldsTextStyleToken heading2;

  /// Desktop heading 2 style.
  final SldsTextStyleToken desktopHeading2;

  /// Mobile heading 3 style.
  final SldsTextStyleToken heading3;

  /// Desktop title style.
  final SldsTextStyleToken desktopTitle1;

  /// Input and selection-field label (Figma: 16px/20px regular).
  final SldsTextStyleToken fieldLabel;

  /// Compact component label (Figma: 16px/20px regular).
  final SldsTextStyleToken compactLabel;

  /// Compact component description (Figma: 14px/22px regular).
  final SldsTextStyleToken compactDescription;

  /// Returns a copy with the given styles replaced.
  SldsRawTypographyTokens copyWith({
    String? fontFamily,
    SldsTextStyleToken? bottomNavigationLabel,
    SldsTextStyleToken? body1,
    SldsTextStyleToken? body2,
    SldsTextStyleToken? caption1,
    SldsTextStyleToken? caption2,
    SldsTextStyleToken? mobileCaption2,
    SldsTextStyleToken? mobileDisplay1,
    SldsTextStyleToken? display2,
    SldsTextStyleToken? heading4,
    SldsTextStyleToken? snackbarCaption,
    SldsTextStyleToken? title1,
    SldsTextStyleToken? heading1,
    SldsTextStyleToken? heading2,
    SldsTextStyleToken? desktopHeading2,
    SldsTextStyleToken? heading3,
    SldsTextStyleToken? desktopTitle1,
    SldsTextStyleToken? fieldLabel,
    SldsTextStyleToken? compactLabel,
    SldsTextStyleToken? compactDescription,
  }) {
    return SldsRawTypographyTokens(
      fontFamily: fontFamily ?? this.fontFamily,
      bottomNavigationLabel:
          bottomNavigationLabel ?? this.bottomNavigationLabel,
      body1: body1 ?? this.body1,
      body2: body2 ?? this.body2,
      caption1: caption1 ?? this.caption1,
      caption2: caption2 ?? this.caption2,
      mobileCaption2: mobileCaption2 ?? this.mobileCaption2,
      mobileDisplay1: mobileDisplay1 ?? this.mobileDisplay1,
      display2: display2 ?? this.display2,
      heading4: heading4 ?? this.heading4,
      snackbarCaption: snackbarCaption ?? this.snackbarCaption,
      title1: title1 ?? this.title1,
      heading1: heading1 ?? this.heading1,
      heading2: heading2 ?? this.heading2,
      desktopHeading2: desktopHeading2 ?? this.desktopHeading2,
      heading3: heading3 ?? this.heading3,
      desktopTitle1: desktopTitle1 ?? this.desktopTitle1,
      fieldLabel: fieldLabel ?? this.fieldLabel,
      compactLabel: compactLabel ?? this.compactLabel,
      compactDescription: compactDescription ?? this.compactDescription,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SldsRawTypographyTokens &&
        other.fontFamily == fontFamily &&
        other.bottomNavigationLabel == bottomNavigationLabel &&
        other.body1 == body1 &&
        other.body2 == body2 &&
        other.caption1 == caption1 &&
        other.caption2 == caption2 &&
        other.mobileCaption2 == mobileCaption2 &&
        other.mobileDisplay1 == mobileDisplay1 &&
        other.display2 == display2 &&
        other.heading4 == heading4 &&
        other.snackbarCaption == snackbarCaption &&
        other.title1 == title1 &&
        other.heading1 == heading1 &&
        other.heading2 == heading2 &&
        other.desktopHeading2 == desktopHeading2 &&
        other.heading3 == heading3 &&
        other.desktopTitle1 == desktopTitle1 &&
        other.fieldLabel == fieldLabel &&
        other.compactLabel == compactLabel &&
        other.compactDescription == compactDescription;
  }

  @override
  int get hashCode => Object.hashAll(<Object>[
    fontFamily,
    bottomNavigationLabel,
    body1,
    body2,
    caption1,
    caption2,
    mobileCaption2,
    mobileDisplay1,
    display2,
    heading4,
    snackbarCaption,
    title1,
    heading1,
    heading2,
    desktopHeading2,
    heading3,
    desktopTitle1,
    fieldLabel,
    compactLabel,
    compactDescription,
  ]);
}
