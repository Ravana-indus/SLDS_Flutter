// Design tokens for the SLDS colour palette.
//
// Colours are stored as 32-bit ARGB ints rather than `Color` so this package
// stays free of Flutter and `dart:ui`, per the SLDS engineering guidelines
// (§2). `slds_components` materialises these into `Color`. Keeping them as
// ints is also what lets the WCAG contrast check in `test/` run as a plain
// Dart test with no widget binding.

/// The SLDS colour palette for a single theme.
///
/// Obtain one via [SldsRawColorTokens.light], [SldsRawColorTokens.dark] or
/// [SldsRawColorTokens.highContrast] rather than constructing it directly.
class SldsRawColorTokens {
  /// Creates a palette with every role specified.
  const SldsRawColorTokens({
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.surfacePage,
    required this.surfaceCard,
    required this.surfaceRaised,
    required this.surfaceSunken,
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
    required this.linkLabel,
    required this.linkLabelHover,
    required this.linkDestructiveLabel,
    required this.linkDestructiveLabelHover,
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
    required this.datePickerRangeHighlight,
    required this.serviceCardSelectedBackground,
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

  /// The light palette.
  ///
  /// PENDING DESIGN SIGN-OFF — some values here were adjusted by engineering
  /// to clear WCAG 2.2 AA, not taken from the Figma export. §9 makes the
  /// design team the source of truth for token values, so these are a
  /// proposal to be confirmed or replaced at the next token sync, not a
  /// unilateral change. Each was moved the minimum distance along its own
  /// hue that satisfies `test/contrast_test.dart`:
  ///
  ///   textTertiary       0xffbcbcbc -> 0xff6c6c6c  (1.77 -> 4.90 on page)
  ///   borderDefault      0xffbcbcbc -> 0xff8f8f8f  (1.90 -> 3.23 on card)
  ///   focusRing          0xffffd740 -> 0xff1a1a1a  (1.30 -> 16.25 on page)
  ///   focusRingError     0xfff47272 -> 0xffe86666  (2.80 -> 3.00 on page)
  ///   textSecondary      0xff898989 -> 0xff717171  (3.27 -> 4.56 on page)
  ///   inputHelper        0xff898989 -> 0xff717171  (3.50 -> 4.56 on card)
  ///   linkLabel          0xff898989 -> 0xff717171  (3.27 -> 4.56 on page)
  ///   inputIcon          0xffababab -> 0xff717171  (2.30 -> 4.56 on card)
  ///   success            0xff1faa63 -> 0xff00833c  (2.80 -> 4.55 on page)
  ///   badge *Text (x7)                             (2.42-4.35 -> >=4.50)
  ///
  /// focusRing is the significant one: the previous pale yellow measured
  /// 1.30:1 against the page, so the focus indicator was effectively
  /// invisible — WCAG 2.4.7 and 1.4.11 failing together. A near-black ring
  /// is the conventional fix and matches the guideline's own SldsFocus
  /// example, which notes 0xFF1A1A1A "meets 3:1 against neutral0 and
  /// gold500". The gold is retained as focusHalo, so the ring keeps its
  /// SLDS character while the contrast comes from the dark stroke.
  ///
  /// Two further intentional departures from Figma, kept deliberately:
  ///
  ///   surfaceCard         Figma Surface/Card is #EEEEEE, which is 1.08:1
  ///                       against Surface/Page #F7F7F7 — a card edge that
  ///                       is effectively invisible. Held at #FFFFFF. This
  ///                       is the background in 13 contrast pairings, so
  ///                       changing it moves most of the palette.
  ///   mastheadBackground  Figma Surface/Masthead is #222222; this uses the
  ///                       Sri Lanka flag maroon #8D153A. Not in the token
  ///                       spec at any tier (nearest is Maroon/700 #7A1240),
  ///                       so it is a brand decision that needs design to
  ///                       either ratify it or replace it.
  /// PENDING DESIGN SIGN-OFF — two roles new to the palette, not adjusted
  /// ones. `datePickerRangeHighlight` and `serviceCardSelectedBackground`
  /// were previously hardcoded inside the widgets, which is why the date
  /// picker, time picker and service card could not render in the
  /// high-contrast palette at all. The light values below are the literals
  /// those widgets already used, so light is unchanged; the dark and
  /// high-contrast values are engineering proposals with no Figma source.
  ///
  /// Each fill has two competing requirements — text on it must clear 4.5:1,
  /// and the fill itself must be distinguishable from the surface behind it,
  /// or the selection it signifies is invisible. Values chosen to maximise
  /// the second without dropping the first:
  ///
  ///                                  text on fill   fill vs surface
  ///   datePickerRangeHighlight
  ///     light  #FFF7D6 (unchanged)      14.79            1.08 on card
  ///     dark   #6B5600                   7.10            1.37 on card
  ///     hc     #FFC700                  13.42            1.56 on page
  ///   serviceCardSelectedBackground
  ///     light  #E3EDFF (unchanged)      13.50            1.18 on card
  ///     dark   #1E3A5F                  11.50            1.18 on card
  ///     hc     #A9C7FF                  12.30            1.71 on page
  ///
  /// The high-contrast range fill reuses buttonPrimaryBackground (#FFC700)
  /// rather than a paler yellow: in a palette whose page and card are both
  /// white, a #FFE680-class fill reads at 1.24 against the surface, which is
  /// too faint to mark a selected range for the users the palette exists for.
  ///
  /// Dark #24466F was rejected for the service card at 1.01 against the
  /// #444444 card — indistinguishable from an unselected one.
  factory SldsRawColorTokens.light() => const SldsRawColorTokens(
    textPrimary: 0xff222222,
    textSecondary: 0xff717171,
    textTertiary: 0xff6c6c6c,
    surfacePage: 0xfff7f7f7,
    surfaceCard: 0xffffffff,
    surfaceRaised: 0xffeeeeee,
    surfaceSunken: 0xffffffff,
    surfaceHover: 0xffeeeeee,
    surfacePrimary: 0xfffdfdfd,
    borderDefault: 0xff8f8f8f,
    borderDecorative: 0xffdddddd,
    cardBorder: 0xffdddddd,
    focusRing: 0xff1a1a1a,
    focusHalo: 0xffffe880,
    focusRingError: 0xffe86666,
    focusHaloError: 0xfff47272,
    shadowColor: 0xff000000,
    headerBackground: 0xfff7f7f7,
    mastheadBackground: 0xff8d153a,
    serviceCardIcon: 0xff6c3df5,
    summaryBoxAccent: 0xff0e9db0,
    tagApproved: 0xff059669,
    tagNotice: 0xfff57c00,
    headerBorder: 0xffdddddd,
    headerProgressTrack: 0xffffffff,
    buttonPrimaryBackground: 0xffffc700,
    buttonPrimaryLabel: 0xff222222,
    buttonPrimaryHover: 0xffe0ae00,
    buttonPrimaryPressed: 0xffe0ae00,
    buttonSecondaryBackground: 0xffffffff,
    buttonSecondaryLabel: 0xff222222,
    buttonSecondaryBorder: 0xffcdcdcd,
    buttonSecondaryHover: 0xffeeeeee,
    buttonSecondaryPressed: 0xffdddddd,
    buttonGhostLabel: 0xff222222,
    buttonGhostHover: 0xffeeeeee,
    buttonGhostPressed: 0xffffffff,
    linkLabel: 0xff717171,
    linkLabelHover: 0xff222222,
    linkDestructiveLabel: 0xffd32f2f,
    linkDestructiveLabelHover: 0xffb91c1c,
    buttonDestructiveBackground: 0xffd32f2f,
    buttonDestructiveLabel: 0xffffffff,
    buttonDestructiveHover: 0xffb91c1c,
    buttonDestructivePressed: 0xffb91c1c,
    disabledBackground: 0xffdddddd,
    disabledForeground: 0xffbcbcbc,
    disabledBorder: 0xffeeeeee,
    textStaticBlack: 0xff000000,
    notificationBadgeBackground: 0xffdc2626,
    bannerWarningTitle: 0xff503d00,
    badgeArchivedText: 0xffbcbcbc,
    listBackground: 0xfff7f7f7,
    listBackgroundHover: 0xffeeeeee,
    datePickerRangeHighlight: 0xfffff7d6,
    serviceCardSelectedBackground: 0xffe3edff,
    inputLabel: 0xff222222,
    inputPlaceholder: 0xffbcbcbc,
    inputHelper: 0xff717171,
    inputIcon: 0xff717171,
    inputBorderDefault: 0xffbcbcbc,
    inputBorderFocused: 0xffffc700,
    inputBorderError: 0xffd32f2f,
    inputBorderDisabled: 0xffeeeeee,
    error: 0xffd32f2f,
    success: 0xff00833c,
    warning: 0xffb38a00,
    info: 0xff0d6b7b,
    badgeSuccessText: 0xff007d36,
    badgeSuccessBackground: 0xffe0f2ec,
    badgePendingText: 0xff946b00,
    badgePendingBackground: 0xfffff8d6,
    badgeErrorText: 0xffd02c2c,
    badgeErrorBackground: 0xfffdecea,
    badgeInfoText: 0xff0d6b7b,
    badgeInfoBackground: 0xffe3edff,
    badgeNeutralText: 0xff6c6c6c,
    badgeNeutralBackground: 0xffeeeeee,
    badgeSubmittedText: 0xff007487,
    badgeSubmittedBackground: 0xffd0f0f5,
    badgeInReviewText: 0xff1a56d6,
    badgeInReviewBackground: 0xffe3edff,
    badgeApprovedText: 0xff007c4f,
    badgeApprovedBackground: 0xffe0f2ec,
    badgeEscalatedText: 0xffc04700,
    badgeEscalatedBackground: 0xfffef0e3,
    badgeOnHoldText: 0xff6747c7,
    badgeOnHoldBackground: 0xffede9ff,
    tooltipBackground: 0xff222222,
    tooltipText: 0xffffffff,
  );

  /// The dark palette.
  ///
  /// The dark ramp now follows Figma's pure neutrals (Neutral/800 #444444 as
  /// the card, #565656 raised, #676767/#ABABAB borders) rather than the
  /// blue-grey ramp this previously used, which was never in the spec.
  ///
  /// PENDING DESIGN SIGN-OFF, as for the light palette above. Two Figma dark
  /// values are NOT adopted because they fail WCAG AA against Figma's own
  /// dark surfaces — do not "correct" these back to the spec without also
  /// changing the surface they sit on:
  ///
  ///   textTertiary  Figma Text/Tertiary #898989 is 2.78:1 on the #444444
  ///                 card. Held at #BCBCBC (5.13:1), the same value Figma
  ///                 gives Text/Secondary.
  ///   error         Figma Feedback/Error #D32F2F is 3.79:1 on the #111111
  ///                 page, short of the 4.5:1 floor for body text. Held at
  ///                 #F47272 (6.74:1), which is Figma's own Red/300 and the
  ///                 value its Border/Error dark already uses.
  ///   focusRing     0xffffd740 -> 0xffffffff  (invisible -> 18.88 on page)
  ///   linkDestructiveLabel
  ///                 Figma Feedback/Error Text #F47272 clears the page
  ///                 (6.74:1) but is only 3.48:1 on the #444444 card, and an
  ///                 inline link sits in body copy on either. Held at #FCA5A5
  ///                 (9.95 page / 5.13 card).
  ///   linkDestructiveLabelHover
  ///                 Figma Feedback/Error Hover #B91C1C is 2.92:1 on the
  ///                 #111111 page — a light-theme value reused unchanged, so
  ///                 the link would fall below AA exactly when hovered. Held
  ///                 at #FFC9C9 (12.99:1); on a dark surface hover has to
  ///                 lighten, not darken.
  factory SldsRawColorTokens.dark() => const SldsRawColorTokens(
    textPrimary: 0xffffffff,
    textSecondary: 0xffbcbcbc,
    textTertiary: 0xffbcbcbc,
    surfacePage: 0xff111111,
    surfaceCard: 0xff444444,
    surfaceRaised: 0xff565656,
    surfaceSunken: 0xff444444,
    surfaceHover: 0xff444444,
    surfacePrimary: 0xff444444,
    borderDefault: 0xffababab,
    borderDecorative: 0xff676767,
    cardBorder: 0xff565656,
    focusRing: 0xffffffff,
    focusHalo: 0xffffe880,
    focusRingError: 0xfff47272,
    focusHaloError: 0xfff47272,
    shadowColor: 0xff000000,
    headerBackground: 0xff444444,
    mastheadBackground: 0xff8d153a,
    serviceCardIcon: 0xffa78bfa,
    summaryBoxAccent: 0xff7dd8e8,
    tagApproved: 0xff5dc896,
    tagNotice: 0xffffe880,
    headerBorder: 0xff565656,
    headerProgressTrack: 0xff111111,
    buttonPrimaryBackground: 0xffffc700,
    buttonPrimaryLabel: 0xff222222,
    buttonPrimaryHover: 0xffffd740,
    buttonPrimaryPressed: 0xffffd740,
    buttonSecondaryBackground: 0xff444444,
    buttonSecondaryLabel: 0xffffffff,
    buttonSecondaryBorder: 0xff565656,
    buttonSecondaryHover: 0xff444444,
    buttonSecondaryPressed: 0xff222222,
    buttonGhostLabel: 0xffffffff,
    buttonGhostHover: 0xff444444,
    buttonGhostPressed: 0xff222222,
    linkLabel: 0xffbcbcbc,
    linkLabelHover: 0xffffffff,
    linkDestructiveLabel: 0xfffca5a5,
    // Brighter, not darker. Figma pairs its rest colour with a #b91c1c
    // hover, but that is a light-theme value: on the dark page it measures
    // 2.92:1, so the hover state would drop below AA precisely when the user
    // is pointing at it. On a dark surface the hover has to move away from
    // the background, not toward it.
    linkDestructiveLabelHover: 0xffffc9c9,
    buttonDestructiveBackground: 0xffd32f2f,
    buttonDestructiveLabel: 0xffffffff,
    buttonDestructiveHover: 0xffb91c1c,
    buttonDestructivePressed: 0xffb91c1c,
    disabledBackground: 0xff444444,
    disabledForeground: 0xff898989,
    disabledBorder: 0xff898989,
    textStaticBlack: 0xff000000,
    notificationBadgeBackground: 0xffdc2626,
    bannerWarningTitle: 0xffffe880,
    badgeArchivedText: 0xff898989,
    listBackground: 0xff111111,
    listBackgroundHover: 0xff444444,
    datePickerRangeHighlight: 0xff6b5600,
    serviceCardSelectedBackground: 0xff1e3a5f,
    inputLabel: 0xffffffff,
    inputPlaceholder: 0xff898989,
    inputHelper: 0xffbcbcbc,
    inputIcon: 0xffbcbcbc,
    inputBorderDefault: 0xffababab,
    inputBorderFocused: 0xffe0ae00,
    inputBorderError: 0xfff47272,
    inputBorderDisabled: 0xff898989,
    error: 0xfff47272,
    success: 0xff5dc896,
    warning: 0xffffe880,
    info: 0xff7dd8e8,
    badgeSuccessText: 0xff5dc896,
    badgeSuccessBackground: 0xff062b1a,
    badgePendingText: 0xffffe880,
    badgePendingBackground: 0xff2e2200,
    badgeErrorText: 0xfff47272,
    badgeErrorBackground: 0xff330d0d,
    badgeInfoText: 0xff93c5fd,
    badgeInfoBackground: 0xff0a1733,
    badgeNeutralText: 0xffbcbcbc,
    badgeNeutralBackground: 0xff2e1800,
    badgeSubmittedText: 0xff67d2e1,
    badgeSubmittedBackground: 0xff0a1733,
    badgeInReviewText: 0xff93c5fd,
    badgeInReviewBackground: 0xff0a1733,
    badgeApprovedText: 0xff34d399,
    badgeApprovedBackground: 0xff064e3b,
    badgeEscalatedText: 0xffffd01a,
    badgeEscalatedBackground: 0xff2e1800,
    badgeOnHoldText: 0xffa78bfa,
    badgeOnHoldBackground: 0xff1a0f38,
    tooltipBackground: 0xffffffff,
    tooltipText: 0xff111111,
  );

  /// The high-contrast palette.
  factory SldsRawColorTokens.highContrast() => const SldsRawColorTokens(
    textPrimary: 0xff000000,
    textSecondary: 0xff000000,
    textTertiary: 0xff000000,
    surfacePage: 0xffffffff,
    surfaceCard: 0xffffffff,
    surfaceRaised: 0xffe8e8e8,
    surfaceSunken: 0xffffffff,
    surfaceHover: 0xffe2e2e2,
    surfacePrimary: 0xffffffff,
    borderDefault: 0xff000000,
    borderDecorative: 0xff000000,
    cardBorder: 0xff000000,
    focusRing: 0xff000000,
    focusHalo: 0xff000000,
    focusRingError: 0xff000000,
    focusHaloError: 0xff000000,
    shadowColor: 0xff000000,
    headerBackground: 0xffffffff,
    mastheadBackground: 0xff000000,
    serviceCardIcon: 0xff000000,
    summaryBoxAccent: 0xff000000,
    tagApproved: 0xff000000,
    tagNotice: 0xff000000,
    headerBorder: 0xff000000,
    headerProgressTrack: 0xffffffff,
    buttonPrimaryBackground: 0xffffc700,
    buttonPrimaryLabel: 0xff000000,
    buttonPrimaryHover: 0xffe0ae00,
    buttonPrimaryPressed: 0xffb38a00,
    buttonSecondaryBackground: 0xffffffff,
    buttonSecondaryLabel: 0xff000000,
    buttonSecondaryBorder: 0xff000000,
    buttonSecondaryHover: 0xffe2e2e2,
    buttonSecondaryPressed: 0xffd5d5d5,
    buttonGhostLabel: 0xff000000,
    buttonGhostHover: 0xffe2e2e2,
    buttonGhostPressed: 0xffd5d5d5,
    linkLabel: 0xff000000,
    linkLabelHover: 0xff000000,
    linkDestructiveLabel: 0xffb91c1c,
    linkDestructiveLabelHover: 0xff7f1d1d,
    buttonDestructiveBackground: 0xffb91c1c,
    buttonDestructiveLabel: 0xffffffff,
    buttonDestructiveHover: 0xff991b1b,
    buttonDestructivePressed: 0xff7f1d1d,
    disabledBackground: 0xffe6e6e6,
    disabledForeground: 0xff787878,
    disabledBorder: 0xff787878,
    textStaticBlack: 0xff000000,
    notificationBadgeBackground: 0xffdc2626,
    bannerWarningTitle: 0xff503d00,
    badgeArchivedText: 0xff565656,
    listBackground: 0xffffffff,
    listBackgroundHover: 0xffe8e8e8,
    datePickerRangeHighlight: 0xffffc700,
    serviceCardSelectedBackground: 0xffa9c7ff,
    inputLabel: 0xff000000,
    inputPlaceholder: 0xff787878,
    inputHelper: 0xff000000,
    inputIcon: 0xff000000,
    inputBorderDefault: 0xff000000,
    inputBorderFocused: 0xff000000,
    inputBorderError: 0xff000000,
    inputBorderDisabled: 0xff787878,
    error: 0xffb91c1c,
    success: 0xff065f46,
    warning: 0xff503d00,
    info: 0xff0f4855,
    badgeSuccessText: 0xff065f46,
    badgeSuccessBackground: 0xffffffff,
    badgePendingText: 0xff503d00,
    badgePendingBackground: 0xffffffff,
    badgeErrorText: 0xffb91c1c,
    badgeErrorBackground: 0xffffffff,
    badgeInfoText: 0xff0f4855,
    badgeInfoBackground: 0xffffffff,
    badgeNeutralText: 0xff565656,
    badgeNeutralBackground: 0xffffffff,
    badgeSubmittedText: 0xff0f4855,
    badgeSubmittedBackground: 0xffffffff,
    badgeInReviewText: 0xff1e3a8a,
    badgeInReviewBackground: 0xffffffff,
    badgeApprovedText: 0xff065f46,
    badgeApprovedBackground: 0xffffffff,
    badgeEscalatedText: 0xff7c2d12,
    badgeEscalatedBackground: 0xffffffff,
    badgeOnHoldText: 0xff4c1d95,
    badgeOnHoldBackground: 0xffffffff,
    tooltipBackground: 0xff000000,
    tooltipText: 0xffffffff,
  );

  /// Primary text.
  final int textPrimary;

  /// Secondary text.
  final int textSecondary;

  /// Tertiary text.
  final int textTertiary;

  /// Root page surface.
  final int surfacePage;

  /// Card and overlay surface.
  final int surfaceCard;

  /// hover). Figma calls this out as distinct from the white card surface.
  final int surfaceRaised;

  /// Figma Surface/Sunken — the ground a Mobile Menu Block list sits on.
  final int surfaceSunken;

  /// Hover surface.
  final int surfaceHover;

  /// Control fill surface.
  final int surfacePrimary;

  /// Default border.
  final int borderDefault;

  /// Decorative border.
  final int borderDecorative;

  /// decorative border used elsewhere.
  final int cardBorder;

  /// Focus ring.
  final int focusRing;

  /// Focus halo.
  final int focusHalo;

  /// Figma Focus/Error ring — destructive Button/Icon Button focus outline.
  final int focusRingError;

  /// Figma Focus/Error halo — destructive Button/Icon Button focus glow.
  final int focusHaloError;

  /// elevation alpha rather than tinting from the text colour.
  final int shadowColor;

  /// Top navigation surface.
  final int headerBackground;

  /// Government masthead surface.
  final int mastheadBackground;

  /// Leading icon colour for a Service Card.
  final int serviceCardIcon;

  /// Summary Box outline, icon, and title colour.
  final int summaryBoxAccent;

  /// Approved Tag fill from Figma.
  final int tagApproved;

  /// Notice Tag fill from Figma.
  final int tagNotice;

  /// Top navigation divider.
  final int headerBorder;

  /// Incomplete top navigation progress segment.
  final int headerProgressTrack;

  /// Primary button background.
  final int buttonPrimaryBackground;

  /// Primary button label.
  final int buttonPrimaryLabel;

  /// Primary button hover background.
  final int buttonPrimaryHover;

  /// Primary button pressed background.
  final int buttonPrimaryPressed;

  /// Secondary button background.
  final int buttonSecondaryBackground;

  /// Secondary button label.
  final int buttonSecondaryLabel;

  /// Secondary button border.
  final int buttonSecondaryBorder;

  /// Secondary button hover background.
  final int buttonSecondaryHover;

  /// Secondary button pressed background.
  final int buttonSecondaryPressed;

  /// Ghost button label.
  final int buttonGhostLabel;

  /// Ghost button hover background.
  final int buttonGhostHover;

  /// Ghost button pressed background.
  final int buttonGhostPressed;

  /// Figma Text/Secondary — the resting colour of an inline text link.
  final int linkLabel;

  /// Figma Text/Primary — an inline link darkens on hover.
  final int linkLabelHover;

  /// Figma Feedback/Error Text — resting colour of a destructive link.
  final int linkDestructiveLabel;

  /// Figma Feedback/Error Hover — a destructive link darkens on hover.
  final int linkDestructiveLabelHover;

  /// Destructive button background.
  final int buttonDestructiveBackground;

  /// Destructive button label.
  final int buttonDestructiveLabel;

  /// Destructive button hover background.
  final int buttonDestructiveHover;

  /// Destructive button pressed background.
  final int buttonDestructivePressed;

  /// Disabled fill.
  final int disabledBackground;

  /// Disabled foreground.
  final int disabledForeground;

  /// Figma Button/Disabled/Border — lighter than [disabledBackground].
  final int disabledBorder;

  /// Figma Text/Static Black — label colour on amber/gold fills.
  final int textStaticBlack;

  /// Figma Red/500 — the small notification-count badge on Bottom Tab Bar.
  final int notificationBadgeBackground;

  /// Figma Banner/Warning/Title — darker than the warning icon/border.
  final int bannerWarningTitle;

  /// Figma Badge/Archived/Text — lighter than the shared Neutral/Draft text.
  final int badgeArchivedText;

  /// Figma List/Background — Service Card and List Item resting fill.
  final int listBackground;

  /// Figma List/Background/Hover.
  final int listBackgroundHover;

  /// Fill behind the in-between cells of a date or time range selection.
  ///
  /// Read by `SldsDatePicker` and `SldsTimePicker`. Text sits directly on this
  /// fill, so it is contrast-checked against the palette's primary text rather
  /// than treated as decorative.
  final int datePickerRangeHighlight;

  /// Resting fill of a service card in its selected state.
  ///
  /// Distinct from [listBackgroundHover]: hover is transient feedback, whereas
  /// selection persists and must stay legible in every palette.
  final int serviceCardSelectedBackground;

  /// Input label.
  final int inputLabel;

  /// Input placeholder.
  final int inputPlaceholder;

  /// Input helper text.
  final int inputHelper;

  /// Input leading/trailing icon.
  final int inputIcon;

  /// Input default border.
  final int inputBorderDefault;

  /// Input focus border.
  final int inputBorderFocused;

  /// Input error border.
  final int inputBorderError;

  /// Input disabled border.
  final int inputBorderDisabled;

  /// Error color.
  final int error;

  /// Success color.
  final int success;

  /// Warning color.
  final int warning;

  /// Info color.
  final int info;

  /// Success badge text.
  final int badgeSuccessText;

  /// Success badge background.
  final int badgeSuccessBackground;

  /// Pending badge text.
  final int badgePendingText;

  /// Pending badge background.
  final int badgePendingBackground;

  /// Error badge text.
  final int badgeErrorText;

  /// Error badge background.
  final int badgeErrorBackground;

  /// Info badge text.
  final int badgeInfoText;

  /// Info badge background.
  final int badgeInfoBackground;

  /// Neutral badge text.
  final int badgeNeutralText;

  /// Neutral badge background.
  final int badgeNeutralBackground;

  /// Submitted badge text.
  final int badgeSubmittedText;

  /// Submitted badge background.
  final int badgeSubmittedBackground;

  /// In review badge text.
  final int badgeInReviewText;

  /// In review badge background.
  final int badgeInReviewBackground;

  /// Approved badge text.
  final int badgeApprovedText;

  /// Approved badge background.
  final int badgeApprovedBackground;

  /// Escalated badge text.
  final int badgeEscalatedText;

  /// Escalated badge background.
  final int badgeEscalatedBackground;

  /// On hold badge text.
  final int badgeOnHoldText;

  /// On hold badge background.
  final int badgeOnHoldBackground;

  /// Tooltip surface.
  final int tooltipBackground;

  /// Tooltip text.
  final int tooltipText;

  /// Returns a copy with the given roles replaced.
  SldsRawColorTokens copyWith({
    int? textPrimary,
    int? textSecondary,
    int? textTertiary,
    int? surfacePage,
    int? surfaceCard,
    int? surfaceRaised,
    int? surfaceSunken,
    int? surfaceHover,
    int? surfacePrimary,
    int? borderDefault,
    int? borderDecorative,
    int? cardBorder,
    int? focusRing,
    int? focusHalo,
    int? focusRingError,
    int? focusHaloError,
    int? shadowColor,
    int? headerBackground,
    int? mastheadBackground,
    int? serviceCardIcon,
    int? summaryBoxAccent,
    int? tagApproved,
    int? tagNotice,
    int? headerBorder,
    int? headerProgressTrack,
    int? buttonPrimaryBackground,
    int? buttonPrimaryLabel,
    int? buttonPrimaryHover,
    int? buttonPrimaryPressed,
    int? buttonSecondaryBackground,
    int? buttonSecondaryLabel,
    int? buttonSecondaryBorder,
    int? buttonSecondaryHover,
    int? buttonSecondaryPressed,
    int? buttonGhostLabel,
    int? buttonGhostHover,
    int? buttonGhostPressed,
    int? linkLabel,
    int? linkLabelHover,
    int? linkDestructiveLabel,
    int? linkDestructiveLabelHover,
    int? buttonDestructiveBackground,
    int? buttonDestructiveLabel,
    int? buttonDestructiveHover,
    int? buttonDestructivePressed,
    int? disabledBackground,
    int? disabledForeground,
    int? disabledBorder,
    int? textStaticBlack,
    int? notificationBadgeBackground,
    int? bannerWarningTitle,
    int? badgeArchivedText,
    int? listBackground,
    int? listBackgroundHover,
    int? datePickerRangeHighlight,
    int? serviceCardSelectedBackground,
    int? inputLabel,
    int? inputPlaceholder,
    int? inputHelper,
    int? inputIcon,
    int? inputBorderDefault,
    int? inputBorderFocused,
    int? inputBorderError,
    int? inputBorderDisabled,
    int? error,
    int? success,
    int? warning,
    int? info,
    int? badgeSuccessText,
    int? badgeSuccessBackground,
    int? badgePendingText,
    int? badgePendingBackground,
    int? badgeErrorText,
    int? badgeErrorBackground,
    int? badgeInfoText,
    int? badgeInfoBackground,
    int? badgeNeutralText,
    int? badgeNeutralBackground,
    int? badgeSubmittedText,
    int? badgeSubmittedBackground,
    int? badgeInReviewText,
    int? badgeInReviewBackground,
    int? badgeApprovedText,
    int? badgeApprovedBackground,
    int? badgeEscalatedText,
    int? badgeEscalatedBackground,
    int? badgeOnHoldText,
    int? badgeOnHoldBackground,
    int? tooltipBackground,
    int? tooltipText,
  }) {
    return SldsRawColorTokens(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      surfacePage: surfacePage ?? this.surfacePage,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
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
      buttonSecondaryBorder:
          buttonSecondaryBorder ?? this.buttonSecondaryBorder,
      buttonSecondaryHover: buttonSecondaryHover ?? this.buttonSecondaryHover,
      buttonSecondaryPressed:
          buttonSecondaryPressed ?? this.buttonSecondaryPressed,
      buttonGhostLabel: buttonGhostLabel ?? this.buttonGhostLabel,
      buttonGhostHover: buttonGhostHover ?? this.buttonGhostHover,
      buttonGhostPressed: buttonGhostPressed ?? this.buttonGhostPressed,
      linkLabel: linkLabel ?? this.linkLabel,
      linkLabelHover: linkLabelHover ?? this.linkLabelHover,
      linkDestructiveLabel: linkDestructiveLabel ?? this.linkDestructiveLabel,
      linkDestructiveLabelHover:
          linkDestructiveLabelHover ?? this.linkDestructiveLabelHover,
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
      datePickerRangeHighlight:
          datePickerRangeHighlight ?? this.datePickerRangeHighlight,
      serviceCardSelectedBackground:
          serviceCardSelectedBackground ?? this.serviceCardSelectedBackground,
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
      badgeOnHoldBackground:
          badgeOnHoldBackground ?? this.badgeOnHoldBackground,
      tooltipBackground: tooltipBackground ?? this.tooltipBackground,
      tooltipText: tooltipText ?? this.tooltipText,
    );
  }

  /// Linearly interpolates between two palettes.
  ///
  /// Interpolation is per-channel on the packed ARGB values.
  static SldsRawColorTokens lerp(
    SldsRawColorTokens a,
    SldsRawColorTokens b,
    double t,
  ) {
    return SldsRawColorTokens(
      textPrimary: lerpArgb(a.textPrimary, b.textPrimary, t),
      textSecondary: lerpArgb(a.textSecondary, b.textSecondary, t),
      textTertiary: lerpArgb(a.textTertiary, b.textTertiary, t),
      surfacePage: lerpArgb(a.surfacePage, b.surfacePage, t),
      surfaceCard: lerpArgb(a.surfaceCard, b.surfaceCard, t),
      surfaceRaised: lerpArgb(a.surfaceRaised, b.surfaceRaised, t),
      surfaceSunken: lerpArgb(a.surfaceSunken, b.surfaceSunken, t),
      surfaceHover: lerpArgb(a.surfaceHover, b.surfaceHover, t),
      surfacePrimary: lerpArgb(a.surfacePrimary, b.surfacePrimary, t),
      borderDefault: lerpArgb(a.borderDefault, b.borderDefault, t),
      borderDecorative: lerpArgb(a.borderDecorative, b.borderDecorative, t),
      cardBorder: lerpArgb(a.cardBorder, b.cardBorder, t),
      focusRing: lerpArgb(a.focusRing, b.focusRing, t),
      focusHalo: lerpArgb(a.focusHalo, b.focusHalo, t),
      focusRingError: lerpArgb(a.focusRingError, b.focusRingError, t),
      focusHaloError: lerpArgb(a.focusHaloError, b.focusHaloError, t),
      shadowColor: lerpArgb(a.shadowColor, b.shadowColor, t),
      headerBackground: lerpArgb(a.headerBackground, b.headerBackground, t),
      mastheadBackground: lerpArgb(
        a.mastheadBackground,
        b.mastheadBackground,
        t,
      ),
      serviceCardIcon: lerpArgb(a.serviceCardIcon, b.serviceCardIcon, t),
      summaryBoxAccent: lerpArgb(a.summaryBoxAccent, b.summaryBoxAccent, t),
      tagApproved: lerpArgb(a.tagApproved, b.tagApproved, t),
      tagNotice: lerpArgb(a.tagNotice, b.tagNotice, t),
      headerBorder: lerpArgb(a.headerBorder, b.headerBorder, t),
      headerProgressTrack: lerpArgb(
        a.headerProgressTrack,
        b.headerProgressTrack,
        t,
      ),
      buttonPrimaryBackground: lerpArgb(
        a.buttonPrimaryBackground,
        b.buttonPrimaryBackground,
        t,
      ),
      buttonPrimaryLabel: lerpArgb(
        a.buttonPrimaryLabel,
        b.buttonPrimaryLabel,
        t,
      ),
      buttonPrimaryHover: lerpArgb(
        a.buttonPrimaryHover,
        b.buttonPrimaryHover,
        t,
      ),
      buttonPrimaryPressed: lerpArgb(
        a.buttonPrimaryPressed,
        b.buttonPrimaryPressed,
        t,
      ),
      buttonSecondaryBackground: lerpArgb(
        a.buttonSecondaryBackground,
        b.buttonSecondaryBackground,
        t,
      ),
      buttonSecondaryLabel: lerpArgb(
        a.buttonSecondaryLabel,
        b.buttonSecondaryLabel,
        t,
      ),
      buttonSecondaryBorder: lerpArgb(
        a.buttonSecondaryBorder,
        b.buttonSecondaryBorder,
        t,
      ),
      buttonSecondaryHover: lerpArgb(
        a.buttonSecondaryHover,
        b.buttonSecondaryHover,
        t,
      ),
      buttonSecondaryPressed: lerpArgb(
        a.buttonSecondaryPressed,
        b.buttonSecondaryPressed,
        t,
      ),
      buttonGhostLabel: lerpArgb(a.buttonGhostLabel, b.buttonGhostLabel, t),
      buttonGhostHover: lerpArgb(a.buttonGhostHover, b.buttonGhostHover, t),
      linkLabel: lerpArgb(a.linkLabel, b.linkLabel, t),
      linkLabelHover: lerpArgb(a.linkLabelHover, b.linkLabelHover, t),
      linkDestructiveLabel: lerpArgb(
        a.linkDestructiveLabel,
        b.linkDestructiveLabel,
        t,
      ),
      linkDestructiveLabelHover: lerpArgb(
        a.linkDestructiveLabelHover,
        b.linkDestructiveLabelHover,
        t,
      ),
      buttonGhostPressed: lerpArgb(
        a.buttonGhostPressed,
        b.buttonGhostPressed,
        t,
      ),
      buttonDestructiveBackground: lerpArgb(
        a.buttonDestructiveBackground,
        b.buttonDestructiveBackground,
        t,
      ),
      buttonDestructiveLabel: lerpArgb(
        a.buttonDestructiveLabel,
        b.buttonDestructiveLabel,
        t,
      ),
      buttonDestructiveHover: lerpArgb(
        a.buttonDestructiveHover,
        b.buttonDestructiveHover,
        t,
      ),
      buttonDestructivePressed: lerpArgb(
        a.buttonDestructivePressed,
        b.buttonDestructivePressed,
        t,
      ),
      disabledBackground: lerpArgb(
        a.disabledBackground,
        b.disabledBackground,
        t,
      ),
      disabledForeground: lerpArgb(
        a.disabledForeground,
        b.disabledForeground,
        t,
      ),
      disabledBorder: lerpArgb(a.disabledBorder, b.disabledBorder, t),
      textStaticBlack: lerpArgb(a.textStaticBlack, b.textStaticBlack, t),
      notificationBadgeBackground: lerpArgb(
        a.notificationBadgeBackground,
        b.notificationBadgeBackground,
        t,
      ),
      bannerWarningTitle: lerpArgb(
        a.bannerWarningTitle,
        b.bannerWarningTitle,
        t,
      ),
      badgeArchivedText: lerpArgb(a.badgeArchivedText, b.badgeArchivedText, t),
      listBackground: lerpArgb(a.listBackground, b.listBackground, t),
      listBackgroundHover: lerpArgb(
        a.listBackgroundHover,
        b.listBackgroundHover,
        t,
      ),
      datePickerRangeHighlight: lerpArgb(
        a.datePickerRangeHighlight,
        b.datePickerRangeHighlight,
        t,
      ),
      serviceCardSelectedBackground: lerpArgb(
        a.serviceCardSelectedBackground,
        b.serviceCardSelectedBackground,
        t,
      ),
      inputLabel: lerpArgb(a.inputLabel, b.inputLabel, t),
      inputPlaceholder: lerpArgb(a.inputPlaceholder, b.inputPlaceholder, t),
      inputHelper: lerpArgb(a.inputHelper, b.inputHelper, t),
      inputIcon: lerpArgb(a.inputIcon, b.inputIcon, t),
      inputBorderDefault: lerpArgb(
        a.inputBorderDefault,
        b.inputBorderDefault,
        t,
      ),
      inputBorderFocused: lerpArgb(
        a.inputBorderFocused,
        b.inputBorderFocused,
        t,
      ),
      inputBorderError: lerpArgb(a.inputBorderError, b.inputBorderError, t),
      inputBorderDisabled: lerpArgb(
        a.inputBorderDisabled,
        b.inputBorderDisabled,
        t,
      ),
      error: lerpArgb(a.error, b.error, t),
      success: lerpArgb(a.success, b.success, t),
      warning: lerpArgb(a.warning, b.warning, t),
      info: lerpArgb(a.info, b.info, t),
      badgeSuccessText: lerpArgb(a.badgeSuccessText, b.badgeSuccessText, t),
      badgeSuccessBackground: lerpArgb(
        a.badgeSuccessBackground,
        b.badgeSuccessBackground,
        t,
      ),
      badgePendingText: lerpArgb(a.badgePendingText, b.badgePendingText, t),
      badgePendingBackground: lerpArgb(
        a.badgePendingBackground,
        b.badgePendingBackground,
        t,
      ),
      badgeErrorText: lerpArgb(a.badgeErrorText, b.badgeErrorText, t),
      badgeErrorBackground: lerpArgb(
        a.badgeErrorBackground,
        b.badgeErrorBackground,
        t,
      ),
      badgeInfoText: lerpArgb(a.badgeInfoText, b.badgeInfoText, t),
      badgeInfoBackground: lerpArgb(
        a.badgeInfoBackground,
        b.badgeInfoBackground,
        t,
      ),
      badgeNeutralText: lerpArgb(a.badgeNeutralText, b.badgeNeutralText, t),
      badgeNeutralBackground: lerpArgb(
        a.badgeNeutralBackground,
        b.badgeNeutralBackground,
        t,
      ),
      badgeSubmittedText: lerpArgb(
        a.badgeSubmittedText,
        b.badgeSubmittedText,
        t,
      ),
      badgeSubmittedBackground: lerpArgb(
        a.badgeSubmittedBackground,
        b.badgeSubmittedBackground,
        t,
      ),
      badgeInReviewText: lerpArgb(a.badgeInReviewText, b.badgeInReviewText, t),
      badgeInReviewBackground: lerpArgb(
        a.badgeInReviewBackground,
        b.badgeInReviewBackground,
        t,
      ),
      badgeApprovedText: lerpArgb(a.badgeApprovedText, b.badgeApprovedText, t),
      badgeApprovedBackground: lerpArgb(
        a.badgeApprovedBackground,
        b.badgeApprovedBackground,
        t,
      ),
      badgeEscalatedText: lerpArgb(
        a.badgeEscalatedText,
        b.badgeEscalatedText,
        t,
      ),
      badgeEscalatedBackground: lerpArgb(
        a.badgeEscalatedBackground,
        b.badgeEscalatedBackground,
        t,
      ),
      badgeOnHoldText: lerpArgb(a.badgeOnHoldText, b.badgeOnHoldText, t),
      badgeOnHoldBackground: lerpArgb(
        a.badgeOnHoldBackground,
        b.badgeOnHoldBackground,
        t,
      ),
      tooltipBackground: lerpArgb(a.tooltipBackground, b.tooltipBackground, t),
      tooltipText: lerpArgb(a.tooltipText, b.tooltipText, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SldsRawColorTokens &&
        other.textPrimary == textPrimary &&
        other.textSecondary == textSecondary &&
        other.textTertiary == textTertiary &&
        other.surfacePage == surfacePage &&
        other.surfaceCard == surfaceCard &&
        other.surfaceRaised == surfaceRaised &&
        other.surfaceSunken == surfaceSunken &&
        other.surfaceHover == surfaceHover &&
        other.surfacePrimary == surfacePrimary &&
        other.borderDefault == borderDefault &&
        other.borderDecorative == borderDecorative &&
        other.cardBorder == cardBorder &&
        other.focusRing == focusRing &&
        other.focusHalo == focusHalo &&
        other.focusRingError == focusRingError &&
        other.focusHaloError == focusHaloError &&
        other.shadowColor == shadowColor &&
        other.headerBackground == headerBackground &&
        other.mastheadBackground == mastheadBackground &&
        other.serviceCardIcon == serviceCardIcon &&
        other.summaryBoxAccent == summaryBoxAccent &&
        other.tagApproved == tagApproved &&
        other.tagNotice == tagNotice &&
        other.headerBorder == headerBorder &&
        other.headerProgressTrack == headerProgressTrack &&
        other.buttonPrimaryBackground == buttonPrimaryBackground &&
        other.buttonPrimaryLabel == buttonPrimaryLabel &&
        other.buttonPrimaryHover == buttonPrimaryHover &&
        other.buttonPrimaryPressed == buttonPrimaryPressed &&
        other.buttonSecondaryBackground == buttonSecondaryBackground &&
        other.buttonSecondaryLabel == buttonSecondaryLabel &&
        other.buttonSecondaryBorder == buttonSecondaryBorder &&
        other.buttonSecondaryHover == buttonSecondaryHover &&
        other.buttonSecondaryPressed == buttonSecondaryPressed &&
        other.buttonGhostLabel == buttonGhostLabel &&
        other.buttonGhostHover == buttonGhostHover &&
        other.buttonGhostPressed == buttonGhostPressed &&
        other.linkLabel == linkLabel &&
        other.linkLabelHover == linkLabelHover &&
        other.linkDestructiveLabel == linkDestructiveLabel &&
        other.linkDestructiveLabelHover == linkDestructiveLabelHover &&
        other.buttonDestructiveBackground == buttonDestructiveBackground &&
        other.buttonDestructiveLabel == buttonDestructiveLabel &&
        other.buttonDestructiveHover == buttonDestructiveHover &&
        other.buttonDestructivePressed == buttonDestructivePressed &&
        other.disabledBackground == disabledBackground &&
        other.disabledForeground == disabledForeground &&
        other.disabledBorder == disabledBorder &&
        other.textStaticBlack == textStaticBlack &&
        other.notificationBadgeBackground == notificationBadgeBackground &&
        other.bannerWarningTitle == bannerWarningTitle &&
        other.badgeArchivedText == badgeArchivedText &&
        other.listBackground == listBackground &&
        other.listBackgroundHover == listBackgroundHover &&
        other.datePickerRangeHighlight == datePickerRangeHighlight &&
        other.serviceCardSelectedBackground == serviceCardSelectedBackground &&
        other.inputLabel == inputLabel &&
        other.inputPlaceholder == inputPlaceholder &&
        other.inputHelper == inputHelper &&
        other.inputIcon == inputIcon &&
        other.inputBorderDefault == inputBorderDefault &&
        other.inputBorderFocused == inputBorderFocused &&
        other.inputBorderError == inputBorderError &&
        other.inputBorderDisabled == inputBorderDisabled &&
        other.error == error &&
        other.success == success &&
        other.warning == warning &&
        other.info == info &&
        other.badgeSuccessText == badgeSuccessText &&
        other.badgeSuccessBackground == badgeSuccessBackground &&
        other.badgePendingText == badgePendingText &&
        other.badgePendingBackground == badgePendingBackground &&
        other.badgeErrorText == badgeErrorText &&
        other.badgeErrorBackground == badgeErrorBackground &&
        other.badgeInfoText == badgeInfoText &&
        other.badgeInfoBackground == badgeInfoBackground &&
        other.badgeNeutralText == badgeNeutralText &&
        other.badgeNeutralBackground == badgeNeutralBackground &&
        other.badgeSubmittedText == badgeSubmittedText &&
        other.badgeSubmittedBackground == badgeSubmittedBackground &&
        other.badgeInReviewText == badgeInReviewText &&
        other.badgeInReviewBackground == badgeInReviewBackground &&
        other.badgeApprovedText == badgeApprovedText &&
        other.badgeApprovedBackground == badgeApprovedBackground &&
        other.badgeEscalatedText == badgeEscalatedText &&
        other.badgeEscalatedBackground == badgeEscalatedBackground &&
        other.badgeOnHoldText == badgeOnHoldText &&
        other.badgeOnHoldBackground == badgeOnHoldBackground &&
        other.tooltipBackground == tooltipBackground &&
        other.tooltipText == tooltipText;
  }

  @override
  // `Object.hash` takes at most 20 positional arguments, so the 83 roles go
  // through `Object.hashAll`.
  int get hashCode => Object.hashAll(<int>[
    textPrimary,
    textSecondary,
    textTertiary,
    surfacePage,
    surfaceCard,
    surfaceRaised,
    surfaceSunken,
    surfaceHover,
    surfacePrimary,
    borderDefault,
    borderDecorative,
    cardBorder,
    focusRing,
    focusHalo,
    focusRingError,
    focusHaloError,
    shadowColor,
    headerBackground,
    mastheadBackground,
    serviceCardIcon,
    summaryBoxAccent,
    tagApproved,
    tagNotice,
    headerBorder,
    headerProgressTrack,
    buttonPrimaryBackground,
    buttonPrimaryLabel,
    buttonPrimaryHover,
    buttonPrimaryPressed,
    buttonSecondaryBackground,
    buttonSecondaryLabel,
    buttonSecondaryBorder,
    buttonSecondaryHover,
    buttonSecondaryPressed,
    buttonGhostLabel,
    buttonGhostHover,
    buttonGhostPressed,
    linkLabel,
    linkLabelHover,
    linkDestructiveLabel,
    linkDestructiveLabelHover,
    buttonDestructiveBackground,
    buttonDestructiveLabel,
    buttonDestructiveHover,
    buttonDestructivePressed,
    disabledBackground,
    disabledForeground,
    disabledBorder,
    textStaticBlack,
    notificationBadgeBackground,
    bannerWarningTitle,
    badgeArchivedText,
    listBackground,
    listBackgroundHover,
    datePickerRangeHighlight,
    serviceCardSelectedBackground,
    inputLabel,
    inputPlaceholder,
    inputHelper,
    inputIcon,
    inputBorderDefault,
    inputBorderFocused,
    inputBorderError,
    inputBorderDisabled,
    error,
    success,
    warning,
    info,
    badgeSuccessText,
    badgeSuccessBackground,
    badgePendingText,
    badgePendingBackground,
    badgeErrorText,
    badgeErrorBackground,
    badgeInfoText,
    badgeInfoBackground,
    badgeNeutralText,
    badgeNeutralBackground,
    badgeSubmittedText,
    badgeSubmittedBackground,
    badgeInReviewText,
    badgeInReviewBackground,
    badgeApprovedText,
    badgeApprovedBackground,
    badgeEscalatedText,
    badgeEscalatedBackground,
    badgeOnHoldText,
    badgeOnHoldBackground,
    tooltipBackground,
    tooltipText,
  ]);
}

/// Linearly interpolates two packed ARGB values channel by channel.
///
/// Exposed for [SldsRawColorTokens.lerp] and reusable by any other token type
/// that stores colours as ints.
int lerpArgb(int a, int b, double t) {
  int channel(int shift) {
    final av = (a >> shift) & 0xff;
    final bv = (b >> shift) & 0xff;
    return (av + (bv - av) * t).round().clamp(0, 255);
  }

  return (channel(24) << 24) |
      (channel(16) << 16) |
      (channel(8) << 8) |
      channel(0);
}
