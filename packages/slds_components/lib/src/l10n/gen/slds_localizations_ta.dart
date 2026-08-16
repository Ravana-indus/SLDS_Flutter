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
  String get loadingEllipsis => 'ஏற்றுகிறது…';

  @override
  String get close => 'மூடு';

  @override
  String get retry => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get error => 'பிழை';

  @override
  String get dismiss => 'நிராகரி';

  @override
  String get back => 'பின்செல்';

  @override
  String get menu => 'பட்டி';

  @override
  String get progress => 'முன்னேற்றம்';

  @override
  String get upload => 'பதிவேற்று';

  @override
  String get search => 'தேடு';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get apply => 'பயன்படுத்து';

  @override
  String get selectAnOption => 'ஒரு விருப்பத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get recentSearches => 'சமீபத்திய தேடல்கள்';

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

  @override
  String removeItem(String label) {
    return '$label அகற்று';
  }

  @override
  String stepOf(int number, String title, String description) {
    return 'படி $number: $title. $description';
  }

  @override
  String labelledValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String get setYourTime => 'உங்கள் நேரத்தை அமைக்கவும்';

  @override
  String get uploadHint => 'PDF, JPEG அல்லது PNG, 5MB க்கும் குறைவாக';

  @override
  String get showPassword => 'கடவுச்சொல்லைக் காட்டு';

  @override
  String get hidePassword => 'கடவுச்சொல்லை மறை';
}
