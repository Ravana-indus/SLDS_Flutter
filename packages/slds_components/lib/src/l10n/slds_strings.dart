import 'package:flutter/widgets.dart';
import 'package:slds_components/src/l10n/gen/slds_localizations.dart';

/// Reads the library's own strings from the ambient [Localizations].
///
/// Use this rather than `SldsLocalizations.of(context)` directly: the
/// generated `of` ends in a null check, so a host app that forgets the
/// delegate gets "Null check operator used on a null value" from inside a
/// widget's `build` — a message that says nothing about what is wrong or
/// where to fix it. This raises the same failure with an actionable one.
extension SldsStringsContext on BuildContext {
  /// The library's localized strings.
  ///
  /// Throws a [FlutterError] naming the missing delegate if the host app has
  /// not installed `SldsLocalizations.localizationsDelegates`.
  SldsLocalizations get sldsStrings {
    final strings = Localizations.of<SldsLocalizations>(
      this,
      SldsLocalizations,
    );
    if (strings != null) return strings;

    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary('No SldsLocalizations found in the widget tree.'),
      ErrorDescription(
        'SLDS components read their own strings — the loading announcement, '
        'the close and retry labels, badge counts — through their own '
        'delegate. Without it, screen readers get nothing to announce.',
      ),
      ErrorHint(
        'Add the delegates to your MaterialApp:\n\n'
        '  MaterialApp(\n'
        '    localizationsDelegates: '
        'SldsLocalizations.localizationsDelegates,\n'
        '    supportedLocales: SldsLocalizations.supportedLocales,\n'
        '  )\n\n'
        'Merge them into your own lists if you already localize other '
        'packages.',
      ),
    ]);
  }
}
