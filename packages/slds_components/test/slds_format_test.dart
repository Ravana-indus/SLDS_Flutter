// Locale-aware formatting (§6).
//
// Fines, fees and expiry dates are read by citizens making decisions, so
// these assert the actual rendered strings rather than that a call succeeds.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  setUpAll(initializeDateFormatting);

  const en = SldsFormat(Locale('en'));
  final expiry = DateTime(2026, 8, 15, 9, 30);

  group('dates', () {
    test('use a named month, not an ambiguous numeric order', () {
      // 15/08 and 08/15 read as different dates depending on the reader's
      // country; a month name cannot be misread.
      expect(en.date(expiry), 'Aug 15, 2026');
    });

    test('short form is available for dense tables', () {
      expect(en.shortDate(expiry), '8/15/2026');
    });

    test('time is 24-hour', () {
      expect(en.time(expiry), '09:30');
    });

    test('date and time render together', () {
      expect(en.dateTime(expiry), 'Aug 15, 2026, 09:30');
    });
  });

  group('currency', () {
    test('carries the rupee symbol and two decimals', () {
      // "Rs 2,500" invites the reader to wonder whether cents were dropped.
      expect(en.currency(2500), 'Rs 2,500.00');
    });

    test('groups thousands', () {
      expect(en.currency(1234567.5), 'Rs 1,234,567.50');
    });

    test('compact form drops decimals for whole totals', () {
      expect(en.currencyCompact(2500), 'Rs 2,500');
    });

    test('renders zero rather than an empty string', () {
      expect(en.currency(0), 'Rs 0.00');
    });

    test('uses Rs, not the glyph that renders as tofu in many fonts', () {
      expect(SldsFormat.currencySymbol, 'Rs');
      expect(SldsFormat.currencyCode, 'LKR');
    });
  });

  group('numbers', () {
    test('group separators appear', () {
      expect(en.number(1250), '1,250');
    });

    test('percentages render as percentages', () {
      expect(en.percent(0.12), '12%');
    });
  });

  group('locale', () {
    test('si and ta produce output rather than throwing', () {
      // Both are supported locales, so every formatter must handle them.
      for (final tag in ['si', 'ta']) {
        final format = SldsFormat(Locale(tag));
        expect(format.date(expiry), isNotEmpty);
        expect(format.currency(2500), contains('2'));
        expect(format.number(1250), isNotEmpty);
      }
    });

    test('equality is by locale, so it is safe to hold in state', () {
      expect(const SldsFormat(Locale('en')), const SldsFormat(Locale('en')));
      expect(
        const SldsFormat(Locale('en')),
        isNot(const SldsFormat(Locale('si'))),
      );
    });
  });

  testWidgets('context.sldsFormat picks up the ambient locale', (tester) async {
    late SldsFormat captured;
    await tester.pumpWidget(
      Localizations(
        locale: const Locale('si'),
        delegates: SldsLocalizations.localizationsDelegates,
        child: Builder(
          builder: (context) {
            captured = context.sldsFormat;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(captured.locale, const Locale('si'));
  });
}
