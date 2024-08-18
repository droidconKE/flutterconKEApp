import 'package:fluttercon/common/data/models/feed.dart';
import 'package:fluttercon/common/data/models/local/local_feed.dart';
import 'package:fluttercon/common/data/models/local/local_speaker.dart';
import 'package:fluttercon/common/data/models/speaker.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

@singleton
class LocalDatabaseRepository {
  Future<Isar> init() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    return Isar.open(
      [
        LocalFeedEntrySchema,
        LocalSpeakerSchema,
      ],
      directory: dir.path,
    );
  }

  Future<void> clearAllTables() async {
    await localDB.writeTxn(() async {
      await localDB.clear();
    });
  }

  Future<void> persistLocalFeedEntries({
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

  Future<List<LocalFeedEntry>> fetchLocalFeedEntries() async {
    return localDB.localFeedEntrys.where().findAll();
  }

  Future<void> persistLocalSpeakers({
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

  Future<List<LocalSpeaker>> fetchLocalSpeakers() async {
    return localDB.localSpeakers.where().findAll();
  }
}
