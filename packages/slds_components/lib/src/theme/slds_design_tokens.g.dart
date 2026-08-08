import 'package:flutter/widgets.dart';

// GENERATED FILE — DO NOT EDIT BY HAND.
// Source: tokens/slds_alpha.tokens.json
// Regenerate: dart run tool/generate_tokens.dart

/// Figma-backed SLDS color tokens.
class SldsColorTokens {
  /// Creates color tokens.
  const SldsColorTokens({
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.surfacePage,
    required this.surfaceCard,
    required this.surfaceRaised,
    required this.surfaceHover,
    required this.surfacePrimary,
    required this.borderDefault,
    required this.borderDecorative,
    required this.cardBorder,
    required this.focusRing,
    required this.focusHalo,
    required this.focusRingError,
    required this.focusHaloError,
    required this.shadowColor,
    required this.headerBackground,
    required this.mastheadBackground,
    required this.serviceCardIcon,
    required this.summaryBoxAccent,
    required this.tagApproved,
    required this.tagNotice,
    required this.headerBorder,
    required this.headerProgressTrack,
    required this.buttonPrimaryBackground,
    required this.buttonPrimaryLabel,
    required this.buttonPrimaryHover,
    required this.buttonPrimaryPressed,
    required this.buttonSecondaryBackground,
    required this.buttonSecondaryLabel,
    required this.buttonSecondaryBorder,
    required this.buttonSecondaryHover,
    required this.buttonSecondaryPressed,
    required this.buttonGhostLabel,
    required this.buttonGhostHover,
    required this.buttonGhostPressed,
    required this.buttonDestructiveBackground,
    required this.buttonDestructiveLabel,
    required this.buttonDestructiveHover,
    required this.buttonDestructivePressed,
    required this.disabledBackground,
    required this.disabledForeground,
    required this.disabledBorder,
    required this.textStaticBlack,
    required this.notificationBadgeBackground,
    required this.bannerWarningTitle,
    required this.badgeArchivedText,
    required this.listBackground,
    required this.listBackgroundHover,
    required this.inputLabel,
    required this.inputPlaceholder,
    required this.inputHelper,
    required this.inputIcon,
    required this.inputBorderDefault,
    required this.inputBorderFocused,
    required this.inputBorderError,
    required this.inputBorderDisabled,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.badgeSuccessText,
    required this.badgeSuccessBackground,
    required this.badgePendingText,
    required this.badgePendingBackground,
    required this.badgeErrorText,
    required this.badgeErrorBackground,
    required this.badgeInfoText,
    required this.badgeInfoBackground,
    required this.badgeNeutralText,
    required this.badgeNeutralBackground,
    required this.badgeSubmittedText,
    required this.badgeSubmittedBackground,
    required this.badgeInReviewText,
    required this.badgeInReviewBackground,
    required this.badgeApprovedText,
    required this.badgeApprovedBackground,
    required this.badgeEscalatedText,
    required this.badgeEscalatedBackground,
    required this.badgeOnHoldText,
    required this.badgeOnHoldBackground,
    required this.tooltipBackground,
    required this.tooltipText,
  });

  /// Primary text.
  final Color textPrimary;

  /// Secondary text.
  final Color textSecondary;

  /// Tertiary text.
  final Color textTertiary;

  /// Root page surface.
  final Color surfacePage;

  /// Card and overlay surface.
  final Color surfaceCard;

  /// Raised grey surface for elevated blocks (snackbar, back-to-top, dropdown
  /// hover). Figma calls this out as distinct from the white card surface.
  final Color surfaceRaised;

  /// Hover surface.
  final Color surfaceHover;

  /// Control fill surface.
  final Color surfacePrimary;

  /// Default border.
  final Color borderDefault;

  /// Decorative border.
  final Color borderDecorative;

  /// Figma Card/Border — the card family's outline, lighter than the
  /// decorative border used elsewhere.
  final Color cardBorder;

  /// Focus ring.
  final Color focusRing;

  /// Focus halo.
  final Color focusHalo;

  /// Figma Focus/Error ring — destructive Button/Icon Button focus outline.
  final Color focusRingError;

  /// Figma Focus/Error halo — destructive Button/Icon Button focus glow.
  final Color focusHaloError;

  /// Base colour for elevation shadows. Figma uses pure black at the
  /// elevation alpha rather than tinting from the text colour.
  final Color shadowColor;

  /// Top navigation surface.
  final Color headerBackground;

  /// Government masthead surface.
  final Color mastheadBackground;

  /// Leading icon colour for a Service Card.
  final Color serviceCardIcon;

  /// Summary Box outline, icon, and title colour.
  final Color summaryBoxAccent;

  /// Approved Tag fill from Figma.
  final Color tagApproved;

  /// Notice Tag fill from Figma.
  final Color tagNotice;

  /// Top navigation divider.
  final Color headerBorder;

  /// Incomplete top navigation progress segment.
  final Color headerProgressTrack;

  /// Primary button background.
  final Color buttonPrimaryBackground;

  /// Primary button label.
  final Color buttonPrimaryLabel;

  /// Primary button hover background.
  final Color buttonPrimaryHover;

  /// Primary button pressed background.
  final Color buttonPrimaryPressed;

  /// Secondary button background.
  final Color buttonSecondaryBackground;

  /// Secondary button label.
  final Color buttonSecondaryLabel;

  /// Secondary button border.
  final Color buttonSecondaryBorder;

  /// Secondary button hover background.
  final Color buttonSecondaryHover;

  /// Secondary button pressed background.
  final Color buttonSecondaryPressed;

  /// Ghost button label.
  final Color buttonGhostLabel;

  /// Ghost button hover background.
  final Color buttonGhostHover;

  /// Ghost button pressed background.
  final Color buttonGhostPressed;

  /// Destructive button background.
  final Color buttonDestructiveBackground;

  /// Destructive button label.
  final Color buttonDestructiveLabel;

  /// Destructive button hover background.
  final Color buttonDestructiveHover;

  /// Destructive button pressed background.
  final Color buttonDestructivePressed;

  /// Disabled fill.
  final Color disabledBackground;

  /// Disabled foreground.
  final Color disabledForeground;

  /// Figma Button/Disabled/Border — lighter than [disabledBackground].
  final Color disabledBorder;

  /// Figma Text/Static Black — label colour on amber/gold fills.
  final Color textStaticBlack;

  /// Figma Red/500 — the small notification-count badge on Bottom Tab Bar.
  final Color notificationBadgeBackground;

  /// Figma Banner/Warning/Title — darker than the warning icon/border.
  final Color bannerWarningTitle;

  /// Figma Badge/Archived/Text — lighter than the shared Neutral/Draft text.
  final Color badgeArchivedText;

  /// Figma List/Background — Service Card and List Item resting fill.
  final Color listBackground;

  /// Figma List/Background/Hover.
  final Color listBackgroundHover;

  /// Input label.
  final Color inputLabel;

  /// Input placeholder.
  final Color inputPlaceholder;

  /// Input helper text.
  final Color inputHelper;

  /// Input leading/trailing icon.
  final Color inputIcon;

  /// Input default border.
  final Color inputBorderDefault;

  /// Input focus border.
  final Color inputBorderFocused;

  /// Input error border.
  final Color inputBorderError;

  /// Input disabled border.
  final Color inputBorderDisabled;

  /// Error color.
  final Color error;

  /// Success color.
  final Color success;

  /// Warning color.
  final Color warning;

  /// Info color.
  final Color info;

  /// Success badge text.
  final Color badgeSuccessText;

  /// Success badge background.
  final Color badgeSuccessBackground;

  /// Pending badge text.
  final Color badgePendingText;

  /// Pending badge background.
  final Color badgePendingBackground;

  /// Error badge text.
  final Color badgeErrorText;

  /// Error badge background.
  final Color badgeErrorBackground;

  /// Info badge text.
  final Color badgeInfoText;

  /// Info badge background.
  final Color badgeInfoBackground;

  /// Neutral badge text.
  final Color badgeNeutralText;

  /// Neutral badge background.
  final Color badgeNeutralBackground;

  /// Submitted badge text.
  final Color badgeSubmittedText;

  /// Submitted badge background.
  final Color badgeSubmittedBackground;

  /// In review badge text.
  final Color badgeInReviewText;

  /// In review badge background.
  final Color badgeInReviewBackground;

  /// Approved badge text.
  final Color badgeApprovedText;

  /// Approved badge background.
  final Color badgeApprovedBackground;

  /// Escalated badge text.
  final Color badgeEscalatedText;

  /// Escalated badge background.
  final Color badgeEscalatedBackground;

  /// On hold badge text.
  final Color badgeOnHoldText;

  /// On hold badge background.
  final Color badgeOnHoldBackground;

  /// Tooltip surface.
  final Color tooltipBackground;

  /// Tooltip text.
  final Color tooltipText;

  /// Creates a copy with only the supplied colors replaced.
  SldsColorTokens copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? surfacePage,
    Color? surfaceCard,
    Color? surfaceRaised,
    Color? surfaceHover,
    Color? surfacePrimary,
    Color? borderDefault,
    Color? borderDecorative,
    Color? cardBorder,
    Color? focusRing,
    Color? focusHalo,
    Color? focusRingError,
    Color? focusHaloError,
    Color? shadowColor,
    Color? headerBackground,
    Color? mastheadBackground,
    Color? serviceCardIcon,
    Color? summaryBoxAccent,
    Color? tagApproved,
    Color? tagNotice,
    Color? headerBorder,
    Color? headerProgressTrack,
    Color? buttonPrimaryBackground,
    Color? buttonPrimaryLabel,
    Color? buttonPrimaryHover,
    Color? buttonPrimaryPressed,
    Color? buttonSecondaryBackground,
    Color? buttonSecondaryLabel,
    Color? buttonSecondaryBorder,
    Color? buttonSecondaryHover,
    Color? buttonSecondaryPressed,
    Color? buttonGhostLabel,
    Color? buttonGhostHover,
    Color? buttonGhostPressed,
    Color? buttonDestructiveBackground,
    Color? buttonDestructiveLabel,
    Color? buttonDestructiveHover,
    Color? buttonDestructivePressed,
    Color? disabledBackground,
    Color? disabledForeground,
    Color? disabledBorder,
    Color? textStaticBlack,
    Color? notificationBadgeBackground,
    Color? bannerWarningTitle,
    Color? badgeArchivedText,
    Color? listBackground,
    Color? listBackgroundHover,
    Color? inputLabel,
    Color? inputPlaceholder,
    Color? inputHelper,
    Color? inputIcon,
    Color? inputBorderDefault,
    Color? inputBorderFocused,
    Color? inputBorderError,
    Color? inputBorderDisabled,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
    Color? badgeSuccessText,
    Color? badgeSuccessBackground,
    Color? badgePendingText,
    Color? badgePendingBackground,
    Color? badgeErrorText,
    Color? badgeErrorBackground,
    Color? badgeInfoText,
    Color? badgeInfoBackground,
    Color? badgeNeutralText,
    Color? badgeNeutralBackground,
    Color? badgeSubmittedText,
    Color? badgeSubmittedBackground,
    Color? badgeInReviewText,
    Color? badgeInReviewBackground,
    Color? badgeApprovedText,
    Color? badgeApprovedBackground,
    Color? badgeEscalatedText,
    Color? badgeEscalatedBackground,
    Color? badgeOnHoldText,
    Color? badgeOnHoldBackground,
    Color? tooltipBackground,
    Color? tooltipText,
  }) => SldsColorTokens(
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textTertiary: textTertiary ?? this.textTertiary,
    surfacePage: surfacePage ?? this.surfacePage,
    surfaceCard: surfaceCard ?? this.surfaceCard,
    surfaceRaised: surfaceRaised ?? this.surfaceRaised,
    surfaceHover: surfaceHover ?? this.surfaceHover,
    surfacePrimary: surfacePrimary ?? this.surfacePrimary,
    borderDefault: borderDefault ?? this.borderDefault,
    borderDecorative: borderDecorative ?? this.borderDecorative,
    cardBorder: cardBorder ?? this.cardBorder,
    focusRing: focusRing ?? this.focusRing,
    focusHalo: focusHalo ?? this.focusHalo,
    focusRingError: focusRingError ?? this.focusRingError,
    focusHaloError: focusHaloError ?? this.focusHaloError,
    shadowColor: shadowColor ?? this.shadowColor,
    headerBackground: headerBackground ?? this.headerBackground,
    mastheadBackground: mastheadBackground ?? this.mastheadBackground,
    serviceCardIcon: serviceCardIcon ?? this.serviceCardIcon,
    summaryBoxAccent: summaryBoxAccent ?? this.summaryBoxAccent,
    tagApproved: tagApproved ?? this.tagApproved,
    tagNotice: tagNotice ?? this.tagNotice,
    headerBorder: headerBorder ?? this.headerBorder,
    headerProgressTrack: headerProgressTrack ?? this.headerProgressTrack,
    buttonPrimaryBackground:
        buttonPrimaryBackground ?? this.buttonPrimaryBackground,
    buttonPrimaryLabel: buttonPrimaryLabel ?? this.buttonPrimaryLabel,
    buttonPrimaryHover: buttonPrimaryHover ?? this.buttonPrimaryHover,
    buttonPrimaryPressed: buttonPrimaryPressed ?? this.buttonPrimaryPressed,
    buttonSecondaryBackground:
        buttonSecondaryBackground ?? this.buttonSecondaryBackground,
    buttonSecondaryLabel: buttonSecondaryLabel ?? this.buttonSecondaryLabel,
    buttonSecondaryBorder: buttonSecondaryBorder ?? this.buttonSecondaryBorder,
    buttonSecondaryHover: buttonSecondaryHover ?? this.buttonSecondaryHover,
    buttonSecondaryPressed:
        buttonSecondaryPressed ?? this.buttonSecondaryPressed,
    buttonGhostLabel: buttonGhostLabel ?? this.buttonGhostLabel,
    buttonGhostHover: buttonGhostHover ?? this.buttonGhostHover,
    buttonGhostPressed: buttonGhostPressed ?? this.buttonGhostPressed,
    buttonDestructiveBackground:
        buttonDestructiveBackground ?? this.buttonDestructiveBackground,
    buttonDestructiveLabel:
        buttonDestructiveLabel ?? this.buttonDestructiveLabel,
    buttonDestructiveHover:
        buttonDestructiveHover ?? this.buttonDestructiveHover,
    buttonDestructivePressed:
        buttonDestructivePressed ?? this.buttonDestructivePressed,
    disabledBackground: disabledBackground ?? this.disabledBackground,
    disabledForeground: disabledForeground ?? this.disabledForeground,
    disabledBorder: disabledBorder ?? this.disabledBorder,
    textStaticBlack: textStaticBlack ?? this.textStaticBlack,
    notificationBadgeBackground:
        notificationBadgeBackground ?? this.notificationBadgeBackground,
    bannerWarningTitle: bannerWarningTitle ?? this.bannerWarningTitle,
    badgeArchivedText: badgeArchivedText ?? this.badgeArchivedText,
    listBackground: listBackground ?? this.listBackground,
    listBackgroundHover: listBackgroundHover ?? this.listBackgroundHover,
    inputLabel: inputLabel ?? this.inputLabel,
    inputPlaceholder: inputPlaceholder ?? this.inputPlaceholder,
    inputHelper: inputHelper ?? this.inputHelper,
    inputIcon: inputIcon ?? this.inputIcon,
    inputBorderDefault: inputBorderDefault ?? this.inputBorderDefault,
    inputBorderFocused: inputBorderFocused ?? this.inputBorderFocused,
    inputBorderError: inputBorderError ?? this.inputBorderError,
    inputBorderDisabled: inputBorderDisabled ?? this.inputBorderDisabled,
    error: error ?? this.error,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    info: info ?? this.info,
    badgeSuccessText: badgeSuccessText ?? this.badgeSuccessText,
    badgeSuccessBackground:
        badgeSuccessBackground ?? this.badgeSuccessBackground,
    badgePendingText: badgePendingText ?? this.badgePendingText,
    badgePendingBackground:
        badgePendingBackground ?? this.badgePendingBackground,
    badgeErrorText: badgeErrorText ?? this.badgeErrorText,
    badgeErrorBackground: badgeErrorBackground ?? this.badgeErrorBackground,
    badgeInfoText: badgeInfoText ?? this.badgeInfoText,
    badgeInfoBackground: badgeInfoBackground ?? this.badgeInfoBackground,
    badgeNeutralText: badgeNeutralText ?? this.badgeNeutralText,
    badgeNeutralBackground:
        badgeNeutralBackground ?? this.badgeNeutralBackground,
    badgeSubmittedText: badgeSubmittedText ?? this.badgeSubmittedText,
    badgeSubmittedBackground:
        badgeSubmittedBackground ?? this.badgeSubmittedBackground,
    badgeInReviewText: badgeInReviewText ?? this.badgeInReviewText,
    badgeInReviewBackground:
        badgeInReviewBackground ?? this.badgeInReviewBackground,
    badgeApprovedText: badgeApprovedText ?? this.badgeApprovedText,
    badgeApprovedBackground:
        badgeApprovedBackground ?? this.badgeApprovedBackground,
    badgeEscalatedText: badgeEscalatedText ?? this.badgeEscalatedText,
    badgeEscalatedBackground:
        badgeEscalatedBackground ?? this.badgeEscalatedBackground,
    badgeOnHoldText: badgeOnHoldText ?? this.badgeOnHoldText,
    badgeOnHoldBackground: badgeOnHoldBackground ?? this.badgeOnHoldBackground,
    tooltipBackground: tooltipBackground ?? this.tooltipBackground,
    tooltipText: tooltipText ?? this.tooltipText,
  );

  /// Light color mode.
  factory SldsColorTokens.light() => const SldsColorTokens(
    textPrimary: Color(0xff222222),
    textSecondary: Color(0xff676c73),
    textTertiary: Color(0xffbcbcbc),
    surfacePage: Color(0xfff7f7f7),
    surfaceCard: Color(0xffffffff),
    surfaceRaised: Color(0xffeeeeee),
    surfaceHover: Color(0xfff5f6f8),
    surfacePrimary: Color(0xfffdfdfd),
    borderDefault: Color(0xffbcbcbc),
    borderDecorative: Color(0xffdadde2),
    cardBorder: Color(0xffdddddd),
    focusRing: Color(0xffffd740),
    focusHalo: Color(0xffffe880),
    focusRingError: Color(0xfff47272),
    focusHaloError: Color(0xfff47272),
    shadowColor: Color(0xff000000),
    headerBackground: Color(0xfff7f7f7),
    mastheadBackground: Color(0xff8d153a),
    serviceCardIcon: Color(0xff6c3df5),
    summaryBoxAccent: Color(0xff0e9db0),
    tagApproved: Color(0xff059669),
    tagNotice: Color(0xfff57c00),
    headerBorder: Color(0xffdddddd),
    headerProgressTrack: Color(0xffffffff),
    buttonPrimaryBackground: Color(0xffffc700),
    buttonPrimaryLabel: Color(0xff222222),
    buttonPrimaryHover: Color(0xffe0ae00),
    buttonPrimaryPressed: Color(0xffe0ae00),
    buttonSecondaryBackground: Color(0xffffffff),
    buttonSecondaryLabel: Color(0xff222222),
    buttonSecondaryBorder: Color(0xffcdcdcd),
    buttonSecondaryHover: Color(0xffeeeeee),
    buttonSecondaryPressed: Color(0xffffffff),
    buttonGhostLabel: Color(0xff222222),
    buttonGhostHover: Color(0xffeeeeee),
    buttonGhostPressed: Color(0xffffffff),
    buttonDestructiveBackground: Color(0xffd32f2f),
    buttonDestructiveLabel: Color(0xffffffff),
    buttonDestructiveHover: Color(0xffb91c1c),
    buttonDestructivePressed: Color(0xffb91c1c),
    disabledBackground: Color(0xffdddddd),
    disabledForeground: Color(0xffbcbcbc),
    disabledBorder: Color(0xffeeeeee),
    textStaticBlack: Color(0xff000000),
    notificationBadgeBackground: Color(0xffdc2626),
    bannerWarningTitle: Color(0xff503d00),
    badgeArchivedText: Color(0xffbcbcbc),
    listBackground: Color(0xfff7f7f7),
    listBackgroundHover: Color(0xffeeeeee),
    inputLabel: Color(0xff222222),
    inputPlaceholder: Color(0xffbcbcbc),
    inputHelper: Color(0xff898989),
    inputIcon: Color(0xffababab),
    inputBorderDefault: Color(0xffbcbcbc),
    inputBorderFocused: Color(0xffffc700),
    inputBorderError: Color(0xffd32f2f),
    inputBorderDisabled: Color(0xffeeeeee),
    error: Color(0xffd32f2f),
    success: Color(0xff1faa63),
    warning: Color(0xffb38a00),
    info: Color(0xff0d6b7b),
    badgeSuccessText: Color(0xff1faa63),
    badgeSuccessBackground: Color(0xffe0f2ec),
    badgePendingText: Color(0xffb38a00),
    badgePendingBackground: Color(0xfffff8d6),
    badgeErrorText: Color(0xffd32f2f),
    badgeErrorBackground: Color(0xfffdecea),
    badgeInfoText: Color(0xff0d6b7b),
    badgeInfoBackground: Color(0xffffffff),
    badgeNeutralText: Color(0xff898989),
    badgeNeutralBackground: Color(0xffeeeeee),
    badgeSubmittedText: Color(0xff0e9db0),
    badgeSubmittedBackground: Color(0xffd0f0f5),
    badgeInReviewText: Color(0xff1a56d6),
    badgeInReviewBackground: Color(0xffe3edff),
    badgeApprovedText: Color(0xff059669),
    badgeApprovedBackground: Color(0xffe0f2ec),
    badgeEscalatedText: Color(0xfff57c00),
    badgeEscalatedBackground: Color(0xfffef0e3),
    badgeOnHoldText: Color(0xff6747c7),
    badgeOnHoldBackground: Color(0xffede9ff),
    tooltipBackground: Color(0xff222222),
    tooltipText: Color(0xffffffff),
  );

  /// Dark color mode.
  factory SldsColorTokens.dark() => const SldsColorTokens(
    textPrimary: Color(0xffffffff),
    textSecondary: Color(0xffb8bdc4),
    textTertiary: Color(0xff676c73),
    surfacePage: Color(0xff111111),
    surfaceCard: Color(0xff212529),
    surfaceRaised: Color(0xff2b3035),
    surfaceHover: Color(0xff212529),
    surfacePrimary: Color(0xff212529),
    borderDefault: Color(0xff3f4548),
    borderDecorative: Color(0xff374151),
    cardBorder: Color(0xff3f4548),
    focusRing: Color(0xffffd740),
    focusHalo: Color(0xffffe880),
    focusRingError: Color(0xfff47272),
    focusHaloError: Color(0xfff47272),
    shadowColor: Color(0xff000000),
    headerBackground: Color(0xff212529),
    mastheadBackground: Color(0xff8d153a),
    serviceCardIcon: Color(0xffa78bfa),
    summaryBoxAccent: Color(0xff7dd8e8),
    tagApproved: Color(0xff5dc896),
    tagNotice: Color(0xffffe880),
    headerBorder: Color(0xff3f4548),
    headerProgressTrack: Color(0xff111111),
    buttonPrimaryBackground: Color(0xffffc700),
    buttonPrimaryLabel: Color(0xff111111),
    buttonPrimaryHover: Color(0xffffd740),
    buttonPrimaryPressed: Color(0xffffd740),
    buttonSecondaryBackground: Color(0xff212529),
    buttonSecondaryLabel: Color(0xffffffff),
    buttonSecondaryBorder: Color(0xff374151),
    buttonSecondaryHover: Color(0xff212529),
    buttonSecondaryPressed: Color(0xff1f2937),
    buttonGhostLabel: Color(0xffffffff),
    buttonGhostHover: Color(0xff212529),
    buttonGhostPressed: Color(0xff1f2937),
    buttonDestructiveBackground: Color(0xffd32f2f),
    buttonDestructiveLabel: Color(0xffffffff),
    buttonDestructiveHover: Color(0xffb91c1c),
    buttonDestructivePressed: Color(0xffb91c1c),
    disabledBackground: Color(0xff212529),
    disabledForeground: Color(0xff676c73),
    disabledBorder: Color(0xff2e3338),
    textStaticBlack: Color(0xff000000),
    notificationBadgeBackground: Color(0xffdc2626),
    bannerWarningTitle: Color(0xffffe880),
    badgeArchivedText: Color(0xff676c73),
    listBackground: Color(0xff111111),
    listBackgroundHover: Color(0xff212529),
    inputLabel: Color(0xffffffff),
    inputPlaceholder: Color(0xff676c73),
    inputHelper: Color(0xffb8bdc4),
    inputIcon: Color(0xffb8bdc4),
    inputBorderDefault: Color(0xff3f4548),
    inputBorderFocused: Color(0xffffc700),
    inputBorderError: Color(0xfff47272),
    inputBorderDisabled: Color(0xff3f4548),
    error: Color(0xfff47272),
    success: Color(0xff5dc896),
    warning: Color(0xffffe880),
    info: Color(0xff7dd8e8),
    badgeSuccessText: Color(0xff5dc896),
    badgeSuccessBackground: Color(0xff062b1a),
    badgePendingText: Color(0xffffe880),
    badgePendingBackground: Color(0xff2e2200),
    badgeErrorText: Color(0xfff47272),
    badgeErrorBackground: Color(0xff330d0d),
    badgeInfoText: Color(0xff7dd8e8),
    badgeInfoBackground: Color(0xff061f24),
    badgeNeutralText: Color(0xffb8bdc4),
    badgeNeutralBackground: Color(0xff212529),
    badgeSubmittedText: Color(0xff67d2e1),
    badgeSubmittedBackground: Color(0xff0a1733),
    badgeInReviewText: Color(0xff93c5fd),
    badgeInReviewBackground: Color(0xff0a1733),
    badgeApprovedText: Color(0xff34d399),
    badgeApprovedBackground: Color(0xff064e3b),
    badgeEscalatedText: Color(0xfffb923c),
    badgeEscalatedBackground: Color(0xff2e1800),
    badgeOnHoldText: Color(0xffa78bfa),
    badgeOnHoldBackground: Color(0xff1a0f38),
    tooltipBackground: Color(0xffffffff),
    tooltipText: Color(0xff111111),
  );

  /// High contrast color mode.
  factory SldsColorTokens.highContrast() => const SldsColorTokens(
    textPrimary: Color(0xff000000),
    textSecondary: Color(0xff000000),
    textTertiary: Color(0xff000000),
    surfacePage: Color(0xffffffff),
    surfaceCard: Color(0xffffffff),
    surfaceRaised: Color(0xffe8e8e8),
    surfaceHover: Color(0xffe8e8e8),
    surfacePrimary: Color(0xffffffff),
    borderDefault: Color(0xff000000),
    borderDecorative: Color(0xff000000),
    cardBorder: Color(0xff000000),
    focusRing: Color(0xff000000),
    focusHalo: Color(0xff000000),
    focusRingError: Color(0xff000000),
    focusHaloError: Color(0xff000000),
    shadowColor: Color(0xff000000),
    headerBackground: Color(0xffffffff),
    mastheadBackground: Color(0xff000000),
    serviceCardIcon: Color(0xff000000),
    summaryBoxAccent: Color(0xff000000),
    tagApproved: Color(0xff000000),
    tagNotice: Color(0xff000000),
    headerBorder: Color(0xff000000),
    headerProgressTrack: Color(0xffffffff),
    buttonPrimaryBackground: Color(0xffffc700),
    buttonPrimaryLabel: Color(0xff000000),
    buttonPrimaryHover: Color(0xffe0ae00),
    buttonPrimaryPressed: Color(0xffb38a00),
    buttonSecondaryBackground: Color(0xffffffff),
    buttonSecondaryLabel: Color(0xff000000),
    buttonSecondaryBorder: Color(0xff000000),
    buttonSecondaryHover: Color(0xffe8e8e8),
    buttonSecondaryPressed: Color(0xffd0d0d0),
    buttonGhostLabel: Color(0xff000000),
    buttonGhostHover: Color(0xffe8e8e8),
    buttonGhostPressed: Color(0xffd0d0d0),
    buttonDestructiveBackground: Color(0xffb91c1c),
    buttonDestructiveLabel: Color(0xffffffff),
    buttonDestructiveHover: Color(0xff991b1b),
    buttonDestructivePressed: Color(0xff7f1d1d),
    disabledBackground: Color(0xfff0f0f0),
    disabledForeground: Color(0xff595959),
    disabledBorder: Color(0xff595959),
    textStaticBlack: Color(0xff000000),
    notificationBadgeBackground: Color(0xffdc2626),
    bannerWarningTitle: Color(0xff503d00),
    badgeArchivedText: Color(0xff595959),
    listBackground: Color(0xffffffff),
    listBackgroundHover: Color(0xffe8e8e8),
    inputLabel: Color(0xff000000),
    inputPlaceholder: Color(0xff595959),
    inputHelper: Color(0xff000000),
    inputIcon: Color(0xff000000),
    inputBorderDefault: Color(0xff000000),
    inputBorderFocused: Color(0xff000000),
    inputBorderError: Color(0xff000000),
    inputBorderDisabled: Color(0xff595959),
    error: Color(0xffb91c1c),
    success: Color(0xff065f46),
    warning: Color(0xff503d00),
    info: Color(0xff0f4855),
    badgeSuccessText: Color(0xff065f46),
    badgeSuccessBackground: Color(0xffffffff),
    badgePendingText: Color(0xff503d00),
    badgePendingBackground: Color(0xffffffff),
    badgeErrorText: Color(0xffb91c1c),
    badgeErrorBackground: Color(0xffffffff),
    badgeInfoText: Color(0xff0f4855),
    badgeInfoBackground: Color(0xffffffff),
    badgeNeutralText: Color(0xff000000),
    badgeNeutralBackground: Color(0xffffffff),
    badgeSubmittedText: Color(0xff0f4855),
    badgeSubmittedBackground: Color(0xffffffff),
    badgeInReviewText: Color(0xff1e3a8a),
    badgeInReviewBackground: Color(0xffffffff),
    badgeApprovedText: Color(0xff065f46),
    badgeApprovedBackground: Color(0xffffffff),
    badgeEscalatedText: Color(0xff7c2d12),
    badgeEscalatedBackground: Color(0xffffffff),
    badgeOnHoldText: Color(0xff4c1d95),
    badgeOnHoldBackground: Color(0xffffffff),
    tooltipBackground: Color(0xff000000),
    tooltipText: Color(0xffffffff),
  );
}

/// SLDS dimension tokens.
class SldsDimensionTokens {
  /// Creates dimension tokens with optional overrides keyed by token name.
  const SldsDimensionTokens({Map<String, double> overrides = const {}})
    : _overrides = overrides;

  final Map<String, double> _overrides;

  /// Replaces only the supplied dimension values.
  SldsDimensionTokens copyWith({Map<String, double> overrides = const {}}) =>
      SldsDimensionTokens(overrides: {..._overrides, ...overrides});

  double _value(String name, double fallback) => _overrides[name] ?? fallback;

  /// No spacing.
  double get space0 => _value('space0', 0);

  /// 1px spacing.
  double get space1 => _value('space1', 1);

  /// 2px spacing.
  double get space2 => _value('space2', 2);

  /// 4px spacing.
  double get space4 => _value('space4', 4);

  /// 6px spacing.
  double get space6 => _value('space6', 6);

  /// 8px spacing.
  double get space8 => _value('space8', 8);

  /// 10px spacing.
  double get space10 => _value('space10', 10);

  /// 12px spacing.
  double get space12 => _value('space12', 12);

  /// 16px spacing.
  double get space16 => _value('space16', 16);

  /// 20px spacing.
  double get space20 => _value('space20', 20);

  /// 24px spacing.
  double get space24 => _value('space24', 24);

  /// 32px spacing.
  double get space32 => _value('space32', 32);

  /// 40px spacing.
  double get space40 => _value('space40', 40);

  /// Small radius.
  double get radiusSm => _value('radiusSm', 2);

  /// Medium radius.
  double get radiusMd => _value('radiusMd', 4);

  /// Large radius. Figma's compact Text Input field radius.
  double get radiusLg => _value('radiusLg', 6);

  /// XL radius.
  double get radiusXl => _value('radiusXl', 8);

  /// 2XL radius.
  double get radius2xl => _value('radius2xl', 12);

  /// 3XL radius.
  double get radius3xl => _value('radius3xl', 16);

  /// 4XL radius.
  double get radius4xl => _value('radius4xl', 24);

  /// Full radius.
  double get radiusFull => _value('radiusFull', 9999);

  /// Small button height.
  double get buttonHeightSmall => _value('buttonHeightSmall', 28);

  /// Medium button height.
  double get buttonHeightMedium => _value('buttonHeightMedium', 36);

  /// Large button height.
  double get buttonHeightLarge => _value('buttonHeightLarge', 48);

  /// Extra large button height.
  double get buttonHeightExtraLarge => _value('buttonHeightExtraLarge', 56);

  /// Figma input width.
  double get inputWidth => _value('inputWidth', 361);

  /// Figma input height.
  double get inputHeight => _value('inputHeight', 52);

  /// Figma compact Text Input field height (mobile-density fields).
  double get inputHeightCompact => _value('inputHeightCompact', 32);

  /// Figma text area content height.
  double get textAreaHeight => _value('textAreaHeight', 128);

  /// Default checkbox size.
  double get checkboxDefault => _value('checkboxDefault', 16);

  /// Large checkbox size.
  double get checkboxLarge => _value('checkboxLarge', 24);

  /// Default radio size.
  double get radioDefault => _value('radioDefault', 16);

  /// Large radio size.
  double get radioLarge => _value('radioLarge', 20);

  /// Toggle width.
  double get toggleWidth => _value('toggleWidth', 50.4);

  /// Toggle height.
  double get toggleHeight => _value('toggleHeight', 28);

  /// Toggle thumb size.
  double get toggleThumb => _value('toggleThumb', 22.4);

  /// Card width.
  double get cardWidth => _value('cardWidth', 343);

  /// Card height.
  double get cardHeight => _value('cardHeight', 200);

  /// Card image height.
  double get cardImageHeight => _value('cardImageHeight', 160);

  /// Dialog width.
  double get dialogWidth => _value('dialogWidth', 300);

  /// Snackbar width.
  double get snackbarWidth => _value('snackbarWidth', 361);

  /// Figma tab strip width.
  double get tabStripWidth => _value('tabStripWidth', 451);

  /// Minimum tab badge width.
  double get tabBadgeMinWidth => _value('tabBadgeMinWidth', 16);

  /// Default tab badge width.
  double get tabBadgeWidth => _value('tabBadgeWidth', 24);

  /// Figma list item width.
  double get listItemWidth => _value('listItemWidth', 400);

  /// List leading slot size.
  double get listSlotSize => _value('listSlotSize', 40);

  /// Figma accordion width.
  double get accordionWidth => _value('accordionWidth', 400);

  /// Figma progress bar width.
  double get progressWidth => _value('progressWidth', 339);

  /// Figma progress label width.
  double get progressLabelWidth => _value('progressLabelWidth', 40);

  /// Progress and step segment height.
  double get progressSegmentHeight => _value('progressSegmentHeight', 6);

  /// Figma stepper width.
  double get stepperWidth => _value('stepperWidth', 393);

  /// 16px avatar size.
  double get avatarSize16 => _value('avatarSize16', 16);

  /// 20px avatar size.
  double get avatarSize20 => _value('avatarSize20', 20);

  /// 24px avatar size.
  double get avatarSize24 => _value('avatarSize24', 24);

  /// 32px avatar size.
  double get avatarSize32 => _value('avatarSize32', 32);

  /// 40px avatar size.
  double get avatarSize40 => _value('avatarSize40', 40);

  /// 48px avatar size.
  double get avatarSize48 => _value('avatarSize48', 48);

  /// 56px avatar size.
  double get avatarSize56 => _value('avatarSize56', 56);

  /// 16px avatar icon slot.
  double get avatarIconExtraSmall => _value('avatarIconExtraSmall', 11.2);

  /// Small avatar icon size.
  double get avatarIconSmall => _value('avatarIconSmall', 14);

  /// Medium avatar icon size.
  double get avatarIconMedium => _value('avatarIconMedium', 16);

  /// Large avatar icon size.
  double get avatarIconLarge => _value('avatarIconLarge', 24);

  /// Extra large avatar icon size.
  double get avatarIconExtraLarge => _value('avatarIconExtraLarge', 28);

  /// Tooltip panel width.
  double get tooltipWidth => _value('tooltipWidth', 320);

  /// Compact title-only tooltip width.
  double get tooltipTitleWidth => _value('tooltipTitleWidth', 72);

  /// Tooltip arrow width.
  double get tooltipArrowWidth => _value('tooltipArrowWidth', 28);

  /// Tooltip arrow height.
  double get tooltipArrowHeight => _value('tooltipArrowHeight', 6);

  /// Pagination item frame.
  double get paginationItemSize => _value('paginationItemSize', 36);

  /// Navigation drawer width.
  double get navigationDrawerWidth => _value('navigationDrawerWidth', 320);

  /// Minimum accessible touch target size.
  double get tapTargetMin => _value('tapTargetMin', 48);

  /// Transparent alpha channel.
  int get transparentAlpha => 0;

  /// Elevation alpha channel.
  int get elevationAlpha => 31;

  /// Raised alpha channel.
  int get raisedAlpha => 13;

  /// Standard control border width.
  double get controlBorderWidth => _value('controlBorderWidth', 1);

  /// Emphasized control border width.
  double get emphasizedBorderWidth => _value('emphasizedBorderWidth', 1.5);

  /// Disabled input border width from Figma text input variants.
  double get inputDisabledBorderWidth =>
      _value('inputDisabledBorderWidth', 1.6);

  /// Circular progress stroke width.
  double get progressStrokeWidth => _value('progressStrokeWidth', 2);

  /// Focus ring spread radius.
  double get focusRingSpread => _value('focusRingSpread', 3);

  /// Overlay elevation blur radius.
  double get elevationBlur => _value('elevationBlur', 15);

  /// Overlay elevation y-offset.
  double get elevationOffsetY => _value('elevationOffsetY', 10);

  /// Overlay elevation spread radius.
  double get elevationSpread => _value('elevationSpread', -3);

  /// Card elevation blur radius.
  double get cardShadowBlur => _value('cardShadowBlur', 8);

  /// Card elevation y-offset.
  double get cardShadowOffsetY => _value('cardShadowOffsetY', 2);

  /// Dropdown open menu width.
  double get dropdownMenuWidth => _value('dropdownMenuWidth', 362);

  /// Medium icon button frame.
  double get iconButtonMedium => _value('iconButtonMedium', 36);

  /// Medium icon size.
  double get iconSizeMedium => _value('iconSizeMedium', 20);

  /// Snackbar shadow blur radius.
  double get snackbarShadowBlur => _value('snackbarShadowBlur', 7.5);
}

/// SLDS typography tokens.
class SldsTypographyTokens {
  /// Creates typography tokens.
  const SldsTypographyTokens({
    this.fontFamily = 'Google Sans',
    TextStyle? bottomNavigationLabel,
    TextStyle? fieldLabel,
    TextStyle? compactLabel,
    TextStyle? compactDescription,
    TextStyle? body1,
    TextStyle? body2,
    TextStyle? caption1,
    TextStyle? caption2,
    TextStyle? mobileCaption2,
    TextStyle? mobileDisplay1,
    TextStyle? display2,
    TextStyle? heading4,
    TextStyle? snackbarCaption,
    TextStyle? title1,
    TextStyle? heading1,
    TextStyle? heading2,
    TextStyle? desktopHeading2,
    TextStyle? heading3,
    TextStyle? desktopTitle1,
  }) : _bottomNavigationLabel = bottomNavigationLabel,
       _fieldLabel = fieldLabel,
       _compactLabel = compactLabel,
       _compactDescription = compactDescription,
       _body1 = body1,
       _body2 = body2,
       _caption1 = caption1,
       _caption2 = caption2,
       _mobileCaption2 = mobileCaption2,
       _mobileDisplay1 = mobileDisplay1,
       _display2 = display2,
       _heading4 = heading4,
       _snackbarCaption = snackbarCaption,
       _title1 = title1,
       _heading1 = heading1,
       _heading2 = heading2,
       _desktopHeading2 = desktopHeading2,
       _heading3 = heading3,
       _desktopTitle1 = desktopTitle1;

  /// Creates a copy with only the supplied typography values replaced.
  SldsTypographyTokens copyWith({
    String? fontFamily,
    TextStyle? bottomNavigationLabel,
    TextStyle? fieldLabel,
    TextStyle? compactLabel,
    TextStyle? compactDescription,
    TextStyle? body1,
    TextStyle? body2,
    TextStyle? caption1,
    TextStyle? caption2,
    TextStyle? mobileCaption2,
    TextStyle? mobileDisplay1,
    TextStyle? display2,
    TextStyle? heading4,
    TextStyle? snackbarCaption,
    TextStyle? title1,
    TextStyle? heading1,
    TextStyle? heading2,
    TextStyle? desktopHeading2,
    TextStyle? heading3,
    TextStyle? desktopTitle1,
  }) => SldsTypographyTokens(
    fontFamily: fontFamily ?? this.fontFamily,
    bottomNavigationLabel: bottomNavigationLabel ?? _bottomNavigationLabel,
    fieldLabel: fieldLabel ?? _fieldLabel,
    compactLabel: compactLabel ?? _compactLabel,
    compactDescription: compactDescription ?? _compactDescription,
    body1: body1 ?? _body1,
    body2: body2 ?? _body2,
    caption1: caption1 ?? _caption1,
    caption2: caption2 ?? _caption2,
    mobileCaption2: mobileCaption2 ?? _mobileCaption2,
    mobileDisplay1: mobileDisplay1 ?? _mobileDisplay1,
    display2: display2 ?? _display2,
    heading4: heading4 ?? _heading4,
    snackbarCaption: snackbarCaption ?? _snackbarCaption,
    title1: title1 ?? _title1,
    heading1: heading1 ?? _heading1,
    heading2: heading2 ?? _heading2,
    desktopHeading2: desktopHeading2 ?? _desktopHeading2,
    heading3: heading3 ?? _heading3,
    desktopTitle1: desktopTitle1 ?? _desktopTitle1,
  );

  /// Font stack primary family name.
  final String fontFamily;
  final TextStyle? _bottomNavigationLabel;
  final TextStyle? _fieldLabel;
  final TextStyle? _compactLabel;
  final TextStyle? _compactDescription;
  final TextStyle? _body1;
  final TextStyle? _body2;
  final TextStyle? _caption1;
  final TextStyle? _caption2;
  final TextStyle? _mobileCaption2;
  final TextStyle? _mobileDisplay1;
  final TextStyle? _display2;
  final TextStyle? _heading4;
  final TextStyle? _snackbarCaption;
  final TextStyle? _title1;
  final TextStyle? _heading1;
  final TextStyle? _heading2;
  final TextStyle? _desktopHeading2;
  final TextStyle? _heading3;
  final TextStyle? _desktopTitle1;

  /// Bottom Navigation label (Figma: 12px/18px regular, +0.2 tracking).
  TextStyle get bottomNavigationLabel =>
      _bottomNavigationLabel ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        height: 18 / 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
      );

  /// Input and selection-field label (Figma: 16px/20px regular).
  TextStyle get fieldLabel =>
      _fieldLabel ??
      body1.copyWith(
        fontSize: 16,
        height: 20 / 16,
        fontWeight: FontWeight.w400,
      );

  /// Compact component label (Figma: 16px/20px regular).
  TextStyle get compactLabel =>
      _compactLabel ??
      body1.copyWith(
        fontSize: 16,
        height: 20 / 16,
        fontWeight: FontWeight.w400,
      );

  /// Compact component description (Figma: 14px/22px regular).
  TextStyle get compactDescription =>
      _compactDescription ??
      body2.copyWith(
        fontSize: 14,
        height: 22 / 14,
        fontWeight: FontWeight.w400,
      );

  /// Mobile body 1 style.
  TextStyle get body1 =>
      _body1 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        height: 20 / 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  /// Desktop body 2 style.
  TextStyle get body2 =>
      _body2 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        height: 22 / 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  /// Caption style.
  TextStyle get caption1 =>
      _caption1 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  /// Desktop caption 2 style.
  TextStyle get caption2 =>
      _caption2 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        height: 16 / 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
      );

  /// Mobile caption 2 style.
  TextStyle get mobileCaption2 =>
      _mobileCaption2 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        height: 20 / 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  /// Mobile display 1 style used by numeric error-state codes.
  TextStyle get mobileDisplay1 =>
      _mobileDisplay1 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 36,
        height: 44 / 36,
        fontWeight: FontWeight.w500,
        letterSpacing: -2,
      );

  /// Desktop display 2 style.
  TextStyle get display2 =>
      _display2 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 44,
        height: 56 / 44,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      );

  /// Desktop heading 4 style.
  TextStyle get heading4 =>
      _heading4 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
      );

  /// Snackbar caption style.
  TextStyle get snackbarCaption =>
      _snackbarCaption ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        height: 18 / 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
      );

  /// Mobile title style.
  TextStyle get title1 =>
      _title1 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        height: 24 / 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      );

  /// Mobile heading 1 style.
  TextStyle get heading1 =>
      _heading1 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 26,
        height: 28 / 26,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      );

  /// Figma Time Picker title and clock-label style.
  TextStyle get timePickerLabel => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 26 / 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Figma Time Picker AM/PM selector style.
  TextStyle get timePickerPeriod => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 28 / 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  /// Figma small-button label style.
  TextStyle get buttonSmallLabel => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 24 / 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Mobile heading 2 style.
  TextStyle get heading2 =>
      _heading2 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      );

  /// Desktop heading 2 style.
  TextStyle get desktopHeading2 =>
      _desktopHeading2 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        height: 40 / 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      );

  /// Mobile heading 3 style.
  TextStyle get heading3 =>
      _heading3 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        height: 36 / 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  /// Desktop title style.
  TextStyle get desktopTitle1 =>
      _desktopTitle1 ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        height: 28 / 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      );

  /// Side panel title style from Figma `1165:2587`.
  TextStyle get sidePanelTitle => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    height: 32 / 20,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
  );

  /// Side panel content style from Figma `1165:2587`.
  TextStyle get sidePanelBody => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 26 / 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );
}

/// SLDS motion tokens.
class SldsMotionTokens {
  /// Creates motion tokens.
  const SldsMotionTokens({
    required this.reducedMotion,
    this.fastDuration = const Duration(milliseconds: 120),
    this.normalDuration = const Duration(milliseconds: 180),
  });

  /// Whether reduced motion is active.
  final bool reducedMotion;

  /// Fast transition before reduced-motion handling.
  final Duration fastDuration;

  /// Normal transition before reduced-motion handling.
  final Duration normalDuration;

  /// Creates a copy with only the supplied motion values replaced.
  SldsMotionTokens copyWith({
    bool? reducedMotion,
    Duration? fastDuration,
    Duration? normalDuration,
  }) => SldsMotionTokens(
    reducedMotion: reducedMotion ?? this.reducedMotion,
    fastDuration: fastDuration ?? this.fastDuration,
    normalDuration: normalDuration ?? this.normalDuration,
  );

  /// Fast transition duration.
  Duration get fast => reducedMotion ? Duration.zero : fastDuration;

  /// Normal transition duration.
  Duration get normal => reducedMotion ? Duration.zero : normalDuration;
}

/// Combined SLDS token set for a mode.
class SldsTokenSet {
  /// Creates a token set.
  const SldsTokenSet({
    required this.colors,
    this.dimensions = const SldsDimensionTokens(),
    this.typography = const SldsTypographyTokens(),
    required this.motion,
  });

  /// Color tokens.
  final SldsColorTokens colors;

  /// Dimension tokens.
  final SldsDimensionTokens dimensions;

  /// Typography tokens.
  final SldsTypographyTokens typography;

  /// Motion tokens.
  final SldsMotionTokens motion;

  /// Creates a token set with only the supplied categories replaced.
  SldsTokenSet copyWith({
    SldsColorTokens? colors,
    SldsDimensionTokens? dimensions,
    SldsTypographyTokens? typography,
    SldsMotionTokens? motion,
  }) => SldsTokenSet(
    colors: colors ?? this.colors,
    dimensions: dimensions ?? this.dimensions,
    typography: typography ?? this.typography,
    motion: motion ?? this.motion,
  );

  /// Light mode token set.
  factory SldsTokenSet.light({bool reducedMotion = false}) => SldsTokenSet(
    colors: SldsColorTokens.light(),
    motion: SldsMotionTokens(reducedMotion: reducedMotion),
  );

  /// Dark mode token set.
  factory SldsTokenSet.dark({bool reducedMotion = false}) => SldsTokenSet(
    colors: SldsColorTokens.dark(),
    motion: SldsMotionTokens(reducedMotion: reducedMotion),
  );

  /// High contrast token set.
  factory SldsTokenSet.highContrast({bool reducedMotion = false}) =>
      SldsTokenSet(
        colors: SldsColorTokens.highContrast(),
        motion: SldsMotionTokens(reducedMotion: reducedMotion),
      );
}
