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
  String get close => 'වසන්න';

  @override
  String get retry => 'නැවත උත්සාහ කරන්න';

  @override
  String get error => 'දෝෂයකි';

  @override
  String get dismiss => 'ඉවත් කරන්න';

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
}
