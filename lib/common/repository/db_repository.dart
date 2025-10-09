import 'package:fluttercon/common/data/enums/bookmark_status.dart';
import 'package:fluttercon/common/data/enums/organiser_type.dart';
import 'package:fluttercon/common/data/models/feed.dart';
import 'package:fluttercon/common/data/models/local/local_feed.dart';
import 'package:fluttercon/common/data/models/local/local_individual_organiser.dart';
import 'package:fluttercon/common/data/models/local/local_organiser.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/data/models/local/local_speaker.dart';
import 'package:fluttercon/common/data/models/local/local_sponsor.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/data/models/sponsor.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

@singleton
class DBRepository {
  late Box<LocalFeedEntry> _feedBox;
  late Box<LocalSpeaker> _speakerBox;
  late Box<LocalOrganiser> _organiserBox;
  late Box<LocalIndividualOrganiser> _individualOrganiserBox;
  late Box<LocalSponsor> _sponsorBox;
  late Box<LocalSession> _sessionBox;

  Future<void> init() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    Hive..init(dir.path)

    // Register adapters
    
      ..registerAdapter(LocalFeedEntryAdapter())
      ..registerAdapter(LocalSpeakerAdapter())
      ..registerAdapter(LocalOrganiserAdapter())
      ..registerAdapter(LocalIndividualOrganiserAdapter())
      ..registerAdapter(LocalSponsorAdapter())
      ..registerAdapter(LocalSessionAdapter())
      ..registerAdapter(EmbeddedSpeakerAdapter())
      ..registerAdapter(LocalRoomAdapter());

    // Open boxes
    _feedBox = await Hive.openBox<LocalFeedEntry>('feedEntries');
    _speakerBox = await Hive.openBox<LocalSpeaker>('speakers');
    _organiserBox = await Hive.openBox<LocalOrganiser>('organisers');
    _individualOrganiserBox = await Hive.openBox<LocalIndividualOrganiser>(
      'individualOrganisers',
    );
    _sponsorBox = await Hive.openBox<LocalSponsor>('sponsors');
    _sessionBox = await Hive.openBox<LocalSession>('sessions');
  }

  Future<void> clearAllTables() async {
    await _feedBox.clear();
    await _speakerBox.clear();
    await _organiserBox.clear();
    await _individualOrganiserBox.clear();
    await _sponsorBox.clear();
    await _sessionBox.clear();
  }

  Future<void> persistFeedEntries({required List<Feed> entries}) async {
    final localFeedEntries = <LocalFeedEntry>[];

    for (final entry in entries) {
      localFeedEntries.add(
        LocalFeedEntry(
          title: entry.title,
          body: entry.body,
          topic: entry.topic,
          url: entry.url,
          createdAt: entry.createdAt,
          image: entry.image,
        ),
      );
    }

    await _feedBox.addAll(localFeedEntries);
  }

  Future<List<LocalFeedEntry>> fetchFeedEntries() async {
    return _feedBox.values.toList();
  }

  Future<void> persistSpeakers({required List<Speaker> speakers}) async {
    final localSpeakers = <LocalSpeaker>[];

    for (final speaker in speakers) {
      localSpeakers.add(
        LocalSpeaker(
          name: speaker.name,
          biography: speaker.biography,
          avatar: speaker.avatar,
          tagline: speaker.tagline,
          twitter: speaker.twitter,
          facebook: speaker.facebook,
          linkedin: speaker.linkedin,
          instagram: speaker.instagram,
          blog: speaker.blog,
          companyWebsite: speaker.companyWebsite,
        ),
      );
    }

    await _speakerBox.addAll(localSpeakers);
  }

  Future<List<LocalSpeaker>> fetchSpeakers() async {
    return _speakerBox.values.toList();
  }

  Future<void> persistOrganisers({required List<Organiser> organisers}) async {
    final localOrganisers = <LocalOrganiser>[];

    for (final organiser in organisers) {
      localOrganisers.add(
        LocalOrganiser(
          name: organiser.name,
          logo: organiser.logo,
          tagline: organiser.tagline,
          type: organiser.type,
          bio: organiser.bio,
          designation: organiser.designation,
        ),
      );
    }

    await _organiserBox.addAll(localOrganisers);
  }

  Future<List<LocalOrganiser>> fetchOrganisers({
    required OrganiserType type,
  }) async {
    return _organiserBox.values
        .where(
          (org) =>
              org.type == type.name && !org.name.contains('Nairobi Gophers'),
        )
        .toList();
  }

  Future<void> persistSponsors({required List<Sponsor> sponsors}) async {
    final localSponsors = <LocalSponsor>[];

    for (final sponsor in sponsors) {
      localSponsors.add(
        LocalSponsor(
          name: sponsor.name,
          logo: sponsor.logo,
          tagline: sponsor.tagline,
          link: sponsor.link,
          sponsorType: sponsor.sponsorType,
          createdAt: sponsor.createdAt,
        ),
      );
    }

    await _sponsorBox.addAll(localSponsors);
  }

  Future<List<LocalSponsor>> fetchSponsors() async {
    return _sponsorBox.values.toList();
  }

  Future<void> persistSessions({required List<Session> sessions}) async {
    final localSessions = <LocalSession>[];

    for (final session in sessions) {
      localSessions.add(
        LocalSession(
          serverId: session.id,
          title: session.title,
          description: session.description,
          startTime: session.startTime,
          endTime: session.endTime,
          startDateTime: session.startDateTime,
          endDateTime: session.endDateTime,
          slug: session.slug,
          sessionCategory: session.sessionCategory,
          sessionFormat: session.sessionFormat,
          sessionLevel: session.sessionLevel,
          isKeynote: session.isKeynote,
          isBookmarked: session.isBookmarked,
          isServiceSession: session.isServiceSession,
          sessionImage: session.sessionImage,
          speakers:
              session.speakers
                  .map(
                    (speaker) => EmbeddedSpeaker(
                      name: speaker.name,
                      biography: speaker.biography,
                      avatar: speaker.avatar,
                      tagline: speaker.tagline,
                      twitter: speaker.twitter,
                      facebook: speaker.facebook,
                      linkedin: speaker.linkedin,
                      instagram: speaker.instagram,
                      blog: speaker.blog,
                      companyWebsite: speaker.companyWebsite,
                    ),
                  )
                  .toList(),
          rooms:
              session.rooms
                  .map((room) => LocalRoom(title: room.title, id: room.id))
                  .toList(),
        ),
      );
    }

    await _sessionBox.addAll(localSessions);
  }

  Future<List<LocalSession>> fetchSessions({
    BookmarkStatus? bookmarkStatus,
    String? sessionLevel,
    String? sessionType,
  }) async {
    var sessions = _sessionBox.values;

    if (bookmarkStatus != null) {
      sessions = sessions.where(
        (s) => s.isBookmarked == (bookmarkStatus == BookmarkStatus.bookmarked),
      );
    }

    if (sessionLevel != null) {
      sessions = sessions.where((s) => s.sessionLevel == sessionLevel);
    }

    if (sessionType != null) {
      sessions = sessions.where((s) => s.sessionFormat == sessionType);
    }

    return sessions.toList();
  }

  bool hasSessions() {
    return _sessionBox.isNotEmpty;
  }

  Future<void> updateSession({
    required int sessionId,
    bool? bookmarkStatus,
  }) async {
    final session = _sessionBox.values.firstWhere(
      (s) => s.serverId == sessionId,
      orElse: () => throw Exception('Session not found'),
    );

    if (bookmarkStatus != null) {
      session.isBookmarked = bookmarkStatus;
      await session.save();
    }
  }

  Future<LocalSession?> getSession(int sessionId) async {
    try {
      return _sessionBox.values.firstWhere((s) => s.serverId == sessionId);
    } catch (e) {
      return null;
    }
  }

  Future<List<LocalSession>> searchSessions(String query) async {
    final lowerQuery = query.toLowerCase();
    return _sessionBox.values
        .where(
          (session) =>
              session.title.toLowerCase().contains(lowerQuery) ||
              session.description.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  Future<List<LocalSpeaker>> searchSpeakers(String query) async {
    final lowerQuery = query.toLowerCase();
    return _speakerBox.values
        .where(
          (speaker) =>
              speaker.name.toLowerCase().contains(lowerQuery) ||
              speaker.biography.toLowerCase().contains(lowerQuery) ||
              (speaker.tagline?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .toList();
  }

  Future<List<LocalIndividualOrganiser>> searchIndividualOrganisers(
    String query,
  ) async {
    final lowerQuery = query.toLowerCase();
    return _individualOrganiserBox.values
        .where(
          (organiser) =>
              organiser.name.toLowerCase().contains(lowerQuery) ||
              organiser.tagline.toLowerCase().contains(lowerQuery) ||
              organiser.bio.toLowerCase().contains(lowerQuery) ||
              organiser.designation.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }
}
