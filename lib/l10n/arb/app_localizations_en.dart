// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get feedback => 'Feedback';

  @override
  String sessionTimeAndVenue(String time, String venue) {
    return '@ $time | $venue';
  }

  @override
  String sessionFullTimeAndVenue(
    String startTime,
    String endTime,
    String venue,
  ) {
    return '$startTime - $endTime | $venue';
  }

  @override
  String get filter => 'Filter';

  @override
  String get cancel => 'Cancel';

  @override
  String get level => 'Level';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get expert => 'Expert';

  @override
  String get sessionType => 'Session type';

  @override
  String get session => 'Session';

  @override
  String get keynote => 'Keynote';

  @override
  String get codeLab => 'CodeLab';

  @override
  String get lightningTalk => 'Lightning Talk';

  @override
  String get workshop => 'Workshop';

  @override
  String get reset => 'Reset';

  @override
  String get about => 'About';

  @override
  String get aboutFluttercon =>
      'Fluttercon Kenya is the first event of its kind in Africa, launching the Fluttercon conference on the continent. It will feature tech talks, workshops, and panels led by industry experts, Google Developer Experts, and seasoned Flutter specialists, all focusing on the latest advancements in Flutter and Dart technologies.\n\n Organized by the same team behind four successful editions of Droidcon Kenya, Fluttercon Kenya promises to maintain a high standard of excellence. With a history of hosting over 3,000 attendees and curating 200 sessions, the team brings unmatched expertise to this event.\n\n\'Co-located with Droidcon Kenya, Africa\'s top Android developer conference, Fluttercon Kenya will run from November 6th to 8th, 2024. The joint event will gather hundreds of Flutter and Android developers, offering a packed program of tech talks, workshops, and panels, forming one of the continent\'s largest mobile developer gatherings.\'';

  @override
  String get organisingTeam => 'Organising Team';

  @override
  String get team => 'Team';

  @override
  String get bio => 'Bio';

  @override
  String get twitterHandle => 'Twitter Handle';

  @override
  String get share => 'Share';

  @override
  String get postShared => 'Post shared successfully.';

  @override
  String get twitter => 'Twitter';

  @override
  String get linkedin => 'LinkedIn';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get facebook => 'Facebook';

  @override
  String get whatsApp => 'WhatsApp';

  @override
  String get telegram => 'Telegram';

  @override
  String get yourFeedback => 'Your feedback helps us improve';

  @override
  String get howWasFluttercon => 'How is/was the event?';

  @override
  String get typeYourFeedback => 'Type your feedback here';

  @override
  String get feedbackSubmitted => 'Feedback submitted successfully.';

  @override
  String get submitFeedback => 'Submit Feedback';

  @override
  String get feedbackError =>
      'Please ensure you have selected a rating and written your feedback';

  @override
  String get speaker => 'Speaker';

  @override
  String get welcomeToFlutterCon =>
      'Welcome to the largest Focused Android Developer community in Africa';

  @override
  String get speakers => 'Speakers';

  @override
  String get organisedBy => 'Organised by';

  @override
  String get sessions => 'Sessions';

  @override
  String get viewAll => 'View All';

  @override
  String get details => 'Details';

  @override
  String get sponsors => 'Sponsors';

  @override
  String get sessionDetails => 'Session Details';

  @override
  String get searchHint => 'Search sessions or speakers';

  @override
  String get errorSearch => 'No results found';

  @override
  String day(int day) {
    return 'Day $day';
  }

  @override
  String get mySessions => 'My Sessions';

  @override
  String get allSessions => 'All Sessions';

  @override
  String get areYouSureLogOut => 'Are you sure\nyou want to log out?';

  @override
  String get logoutDesc =>
      'Logging out will end your current session. You can always log back in to pick up right where you left off.';

  @override
  String get logoutLoading => 'logging out...';

  @override
  String get confirmLogout => 'yes, log out';

  @override
  String get noSessions => 'No sessions found';

  @override
  String get noPosts => 'No posts found';
}
