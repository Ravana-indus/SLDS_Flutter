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
  String sensitiveValue(String label) {
    return '$label: மறைக்கப்பட்டுள்ளது. வெளிப்படுத்த இருமுறை தட்டவும்.';
  }

  @override
  String sensitiveValueRevealed(String label, String value) {
    return '$label: $value. மறைக்க இருமுறை தட்டவும்.';
  }

  @override
  String get setYourTime => 'உங்கள் நேரத்தை அமைக்கவும்';

  @override
  String get uploadHint => 'PDF, JPEG அல்லது PNG, 5MB க்கும் குறைவாக';

  @override
  String get showPassword => 'கடவுச்சொல்லைக் காட்டு';

  @override
  String get hidePassword => 'கடவுச்சொல்லை மறை';

  @override
  String get passwordLabel => 'கடவுச்சொல்';

  @override
  String get passwordHint => 'எடுத்துக்காட்டு';

  @override
  String get timePeriodAm => 'மு.ப.';

  @override
  String get timePeriodPm => 'பி.ப.';

  @override
  String get errorNotFoundTitle => 'பக்கம் கிடைக்கவில்லை';

  @override
  String get errorNotFoundDescription =>
      'மன்னிக்கவும், அந்தப் பக்கத்தைக் கண்டுபிடிக்க முடியவில்லை';

  @override
  String get errorServerTitle => 'இந்தப் பக்கம் இயங்கவில்லை';

  @override
  String get errorServerDescription =>
      'வருந்துகிறோம், சிக்கலைச் சரிசெய்து வருகிறோம். பின்னர் மீண்டும் முயற்சிக்கவும்.';

  @override
  String get errorUnauthorizedTitle => 'அங்கீகாரம் இல்லை';

  @override
  String get errorUnauthorizedDescription =>
      'செயலியின் சேவையகத்தில் ஏதோ தவறு நேர்ந்துள்ளது';

  @override
  String get goToHome => 'முகப்புக்குச் செல்';

  @override
  String get thereIsAProblem => 'ஒரு சிக்கல் உள்ளது';

  @override
  String get required => 'தேவை';

  @override
  String get expanded => 'விரிவாக்கப்பட்டது';

  @override
  String get collapsed => 'சுருக்கப்பட்டது';

  @override
  String digitOf(int position, int total) {
    return 'இலக்கம் $position / $total';
  }

  @override
  String get clearSearch => 'தேடலை அழி';

  @override
  String recentSearch(String label) {
    return 'சமீபத்திய தேடல்: $label';
  }

  @override
  String suggestion(String label) {
    return 'பரிந்துரை: $label';
  }

  @override
  String get previousMonth => 'முந்தைய மாதம்';

  @override
  String get nextMonth => 'அடுத்த மாதம்';

  @override
  String get selectHour => 'மணிநேரத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectMinute => 'நிமிடத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get noResults => 'முடிவுகள் இல்லை';
}
