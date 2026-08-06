import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  test('all three SLDS locales resolve a non-empty loading label', () {
    for (final locale in SldsLocalizations.supportedLocales) {
      final l10n = lookupSldsLocalizations(locale);
      expect(l10n.loading, isNotEmpty, reason: 'missing translation for ${locale.languageCode}');
    }
  });
}
