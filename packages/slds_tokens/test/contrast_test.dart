// WCAG 2.2 AA contrast compliance for every declared token pair (§5, §8).
//
// A plain Dart test, no widget binding: the tokens are hex ints, so the ratio
// is arithmetic. Widget-level checks that catch composited-opacity problems
// this cannot see live in `slds_components` as `meetsGuideline` matchers.

import 'package:slds_tokens/slds_tokens.dart';
import 'package:test/test.dart';

/// A foreground/background pairing the library actually renders.
class _Pair {
  const _Pair(
    this.name,
    this.foreground,
    this.background, {
    this.largeText = false,
  });

  final String name;
  final int Function(SldsRawColorTokens) foreground;
  final int Function(SldsRawColorTokens) background;

  /// Large text (>=18pt, or >=14pt bold) needs 3:1 rather than 4.5:1.
  final bool largeText;
}

/// Pairs exempt from the ratio, each with the reason it is exempt.
///
/// WCAG 1.4.3 exempts disabled controls and purely decorative fills. Every
/// entry needs a justification — an unexplained exemption is how this check
/// stops meaning anything.
const _exemptions = <String, String>{
  'disabled label on disabled background':
      'WCAG 1.4.3 exempts inactive controls.',
  'placeholder on input background':
      'Placeholder is supplementary; the field label carries the requirement.',
  'decorative border on page':
      'Non-text decorative divider, not a UI component boundary (1.4.11).',
};

final _pairs = <_Pair>[
  // Body and heading text on each surface.
  _Pair('primary text on page', (c) => c.textPrimary, (c) => c.surfacePage),
  _Pair('primary text on card', (c) => c.textPrimary, (c) => c.surfaceCard),
  _Pair('primary text on raised', (c) => c.textPrimary, (c) => c.surfaceRaised),
  _Pair('secondary text on page', (c) => c.textSecondary, (c) => c.surfacePage),
  _Pair('secondary text on card', (c) => c.textSecondary, (c) => c.surfaceCard),
  _Pair('tertiary text on page', (c) => c.textTertiary, (c) => c.surfacePage),
  _Pair('tertiary text on card', (c) => c.textTertiary, (c) => c.surfaceCard),

  // Buttons.
  // Display and heading styles are large text (>=18pt), so 3:1 applies.
  _Pair(
    'display text on page',
    (c) => c.textPrimary,
    (c) => c.surfacePage,
    largeText: true,
  ),
  _Pair(
    'primary button label',
    (c) => c.buttonPrimaryLabel,
    (c) => c.buttonPrimaryBackground,
  ),
  _Pair(
    'secondary button label',
    (c) => c.buttonSecondaryLabel,
    (c) => c.buttonSecondaryBackground,
  ),
  _Pair(
    'destructive button label',
    (c) => c.buttonDestructiveLabel,
    (c) => c.buttonDestructiveBackground,
  ),

  // Status badges — all rendered as small text.
  _Pair(
    'success badge',
    (c) => c.badgeSuccessText,
    (c) => c.badgeSuccessBackground,
  ),
  _Pair(
    'pending badge',
    (c) => c.badgePendingText,
    (c) => c.badgePendingBackground,
  ),
  _Pair('error badge', (c) => c.badgeErrorText, (c) => c.badgeErrorBackground),
  _Pair('info badge', (c) => c.badgeInfoText, (c) => c.badgeInfoBackground),
  _Pair(
    'neutral badge',
    (c) => c.badgeNeutralText,
    (c) => c.badgeNeutralBackground,
  ),
  _Pair(
    'submitted badge',
    (c) => c.badgeSubmittedText,
    (c) => c.badgeSubmittedBackground,
  ),
  _Pair(
    'in-review badge',
    (c) => c.badgeInReviewText,
    (c) => c.badgeInReviewBackground,
  ),
  _Pair(
    'approved badge',
    (c) => c.badgeApprovedText,
    (c) => c.badgeApprovedBackground,
  ),
  _Pair(
    'escalated badge',
    (c) => c.badgeEscalatedText,
    (c) => c.badgeEscalatedBackground,
  ),
  _Pair(
    'on-hold badge',
    (c) => c.badgeOnHoldText,
    (c) => c.badgeOnHoldBackground,
  ),

  // Inputs.
  _Pair('input label on card', (c) => c.inputLabel, (c) => c.surfaceCard),
  _Pair('input helper on card', (c) => c.inputHelper, (c) => c.surfaceCard),
  _Pair('input icon on card', (c) => c.inputIcon, (c) => c.surfaceCard),
  _Pair(
    'placeholder on input background',
    (c) => c.inputPlaceholder,
    (c) => c.surfaceCard,
  ),

  // Semantic foregrounds.
  _Pair('error text on page', (c) => c.error, (c) => c.surfacePage),
  _Pair('success text on page', (c) => c.success, (c) => c.surfacePage),
];

/// Non-text UI components need 3:1 against what they sit on (WCAG 1.4.11).
final _nonTextPairs = <_Pair>[
  _Pair('default border on card', (c) => c.borderDefault, (c) => c.surfaceCard),
  _Pair('focus ring on page', (c) => c.focusRing, (c) => c.surfacePage),
  _Pair('focus ring on card', (c) => c.focusRing, (c) => c.surfaceCard),
  _Pair(
    'error focus ring on card',
    (c) => c.focusRingError,
    (c) => c.surfaceCard,
  ),
];

void main() {
  final themes = <String, SldsRawColorTokens>{
    'light': SldsRawColorTokens.light(),
    'dark': SldsRawColorTokens.dark(),
    'highContrast': SldsRawColorTokens.highContrast(),
  };

  for (final theme in themes.entries) {
    group('${theme.key} theme', () {
      for (final pair in _pairs) {
        test('${pair.name} meets WCAG AA', () {
          if (_exemptions.containsKey(pair.name)) {
            markTestSkipped(_exemptions[pair.name]!);
            return;
          }

          final ratio = contrastRatio(
            pair.foreground(theme.value),
            pair.background(theme.value),
          );
          final required = pair.largeText ? 3.0 : 4.5;

          expect(
            ratio,
            greaterThanOrEqualTo(required),
            reason:
                '${pair.name} in ${theme.key} is ${ratio.toStringAsFixed(2)}:1, '
                'needs $required:1. Adjust the token, or add an exemption with '
                'a justification if this pairing is genuinely out of scope.',
          );
        });
      }

      for (final pair in _nonTextPairs) {
        test('${pair.name} meets WCAG non-text contrast', () {
          final ratio = contrastRatio(
            pair.foreground(theme.value),
            pair.background(theme.value),
          );

          expect(
            ratio,
            greaterThanOrEqualTo(3.0),
            reason:
                '${pair.name} in ${theme.key} is ${ratio.toStringAsFixed(2)}:1, '
                'needs 3:1 (WCAG 1.4.11).',
          );
        });
      }
    });
  }

  group('contrast maths', () {
    test('black on white is the maximum ratio', () {
      expect(contrastRatio(0xff000000, 0xffffffff), closeTo(21, 0.01));
    });

    test('a colour against itself is 1:1', () {
      expect(contrastRatio(0xff7f7f7f, 0xff7f7f7f), closeTo(1, 0.001));
    });

    test('order does not matter', () {
      expect(
        contrastRatio(0xff123456, 0xffabcdef),
        closeTo(contrastRatio(0xffabcdef, 0xff123456), 0.0001),
      );
    });

    test('compositing respects the alpha', () {
      // 50% black over white lands mid-grey.
      expect(compositeOver(0xff000000, 0xffffffff, 0.5), 0xff808080);
    });
  });
}
