import 'package:isar/isar.dart';

part 'local_feed.g.dart';

@collection
class LocalFeedEntry {
  LocalFeedEntry({
    required this.title,
    required this.body,
    required this.topic,
    required this.url,
    required this.createdAt,
    required this.image,
  });

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String title;
  late String body;
  late String topic;
  late String url;
  late String image;
  late DateTime createdAt;
}
