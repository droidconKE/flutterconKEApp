import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @sessionTimeAndVenue.
  ///
  /// In en, this message translates to:
  /// **'@ {time} | {venue}'**
  String sessionTimeAndVenue(String time, String venue);

  /// No description provided for @sessionFullTimeAndVenue.
  ///
  /// In en, this message translates to:
  /// **'{startTime} - {endTime} | {venue}'**
  String sessionFullTimeAndVenue(
    String startTime,
    String endTime,
    String venue,
  );

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @expert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get expert;

  /// No description provided for @sessionType.
  ///
  /// In en, this message translates to:
  /// **'Session type'**
  String get sessionType;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @keynote.
  ///
  /// In en, this message translates to:
  /// **'Keynote'**
  String get keynote;

  /// No description provided for @codeLab.
  ///
  /// In en, this message translates to:
  /// **'CodeLab'**
  String get codeLab;

  /// No description provided for @lightningTalk.
  ///
  /// In en, this message translates to:
  /// **'Lightning Talk'**
  String get lightningTalk;

  /// No description provided for @workshop.
  ///
  /// In en, this message translates to:
  /// **'Workshop'**
  String get workshop;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutFluttercon.
  ///
  /// In en, this message translates to:
  /// **'Fluttercon Kenya is the first event of its kind in Africa, launching the Fluttercon conference on the continent. It will feature tech talks, workshops, and panels led by industry experts, Google Developer Experts, and seasoned Flutter specialists, all focusing on the latest advancements in Flutter and Dart technologies.\n\n Organized by the same team behind four successful editions of Droidcon Kenya, Fluttercon Kenya promises to maintain a high standard of excellence. With a history of hosting over 3,000 attendees and curating 200 sessions, the team brings unmatched expertise to this event.\n\n\'Co-located with Droidcon Kenya, Africa\'s top Android developer conference, Fluttercon Kenya will run from November 6th to 8th, 2024. The joint event will gather hundreds of Flutter and Android developers, offering a packed program of tech talks, workshops, and panels, forming one of the continent\'s largest mobile developer gatherings.\''**
  String get aboutFluttercon;

  /// No description provided for @organisingTeam.
  ///
  /// In en, this message translates to:
  /// **'Organising Team'**
  String get organisingTeam;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @twitterHandle.
  ///
  /// In en, this message translates to:
  /// **'Twitter Handle'**
  String get twitterHandle;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @postShared.
  ///
  /// In en, this message translates to:
  /// **'Post shared successfully.'**
  String get postShared;

  /// No description provided for @twitter.
  ///
  /// In en, this message translates to:
  /// **'Twitter'**
  String get twitter;

  /// No description provided for @linkedin.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get linkedin;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @whatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsApp;

  /// No description provided for @telegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get telegram;

  /// No description provided for @yourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve'**
  String get yourFeedback;

  /// No description provided for @howWasFluttercon.
  ///
  /// In en, this message translates to:
  /// **'How is/was the event?'**
  String get howWasFluttercon;

  /// No description provided for @typeYourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Type your feedback here'**
  String get typeYourFeedback;

  /// No description provided for @feedbackSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted successfully.'**
  String get feedbackSubmitted;

  /// No description provided for @submitFeedback.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// No description provided for @feedbackError.
  ///
  /// In en, this message translates to:
  /// **'Please ensure you have selected a rating and written your feedback'**
  String get feedbackError;

  /// No description provided for @speaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get speaker;

  /// No description provided for @welcomeToFlutterCon.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the largest Focused Android Developer community in Africa'**
  String get welcomeToFlutterCon;

  /// No description provided for @speakers.
  ///
  /// In en, this message translates to:
  /// **'Speakers'**
  String get speakers;

  /// No description provided for @organisedBy.
  ///
  /// In en, this message translates to:
  /// **'Organised by'**
  String get organisedBy;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @sponsors.
  ///
  /// In en, this message translates to:
  /// **'Sponsors'**
  String get sponsors;

  /// No description provided for @sessionDetails.
  ///
  /// In en, this message translates to:
  /// **'Session Details'**
  String get sessionDetails;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search sessions or speakers'**
  String get searchHint;

  /// No description provided for @errorSearch.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get errorSearch;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String day(int day);

  /// No description provided for @mySessions.
  ///
  /// In en, this message translates to:
  /// **'My Sessions'**
  String get mySessions;

  /// No description provided for @allSessions.
  ///
  /// In en, this message translates to:
  /// **'All Sessions'**
  String get allSessions;

  /// No description provided for @areYouSureLogOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure\nyou want to log out?'**
  String get areYouSureLogOut;

  /// No description provided for @logoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Logging out will end your current session. You can always log back in to pick up right where you left off.'**
  String get logoutDesc;

  /// No description provided for @logoutLoading.
  ///
  /// In en, this message translates to:
  /// **'logging out...'**
  String get logoutLoading;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'yes, log out'**
  String get confirmLogout;

  /// No description provided for @noSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions found'**
  String get noSessions;

  /// No description provided for @noPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts found'**
  String get noPosts;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
