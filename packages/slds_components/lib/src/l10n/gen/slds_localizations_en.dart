// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'slds_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SldsLocalizationsEn extends SldsLocalizations {
  SldsLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loading => 'Loading';

  @override
  String get loadingEllipsis => 'Loading…';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String get error => 'Error';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get back => 'Back';

  @override
  String get menu => 'Menu';

  @override
  String get progress => 'Progress';

  @override
  String get upload => 'Upload';

  @override
  String get search => 'Search';

  @override
  String get cancel => 'Cancel';

  @override
  String get apply => 'Apply';

  @override
  String get selectAnOption => 'Select an option';

  @override
  String get recentSearches => 'RECENT SEARCHES';

  @override
  String unreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread notifications',
      one: '1 unread notification',
      zero: 'No unread notifications',
    );
    return '$_temp0';
  }

  @override
  String removeItem(String label) {
    return 'Remove $label';
  }

  @override
  String stepOf(int number, String title, String description) {
    return 'Step $number: $title. $description';
  }

  @override
  String labelledValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String get setYourTime => 'Set Your Time';

  @override
  String get uploadHint => 'PDF, JPEG or PNG less than 5MB';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get timePeriodAm => 'AM';

  @override
  String get timePeriodPm => 'PM';

  @override
  String get errorNotFoundTitle => 'Page not found';

  @override
  String get errorNotFoundDescription =>
      'Sorry we were unable to find that page';

  @override
  String get errorServerTitle => 'This page isn\'t working';

  @override
  String get errorServerDescription =>
      'We apologise and are fixing the problem. Please try again later.';

  @override
  String get errorUnauthorizedTitle => 'Unauthorized';

  @override
  String get errorUnauthorizedDescription =>
      'Something has gone wrong on the app\'s server';

  @override
  String get goToHome => 'Go to Home';

  @override
  String get thereIsAProblem => 'There is a problem';
}
