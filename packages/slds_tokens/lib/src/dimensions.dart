// Design tokens for SLDS spacing, sizing, radii and elevation.
//
// Every value is a plain `final double` field rather than a lookup against an
// override map: the field name and its default then live in the same place,
// value equality is exact, and the table is straightforward for a token
// export to regenerate.

/// The SLDS dimension scale.
///
/// Use [SldsDimensionTokens.standard] for the shipped values; use [copyWith]
/// to override individual entries.
class SldsDimensionTokens {
  /// Creates a dimension scale with every value specified.
  const SldsDimensionTokens({
    required this.space0,
    required this.space1,
    required this.space2,
    required this.space4,
    required this.space6,
    required this.space8,
    required this.space10,
    required this.space12,
    required this.space16,
    required this.space20,
    required this.space24,
    required this.space32,
    required this.space40,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusXl,
    required this.radius2xl,
    required this.radius3xl,
    required this.radius4xl,
    required this.radiusFull,
    required this.buttonHeightSmall,
    required this.buttonHeightMedium,
    required this.buttonHeightLarge,
    required this.buttonHeightExtraLarge,
    required this.inputWidth,
    required this.inputHeight,
    required this.inputHeightCompact,
    required this.textAreaHeight,
    required this.checkboxDefault,
    required this.checkboxLarge,
    required this.radioDefault,
    required this.radioLarge,
    required this.toggleWidth,
    required this.toggleHeight,
    required this.toggleThumb,
    required this.cardWidth,
    required this.cardHeight,
    required this.cardImageHeight,
    required this.dialogWidth,
    required this.snackbarWidth,
    required this.tabStripWidth,
    required this.tabBadgeMinWidth,
    required this.tabBadgeWidth,
    required this.listItemWidth,
    required this.listSlotSize,
    required this.accordionWidth,
    required this.progressWidth,
    required this.progressLabelWidth,
    required this.progressSegmentHeight,
    required this.stepperWidth,
    required this.avatarSize16,
    required this.avatarSize20,
    required this.avatarSize24,
    required this.avatarSize32,
    required this.avatarSize40,
    required this.avatarSize48,
    required this.avatarSize56,
    required this.avatarIconExtraSmall,
    required this.avatarIconSmall,
    required this.avatarIconMedium,
    required this.avatarIconLarge,
    required this.avatarIconExtraLarge,
    required this.tooltipWidth,
    required this.tooltipTitleWidth,
    required this.tooltipArrowWidth,
    required this.tooltipArrowHeight,
    required this.paginationItemSize,
    required this.navigationDrawerWidth,
    required this.breakpointMobile,
    required this.tapTargetMin,
    required this.controlBorderWidth,
    required this.emphasizedBorderWidth,
    required this.inputDisabledBorderWidth,
    required this.progressStrokeWidth,
    required this.focusRingSpread,
    required this.elevationBlur,
    required this.elevationOffsetY,
    required this.elevationSpread,
    required this.cardShadowBlur,
    required this.cardShadowOffsetY,
    required this.dropdownMenuWidth,
    required this.iconButtonMedium,
    required this.iconSizeMedium,
    required this.snackbarShadowBlur,
  });

  /// The shipped SLDS dimension scale.
  static const SldsDimensionTokens standard = SldsDimensionTokens(
    space0: 0,
    space1: 1,
    space2: 2,
    space4: 4,
    space6: 6,
    space8: 8,
    space10: 10,
    space12: 12,
    space16: 16,
    space20: 20,
    space24: 24,
    space32: 32,
    space40: 40,
    radiusSm: 2,
    radiusMd: 4,
    radiusLg: 6,
    radiusXl: 8,
    radius2xl: 12,
    radius3xl: 16,
    radius4xl: 24,
    radiusFull: 9999,
    buttonHeightSmall: 28,
    buttonHeightMedium: 36,
    buttonHeightLarge: 48,
    buttonHeightExtraLarge: 56,
    inputWidth: 361,
    inputHeight: 52,
    inputHeightCompact: 32,
    textAreaHeight: 128,
    checkboxDefault: 16,
    checkboxLarge: 24,
    radioDefault: 16,
    radioLarge: 20,
    toggleWidth: 50.4,
    toggleHeight: 28,
    toggleThumb: 22.4,
    cardWidth: 343,
    cardHeight: 200,
    cardImageHeight: 160,
    dialogWidth: 300,
    snackbarWidth: 361,
    tabStripWidth: 451,
    tabBadgeMinWidth: 16,
    tabBadgeWidth: 24,
    listItemWidth: 400,
    listSlotSize: 40,
    accordionWidth: 400,
    progressWidth: 339,
    progressLabelWidth: 40,
    progressSegmentHeight: 6,
    stepperWidth: 393,
    avatarSize16: 16,
    avatarSize20: 20,
    avatarSize24: 24,
    avatarSize32: 32,
    avatarSize40: 40,
    avatarSize48: 48,
    avatarSize56: 56,
    avatarIconExtraSmall: 11.2,
    avatarIconSmall: 14,
    avatarIconMedium: 16,
    avatarIconLarge: 24,
    avatarIconExtraLarge: 28,
    tooltipWidth: 320,
    tooltipTitleWidth: 72,
    tooltipArrowWidth: 28,
    tooltipArrowHeight: 6,
    paginationItemSize: 36,
    navigationDrawerWidth: 320,
    breakpointMobile: 600,
    tapTargetMin: 48,
    controlBorderWidth: 1,
    emphasizedBorderWidth: 1.5,
    inputDisabledBorderWidth: 1.6,
    progressStrokeWidth: 2,
    focusRingSpread: 3,
    elevationBlur: 15,
    elevationOffsetY: 10,
    elevationSpread: -3,
    cardShadowBlur: 8,
    cardShadowOffsetY: 2,
    dropdownMenuWidth: 362,
    iconButtonMedium: 36,
    iconSizeMedium: 20,
    snackbarShadowBlur: 7.5,
  );

  /// No spacing.
  final double space0;

  /// 1px spacing.
  final double space1;

  /// 2px spacing.
  final double space2;

  /// 4px spacing.
  final double space4;

  /// 6px spacing.
  final double space6;

  /// 8px spacing.
  final double space8;

  /// 10px spacing.
  final double space10;

  /// 12px spacing.
  final double space12;

  /// 16px spacing.
  final double space16;

  /// 20px spacing.
  final double space20;

  /// 24px spacing.
  final double space24;

  /// 32px spacing.
  final double space32;

  /// 40px spacing.
  final double space40;

  /// Small radius.
  final double radiusSm;

  /// Medium radius.
  final double radiusMd;

  /// Large radius. Figma's compact Text Input field radius.
  final double radiusLg;

  /// XL radius.
  final double radiusXl;

  /// 2XL radius.
  final double radius2xl;

  /// 3XL radius.
  final double radius3xl;

  /// 4XL radius.
  final double radius4xl;

  /// Full radius.
  final double radiusFull;

  /// Small button height.
  final double buttonHeightSmall;

  /// Medium button height.
  final double buttonHeightMedium;

  /// Large button height.
  final double buttonHeightLarge;

  /// Extra large button height.
  final double buttonHeightExtraLarge;

  /// Figma input width.
  final double inputWidth;

  /// Figma input height.
  final double inputHeight;

  /// Figma compact Text Input field height (mobile-density fields).
  final double inputHeightCompact;

  /// Figma text area content height.
  final double textAreaHeight;

  /// Default checkbox size.
  final double checkboxDefault;

  /// Large checkbox size.
  final double checkboxLarge;

  /// Default radio size.
  final double radioDefault;

  /// Large radio size.
  final double radioLarge;

  /// Toggle width.
  final double toggleWidth;

  /// Toggle height.
  final double toggleHeight;

  /// Toggle thumb size.
  final double toggleThumb;

  /// Card width.
  final double cardWidth;

  /// Card height.
  final double cardHeight;

  /// Card image height.
  final double cardImageHeight;

  /// Dialog width.
  final double dialogWidth;

  /// Snackbar width.
  final double snackbarWidth;

  /// Figma tab strip width.
  final double tabStripWidth;

  /// Minimum tab badge width.
  final double tabBadgeMinWidth;

  /// Default tab badge width.
  final double tabBadgeWidth;

  /// Figma list item width.
  final double listItemWidth;

  /// List leading slot size.
  final double listSlotSize;

  /// Figma accordion width.
  final double accordionWidth;

  /// Figma progress bar width.
  final double progressWidth;

  /// Figma progress label width.
  final double progressLabelWidth;

  /// Progress and step segment height.
  final double progressSegmentHeight;

  /// Figma stepper width.
  final double stepperWidth;

  /// 16px avatar size.
  final double avatarSize16;

  /// 20px avatar size.
  final double avatarSize20;

  /// 24px avatar size.
  final double avatarSize24;

  /// 32px avatar size.
  final double avatarSize32;

  /// 40px avatar size.
  final double avatarSize40;

  /// 48px avatar size.
  final double avatarSize48;

  /// 56px avatar size.
  final double avatarSize56;

  /// 16px avatar icon slot.
  final double avatarIconExtraSmall;

  /// Small avatar icon size.
  final double avatarIconSmall;

  /// Medium avatar icon size.
  final double avatarIconMedium;

  /// Large avatar icon size.
  final double avatarIconLarge;

  /// Extra large avatar icon size.
  final double avatarIconExtraLarge;

  /// Tooltip panel width.
  final double tooltipWidth;

  /// Compact title-only tooltip width.
  final double tooltipTitleWidth;

  /// Tooltip arrow width.
  final double tooltipArrowWidth;

  /// Tooltip arrow height.
  final double tooltipArrowHeight;

  /// Pagination item frame.
  final double paginationItemSize;

  /// Navigation drawer width.
  final double navigationDrawerWidth;

  /// Width at or above which the desktop layout and type scale apply.
  ///
  /// Stored here as a raw width so the value stays consumable by codegen and
  /// design tooling; the `BuildContext` helper that reads it lives in
  /// `slds_components`, since `BuildContext` is Flutter.
  final double breakpointMobile;

  /// Minimum accessible touch target size.
  ///
  /// WCAG 2.2 (2.5.8) sets the floor at 24x24 CSS pixels; this library holds
  /// the stricter 48x48 Material and SLDS figure. Components go below it only
  /// where the design spec says so, and that exception is documented at the
  /// call site.
  final double tapTargetMin;

  /// Standard control border width.
  final double controlBorderWidth;

  /// Emphasized control border width.
  final double emphasizedBorderWidth;

  /// Disabled input border width from Figma text input variants.
  final double inputDisabledBorderWidth;

  /// Circular progress stroke width.
  final double progressStrokeWidth;

  /// Focus ring spread radius.
  final double focusRingSpread;

  /// Overlay elevation blur radius.
  final double elevationBlur;

  /// Overlay elevation y-offset.
  final double elevationOffsetY;

  /// Overlay elevation spread radius.
  final double elevationSpread;

  /// Card elevation blur radius.
  final double cardShadowBlur;

  /// Card elevation y-offset.
  final double cardShadowOffsetY;

  /// Dropdown open menu width.
  final double dropdownMenuWidth;

  /// Medium icon button frame.
  final double iconButtonMedium;

  /// Medium icon size.
  final double iconSizeMedium;

  /// Snackbar shadow blur radius.
  final double snackbarShadowBlur;

  /// Returns a copy with the given values replaced.
  SldsDimensionTokens copyWith({
    double? space0,
    double? space1,
    double? space2,
    double? space4,
    double? space6,
    double? space8,
    double? space10,
    double? space12,
    double? space16,
    double? space20,
    double? space24,
    double? space32,
    double? space40,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusXl,
    double? radius2xl,
    double? radius3xl,
    double? radius4xl,
    double? radiusFull,
    double? buttonHeightSmall,
    double? buttonHeightMedium,
    double? buttonHeightLarge,
    double? buttonHeightExtraLarge,
    double? inputWidth,
    double? inputHeight,
    double? inputHeightCompact,
    double? textAreaHeight,
    double? checkboxDefault,
    double? checkboxLarge,
    double? radioDefault,
    double? radioLarge,
    double? toggleWidth,
    double? toggleHeight,
    double? toggleThumb,
    double? cardWidth,
    double? cardHeight,
    double? cardImageHeight,
    double? dialogWidth,
    double? snackbarWidth,
    double? tabStripWidth,
    double? tabBadgeMinWidth,
    double? tabBadgeWidth,
    double? listItemWidth,
    double? listSlotSize,
    double? accordionWidth,
    double? progressWidth,
    double? progressLabelWidth,
    double? progressSegmentHeight,
    double? stepperWidth,
    double? avatarSize16,
    double? avatarSize20,
    double? avatarSize24,
    double? avatarSize32,
    double? avatarSize40,
    double? avatarSize48,
    double? avatarSize56,
    double? avatarIconExtraSmall,
    double? avatarIconSmall,
    double? avatarIconMedium,
    double? avatarIconLarge,
    double? avatarIconExtraLarge,
    double? tooltipWidth,
    double? tooltipTitleWidth,
    double? tooltipArrowWidth,
    double? tooltipArrowHeight,
    double? paginationItemSize,
    double? navigationDrawerWidth,
    double? breakpointMobile,
    double? tapTargetMin,
    double? controlBorderWidth,
    double? emphasizedBorderWidth,
    double? inputDisabledBorderWidth,
    double? progressStrokeWidth,
    double? focusRingSpread,
    double? elevationBlur,
    double? elevationOffsetY,
    double? elevationSpread,
    double? cardShadowBlur,
    double? cardShadowOffsetY,
    double? dropdownMenuWidth,
    double? iconButtonMedium,
    double? iconSizeMedium,
    double? snackbarShadowBlur,
  }) {
    return SldsDimensionTokens(
      space0: space0 ?? this.space0,
      space1: space1 ?? this.space1,
      space2: space2 ?? this.space2,
      space4: space4 ?? this.space4,
      space6: space6 ?? this.space6,
      space8: space8 ?? this.space8,
      space10: space10 ?? this.space10,
      space12: space12 ?? this.space12,
      space16: space16 ?? this.space16,
      space20: space20 ?? this.space20,
      space24: space24 ?? this.space24,
      space32: space32 ?? this.space32,
      space40: space40 ?? this.space40,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusXl: radiusXl ?? this.radiusXl,
      radius2xl: radius2xl ?? this.radius2xl,
      radius3xl: radius3xl ?? this.radius3xl,
      radius4xl: radius4xl ?? this.radius4xl,
      radiusFull: radiusFull ?? this.radiusFull,
      buttonHeightSmall: buttonHeightSmall ?? this.buttonHeightSmall,
      buttonHeightMedium: buttonHeightMedium ?? this.buttonHeightMedium,
      buttonHeightLarge: buttonHeightLarge ?? this.buttonHeightLarge,
      buttonHeightExtraLarge:
          buttonHeightExtraLarge ?? this.buttonHeightExtraLarge,
      inputWidth: inputWidth ?? this.inputWidth,
      inputHeight: inputHeight ?? this.inputHeight,
      inputHeightCompact: inputHeightCompact ?? this.inputHeightCompact,
      textAreaHeight: textAreaHeight ?? this.textAreaHeight,
      checkboxDefault: checkboxDefault ?? this.checkboxDefault,
      checkboxLarge: checkboxLarge ?? this.checkboxLarge,
      radioDefault: radioDefault ?? this.radioDefault,
      radioLarge: radioLarge ?? this.radioLarge,
      toggleWidth: toggleWidth ?? this.toggleWidth,
      toggleHeight: toggleHeight ?? this.toggleHeight,
      toggleThumb: toggleThumb ?? this.toggleThumb,
      cardWidth: cardWidth ?? this.cardWidth,
      cardHeight: cardHeight ?? this.cardHeight,
      cardImageHeight: cardImageHeight ?? this.cardImageHeight,
      dialogWidth: dialogWidth ?? this.dialogWidth,
      snackbarWidth: snackbarWidth ?? this.snackbarWidth,
      tabStripWidth: tabStripWidth ?? this.tabStripWidth,
      tabBadgeMinWidth: tabBadgeMinWidth ?? this.tabBadgeMinWidth,
      tabBadgeWidth: tabBadgeWidth ?? this.tabBadgeWidth,
      listItemWidth: listItemWidth ?? this.listItemWidth,
      listSlotSize: listSlotSize ?? this.listSlotSize,
      accordionWidth: accordionWidth ?? this.accordionWidth,
      progressWidth: progressWidth ?? this.progressWidth,
      progressLabelWidth: progressLabelWidth ?? this.progressLabelWidth,
      progressSegmentHeight:
          progressSegmentHeight ?? this.progressSegmentHeight,
      stepperWidth: stepperWidth ?? this.stepperWidth,
      avatarSize16: avatarSize16 ?? this.avatarSize16,
      avatarSize20: avatarSize20 ?? this.avatarSize20,
      avatarSize24: avatarSize24 ?? this.avatarSize24,
      avatarSize32: avatarSize32 ?? this.avatarSize32,
      avatarSize40: avatarSize40 ?? this.avatarSize40,
      avatarSize48: avatarSize48 ?? this.avatarSize48,
      avatarSize56: avatarSize56 ?? this.avatarSize56,
      avatarIconExtraSmall: avatarIconExtraSmall ?? this.avatarIconExtraSmall,
      avatarIconSmall: avatarIconSmall ?? this.avatarIconSmall,
      avatarIconMedium: avatarIconMedium ?? this.avatarIconMedium,
      avatarIconLarge: avatarIconLarge ?? this.avatarIconLarge,
      avatarIconExtraLarge: avatarIconExtraLarge ?? this.avatarIconExtraLarge,
      tooltipWidth: tooltipWidth ?? this.tooltipWidth,
      tooltipTitleWidth: tooltipTitleWidth ?? this.tooltipTitleWidth,
      tooltipArrowWidth: tooltipArrowWidth ?? this.tooltipArrowWidth,
      tooltipArrowHeight: tooltipArrowHeight ?? this.tooltipArrowHeight,
      paginationItemSize: paginationItemSize ?? this.paginationItemSize,
      navigationDrawerWidth:
          navigationDrawerWidth ?? this.navigationDrawerWidth,
      breakpointMobile: breakpointMobile ?? this.breakpointMobile,
      tapTargetMin: tapTargetMin ?? this.tapTargetMin,
      controlBorderWidth: controlBorderWidth ?? this.controlBorderWidth,
      emphasizedBorderWidth:
          emphasizedBorderWidth ?? this.emphasizedBorderWidth,
      inputDisabledBorderWidth:
          inputDisabledBorderWidth ?? this.inputDisabledBorderWidth,
      progressStrokeWidth: progressStrokeWidth ?? this.progressStrokeWidth,
      focusRingSpread: focusRingSpread ?? this.focusRingSpread,
      elevationBlur: elevationBlur ?? this.elevationBlur,
      elevationOffsetY: elevationOffsetY ?? this.elevationOffsetY,
      elevationSpread: elevationSpread ?? this.elevationSpread,
      cardShadowBlur: cardShadowBlur ?? this.cardShadowBlur,
      cardShadowOffsetY: cardShadowOffsetY ?? this.cardShadowOffsetY,
      dropdownMenuWidth: dropdownMenuWidth ?? this.dropdownMenuWidth,
      iconButtonMedium: iconButtonMedium ?? this.iconButtonMedium,
      iconSizeMedium: iconSizeMedium ?? this.iconSizeMedium,
      snackbarShadowBlur: snackbarShadowBlur ?? this.snackbarShadowBlur,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SldsDimensionTokens &&
        other.space0 == space0 &&
        other.space1 == space1 &&
        other.space2 == space2 &&
        other.space4 == space4 &&
        other.space6 == space6 &&
        other.space8 == space8 &&
        other.space10 == space10 &&
        other.space12 == space12 &&
        other.space16 == space16 &&
        other.space20 == space20 &&
        other.space24 == space24 &&
        other.space32 == space32 &&
        other.space40 == space40 &&
        other.radiusSm == radiusSm &&
        other.radiusMd == radiusMd &&
        other.radiusLg == radiusLg &&
        other.radiusXl == radiusXl &&
        other.radius2xl == radius2xl &&
        other.radius3xl == radius3xl &&
        other.radius4xl == radius4xl &&
        other.radiusFull == radiusFull &&
        other.buttonHeightSmall == buttonHeightSmall &&
        other.buttonHeightMedium == buttonHeightMedium &&
        other.buttonHeightLarge == buttonHeightLarge &&
        other.buttonHeightExtraLarge == buttonHeightExtraLarge &&
        other.inputWidth == inputWidth &&
        other.inputHeight == inputHeight &&
        other.inputHeightCompact == inputHeightCompact &&
        other.textAreaHeight == textAreaHeight &&
        other.checkboxDefault == checkboxDefault &&
        other.checkboxLarge == checkboxLarge &&
        other.radioDefault == radioDefault &&
        other.radioLarge == radioLarge &&
        other.toggleWidth == toggleWidth &&
        other.toggleHeight == toggleHeight &&
        other.toggleThumb == toggleThumb &&
        other.cardWidth == cardWidth &&
        other.cardHeight == cardHeight &&
        other.cardImageHeight == cardImageHeight &&
        other.dialogWidth == dialogWidth &&
        other.snackbarWidth == snackbarWidth &&
        other.tabStripWidth == tabStripWidth &&
        other.tabBadgeMinWidth == tabBadgeMinWidth &&
        other.tabBadgeWidth == tabBadgeWidth &&
        other.listItemWidth == listItemWidth &&
        other.listSlotSize == listSlotSize &&
        other.accordionWidth == accordionWidth &&
        other.progressWidth == progressWidth &&
        other.progressLabelWidth == progressLabelWidth &&
        other.progressSegmentHeight == progressSegmentHeight &&
        other.stepperWidth == stepperWidth &&
        other.avatarSize16 == avatarSize16 &&
        other.avatarSize20 == avatarSize20 &&
        other.avatarSize24 == avatarSize24 &&
        other.avatarSize32 == avatarSize32 &&
        other.avatarSize40 == avatarSize40 &&
        other.avatarSize48 == avatarSize48 &&
        other.avatarSize56 == avatarSize56 &&
        other.avatarIconExtraSmall == avatarIconExtraSmall &&
        other.avatarIconSmall == avatarIconSmall &&
        other.avatarIconMedium == avatarIconMedium &&
        other.avatarIconLarge == avatarIconLarge &&
        other.avatarIconExtraLarge == avatarIconExtraLarge &&
        other.tooltipWidth == tooltipWidth &&
        other.tooltipTitleWidth == tooltipTitleWidth &&
        other.tooltipArrowWidth == tooltipArrowWidth &&
        other.tooltipArrowHeight == tooltipArrowHeight &&
        other.paginationItemSize == paginationItemSize &&
        other.navigationDrawerWidth == navigationDrawerWidth &&
        other.breakpointMobile == breakpointMobile &&
        other.tapTargetMin == tapTargetMin &&
        other.controlBorderWidth == controlBorderWidth &&
        other.emphasizedBorderWidth == emphasizedBorderWidth &&
        other.inputDisabledBorderWidth == inputDisabledBorderWidth &&
        other.progressStrokeWidth == progressStrokeWidth &&
        other.focusRingSpread == focusRingSpread &&
        other.elevationBlur == elevationBlur &&
        other.elevationOffsetY == elevationOffsetY &&
        other.elevationSpread == elevationSpread &&
        other.cardShadowBlur == cardShadowBlur &&
        other.cardShadowOffsetY == cardShadowOffsetY &&
        other.dropdownMenuWidth == dropdownMenuWidth &&
        other.iconButtonMedium == iconButtonMedium &&
        other.iconSizeMedium == iconSizeMedium &&
        other.snackbarShadowBlur == snackbarShadowBlur;
  }

  @override
  int get hashCode => Object.hashAll(<double>[
    space0,
    space1,
    space2,
    space4,
    space6,
    space8,
    space10,
    space12,
    space16,
    space20,
    space24,
    space32,
    space40,
    radiusSm,
    radiusMd,
    radiusLg,
    radiusXl,
    radius2xl,
    radius3xl,
    radius4xl,
    radiusFull,
    buttonHeightSmall,
    buttonHeightMedium,
    buttonHeightLarge,
    buttonHeightExtraLarge,
    inputWidth,
    inputHeight,
    inputHeightCompact,
    textAreaHeight,
    checkboxDefault,
    checkboxLarge,
    radioDefault,
    radioLarge,
    toggleWidth,
    toggleHeight,
    toggleThumb,
    cardWidth,
    cardHeight,
    cardImageHeight,
    dialogWidth,
    snackbarWidth,
    tabStripWidth,
    tabBadgeMinWidth,
    tabBadgeWidth,
    listItemWidth,
    listSlotSize,
    accordionWidth,
    progressWidth,
    progressLabelWidth,
    progressSegmentHeight,
    stepperWidth,
    avatarSize16,
    avatarSize20,
    avatarSize24,
    avatarSize32,
    avatarSize40,
    avatarSize48,
    avatarSize56,
    avatarIconExtraSmall,
    avatarIconSmall,
    avatarIconMedium,
    avatarIconLarge,
    avatarIconExtraLarge,
    tooltipWidth,
    tooltipTitleWidth,
    tooltipArrowWidth,
    tooltipArrowHeight,
    paginationItemSize,
    navigationDrawerWidth,
    breakpointMobile,
    tapTargetMin,
    controlBorderWidth,
    emphasizedBorderWidth,
    inputDisabledBorderWidth,
    progressStrokeWidth,
    focusRingSpread,
    elevationBlur,
    elevationOffsetY,
    elevationSpread,
    cardShadowBlur,
    cardShadowOffsetY,
    dropdownMenuWidth,
    iconButtonMedium,
    iconSizeMedium,
    snackbarShadowBlur,
  ]);
}
