// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'slds_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class SldsLocalizationsSi extends SldsLocalizations {
  SldsLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get loading => 'පූරණය වෙමින්';

  @override
  String get loadingEllipsis => 'පූරණය වෙමින්…';

  @override
  String get close => 'වසන්න';

  @override
  String get retry => 'නැවත උත්සාහ කරන්න';

  @override
  String get error => 'දෝෂයකි';

  @override
  String get dismiss => 'ඉවත් කරන්න';

  @override
  String get back => 'ආපසු';

  @override
  String get menu => 'මෙනුව';

  @override
  String get progress => 'ප්‍රගතිය';

  @override
  String get upload => 'උඩුගත කරන්න';

  @override
  String get search => 'සොයන්න';

  @override
  String get cancel => 'අවලංගු කරන්න';

  @override
  String get apply => 'යොදන්න';

  @override
  String get selectAnOption => 'විකල්පයක් තෝරන්න';

  @override
  String get recentSearches => 'මෑත සෙවීම්';

  @override
  String unreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'නොකියවූ දැනුම්දීම් $countක්',
      one: 'නොකියවූ දැනුම්දීම් 1ක්',
      zero: 'නොකියවූ දැනුම්දීම් නැත',
    );
    return '$_temp0';
  }

  @override
  String removeItem(String label) {
    return '$label ඉවත් කරන්න';
  }

  @override
  String stepOf(int number, String title, String description) {
    return 'පියවර $number: $title. $description';
  }

  @override
  String labelledValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String get setYourTime => 'ඔබේ වේලාව සකසන්න';

  @override
  String get uploadHint => 'PDF, JPEG හෝ PNG, 5MB ට අඩු';
}
