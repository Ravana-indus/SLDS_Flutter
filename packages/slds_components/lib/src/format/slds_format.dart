import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Locale-aware formatting for the values SLDS mini-apps display (§6).
///
/// Dates, numbers and currency are formatted here rather than with string
/// interpolation in a widget. Formatting them independently per mini-app is
/// exactly the drift the design system exists to prevent, and unlike a
/// spacing inconsistency it changes whether a citizen reads an expiry date
/// or a fine amount correctly.
///
/// Every method takes the active [Locale] so output follows the app's
/// language rather than the device's region. Read it from the context:
///
/// ```dart
/// final format = SldsFormat.of(context);
/// Text(format.date(licence.expiresOn));   // 15 Aug 2026
/// Text(format.currency(fine.amountLkr));  // Rs 2,500.00
/// ```
@immutable
class SldsFormat {
  /// Creates a formatter bound to [locale].
  const SldsFormat(this.locale);

  /// The formatter for the ambient [Localizations] locale.
  factory SldsFormat.of(BuildContext context) =>
      SldsFormat(Localizations.localeOf(context));

  /// ISO 4217 code for the Sri Lankan rupee.
  static const String currencyCode = 'LKR';

  /// Symbol shown before an amount. `Rs` rather than the glyph, which is
  /// missing from many fonts and renders as tofu.
  static const String currencySymbol = 'Rs';

  /// The locale all output is formatted for.
  final Locale locale;

  String get _tag => locale.toLanguageTag();

  /// A date as `15 Aug 2026` — unambiguous, unlike a numeric order that
  /// reads differently by country.
  String date(DateTime value) => DateFormat.yMMMd(_tag).format(value);

  /// A date with no month name, for dense tables: `15/08/2026`.
  String shortDate(DateTime value) => DateFormat.yMd(_tag).format(value);

  /// A date and time together: `15 Aug 2026, 09:30`.
  String dateTime(DateTime value) =>
      '${date(value)}, ${DateFormat.Hm(_tag).format(value)}';

  /// A time of day in 24-hour form: `09:30`.
  String time(DateTime value) => DateFormat.Hm(_tag).format(value);

  /// A whole number with grouping separators: `1,250`.
  String number(num value) => NumberFormat.decimalPattern(_tag).format(value);

  /// An amount in rupees: `Rs 2,500.00`.
  ///
  /// Always two decimal places — a fine or fee shown as `Rs 2,500` invites
  /// the reader to wonder whether cents were truncated.
  String currency(num value) => NumberFormat.currency(
    locale: _tag,
    symbol: '$currencySymbol ',
    decimalDigits: 2,
  ).format(value);

  /// An amount with no decimals, for totals where cents are not meaningful:
  /// `Rs 2,500`.
  String currencyCompact(num value) => NumberFormat.currency(
    locale: _tag,
    symbol: '$currencySymbol ',
    decimalDigits: 0,
  ).format(value);

  /// A percentage: `12%`.
  String percent(num value) => NumberFormat.percentPattern(_tag).format(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SldsFormat && other.locale == locale);

  @override
  int get hashCode => locale.hashCode;
}

/// `context.sldsFormat` — the [SldsFormat] for the ambient locale.
extension SldsFormatContext on BuildContext {
  /// Locale-aware date, number and currency formatting.
  SldsFormat get sldsFormat => SldsFormat.of(this);
}
