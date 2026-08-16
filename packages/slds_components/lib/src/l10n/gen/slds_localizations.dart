import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'slds_localizations_en.dart';
import 'slds_localizations_si.dart';
import 'slds_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of SldsLocalizations
/// returned by `SldsLocalizations.of(context)`.
///
/// Applications need to include `SldsLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/slds_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SldsLocalizations.localizationsDelegates,
///   supportedLocales: SldsLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the SldsLocalizations.supportedLocales
/// property.
abstract class SldsLocalizations {
  SldsLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static SldsLocalizations of(BuildContext context) {
    return Localizations.of<SldsLocalizations>(context, SldsLocalizations)!;
  }

  static const LocalizationsDelegate<SldsLocalizations> delegate =
      _SldsLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
    Locale('ta'),
  ];

  /// Screen-reader label announced while a component is in its loading state.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// Visible label beside a progress indicator. Distinct from "loading": the trailing ellipsis signals ongoing work to a sighted reader, and is noise when spoken aloud.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loadingEllipsis;

  /// Label for the control that dismisses a dialog, sheet or banner.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Label for the control that re-attempts a failed action.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Screen-reader label announced when a component enters its error state.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Label for the control that dismisses a transient message such as a snackbar.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// Screen-reader label for the control that returns to the previous screen.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Screen-reader label for the control that opens the navigation menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// Screen-reader label for a progress indicator.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// Screen-reader label for the control that starts a file upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// Default placeholder for a search input.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Label for the control that abandons a dialog without applying changes.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label for the control that confirms a dialog's changes.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Default placeholder for a dropdown with no selection.
  ///
  /// In en, this message translates to:
  /// **'Select an option'**
  String get selectAnOption;

  /// Heading above previously used search terms. Upper case in English; translators should use whatever case is idiomatic.
  ///
  /// In en, this message translates to:
  /// **'RECENT SEARCHES'**
  String get recentSearches;

  /// Screen-reader label giving a badge count its meaning, rather than announcing a bare number.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No unread notifications} =1{1 unread notification} other{{count} unread notifications}}'**
  String unreadCount(int count);

  /// Screen-reader label for the control that removes a chip or tag. {label} is the chip's own text.
  ///
  /// In en, this message translates to:
  /// **'Remove {label}'**
  String removeItem(String label);

  /// Screen-reader label for one step in a process list, read as a single sentence.
  ///
  /// In en, this message translates to:
  /// **'Step {number}: {title}. {description}'**
  String stepOf(int number, String title, String description);

  /// Screen-reader label pairing a field name with its value in a summary list.
  ///
  /// In en, this message translates to:
  /// **'{label}: {value}'**
  String labelledValue(String label, String value);

  /// Title of the time picker dialog.
  ///
  /// In en, this message translates to:
  /// **'Set Your Time'**
  String get setYourTime;

  /// Helper text under an upload field listing accepted formats and the size limit. The format names are proper nouns and stay in Latin script; the rest is translated.
  ///
  /// In en, this message translates to:
  /// **'PDF, JPEG or PNG less than 5MB'**
  String get uploadHint;

  /// Accessible name for the password reveal toggle when the password is hidden.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// Accessible name for the password reveal toggle when the password is visible.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;
}

class _SldsLocalizationsDelegate
    extends LocalizationsDelegate<SldsLocalizations> {
  const _SldsLocalizationsDelegate();

  @override
  Future<SldsLocalizations> load(Locale locale) {
    return SynchronousFuture<SldsLocalizations>(
      lookupSldsLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_SldsLocalizationsDelegate old) => false;
}

SldsLocalizations lookupSldsLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SldsLocalizationsEn();
    case 'si':
      return SldsLocalizationsSi();
    case 'ta':
      return SldsLocalizationsTa();
  }

  throw FlutterError(
    'SldsLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
