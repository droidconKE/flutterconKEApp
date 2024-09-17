import 'package:fluttercon/common/data/enums/bookmark_status.dart';
import 'package:fluttercon/common/data/models/feed.dart';
import 'package:fluttercon/common/data/models/individual_organiser.dart';
import 'package:fluttercon/common/data/models/local/local_feed.dart';
import 'package:fluttercon/common/data/models/local/local_individual_organiser.dart';
import 'package:fluttercon/common/data/models/local/local_organiser.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/data/models/local/local_speaker.dart';
import 'package:fluttercon/common/data/models/local/local_sponsor.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/data/models/sponsor.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

@singleton
class DBRepository {
  Future<Isar> init() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    return Isar.open(
      [
        LocalFeedEntrySchema,
        LocalSpeakerSchema,
        LocalOrganiserSchema,
        LocalIndividualOrganiserSchema,
        LocalSponsorSchema,
        LocalSessionSchema,
      ],
      directory: dir.path,
    );
  }

  Future<void> clearAllTables() async {
    await localDB.writeTxn(() async {
      await localDB.clear();
    });
  }

  Future<void> persistFeedEntries({
    required List<Feed> entries,
  }) async {
    await localDB.writeTxn(() async {
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

      await localDB.localFeedEntrys.putAll(localFeedEntries);
    });
  }

  Future<List<LocalFeedEntry>> fetchFeedEntries() async {
    return localDB.localFeedEntrys.where().findAll();
  }

  Future<void> persistSpeakers({
    required List<Speaker> speakers,
  }) async {
    await localDB.writeTxn(() async {
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

      await localDB.localSpeakers.putAll(localSpeakers);
    });
  }

  Future<List<LocalSpeaker>> fetchSpeakers() async {
    return localDB.localSpeakers.where().findAll();
  }

  Future<void> persistOrganisers({
    required List<Organiser> organisers,
  }) async {
    await localDB.writeTxn(() async {
      final localOrganisers = <LocalOrganiser>[];

      for (final organiser in organisers) {
        localOrganisers.add(
          LocalOrganiser(
            name: organiser.name,
            serverId: organiser.id,
            logo: organiser.logo,
          ),
        );
      }

      await localDB.localOrganisers.putAll(localOrganisers);
    });
  }

  Future<List<LocalOrganiser>> fetchOrganisers() async {
    return localDB.localOrganisers.where().findAll();
  }

  Future<void> persistIndividualOrganisers({
    required List<IndividualOrganiser> organisers,
  }) async {
    await localDB.writeTxn(() async {
      final localIndividualOrganisers = <LocalIndividualOrganiser>[];

      for (final organiser in organisers) {
        localIndividualOrganisers.add(
          LocalIndividualOrganiser(
            name: organiser.name,
            tagline: organiser.tagline,
            link: organiser.link,
            type: organiser.type,
            bio: organiser.bio,
            designation: organiser.designation,
            photo: organiser.photo,
            twitterHandle: organiser.twitterHandle,
          ),
        );
      }

      await localDB.localIndividualOrganisers.putAll(localIndividualOrganisers);
    });
  }

  Future<List<LocalIndividualOrganiser>> fetchIndividualOrganisers() async {
    return localDB.localIndividualOrganisers.where().findAll();
  }

  Future<void> persistSponsors({
    required List<Sponsor> sponsors,
  }) async {
    await localDB.writeTxn(() async {
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

      await localDB.localSponsors.putAll(localSponsors);
    });
  }

  Future<List<LocalSponsor>> fetchSponsors() async {
    return localDB.localSponsors.where().findAll();
  }

  Future<void> persistSessions({
    required List<Session> sessions,
  }) async {
    await localDB.writeTxn(() async {
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
            speakers: session.speakers
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
            rooms: session.rooms
                .map(
                  (room) => LocalRoom(
                    title: room.title,
                    id: room.id,
                  ),
                )
                .toList(),
          ),
        );
      }

      await localDB.localSessions.putAll(localSessions);
    });
  }

  Future<List<LocalSession>> fetchSessions({
    BookmarkStatus? bookmarkStatus,
    String? sessionLevel,
    String? sessionType,
  }) async {
    return localDB.localSessions
        .where()
        .filter()
        .optional(
          bookmarkStatus != null,
          (q) => q
              .isBookmarkedEqualTo(bookmarkStatus == BookmarkStatus.bookmarked),
        )
        .optional(
          sessionLevel != null,
          (q) => q.sessionLevelEqualTo(sessionLevel!),
        )
        .optional(
          sessionType != null,
          (q) => q.sessionFormatEqualTo(sessionType!),
        )
        .findAll();
  }

  bool hasSessions() {
    return localDB.localSessions.where().countSync() > 0;
  }

  Future<void> updateSession({
    required int sessionId,
    bool? bookmarkStatus,
  }) async {
    await localDB.writeTxn(() async {
      final session = await localDB.localSessions
          .where()
          .serverIdEqualTo(sessionId)
          .findFirst();
      if (session == null) return;

      if (bookmarkStatus != null) {
        session.isBookmarked = bookmarkStatus;
      }

      await localDB.localSessions.put(session);
    });
  }

  Future<LocalSession?> getSession(int sessionId) async {
    return localDB.localSessions.where().serverIdEqualTo(sessionId).findFirst();
  }

  Future<List<LocalSession>> searchSessions(String query) async {
    return localDB.localSessions
        .where()
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .descriptionContains(query, caseSensitive: false)
        .findAll();
  }

  Future<List<LocalSpeaker>> searchSpeakers(String query) async {
    return localDB.localSpeakers
        .where()
        .filter()
        .nameContains(query, caseSensitive: false)
        .or()
        .biographyContains(query, caseSensitive: false)
        .or()
        .taglineContains(query, caseSensitive: false)
        .findAll();
  }

  Future<List<LocalIndividualOrganiser>> searchIndividualOrganisers(
    String query,
  ) async {
    return localDB.localIndividualOrganisers
        .where()
        .filter()
        .nameContains(query, caseSensitive: false)
        .or()
        .taglineContains(query, caseSensitive: false)
        .or()
        .bioContains(query, caseSensitive: false)
        .or()
        .designationContains(query, caseSensitive: false)
        .findAll();
  }
}
