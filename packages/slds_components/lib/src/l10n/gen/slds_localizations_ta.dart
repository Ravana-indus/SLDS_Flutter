// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'slds_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class SldsLocalizationsTa extends SldsLocalizations {
  SldsLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get loading => 'ஏற்றுகிறது';

  @override
  String get close => 'மூடு';

  @override
  String get retry => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get error => 'பிழை';

  @override
  String get dismiss => 'நிராகரி';

  @override
  String unreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'படிக்காத $count அறிவிப்புகள்',
      one: 'படிக்காத 1 அறிவிப்பு',
      zero: 'படிக்காத அறிவிப்புகள் இல்லை',
    );
    return '$_temp0';
  }
}
