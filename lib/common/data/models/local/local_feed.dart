import 'package:hive_ce/hive.dart';

part 'local_feed.g.dart';

@HiveType(typeId: 1)
class LocalFeedEntry extends HiveObject {
  LocalFeedEntry({
    required this.title,
    required this.body,
    required this.topic,
    required this.url,
    required this.createdAt,
    required this.image,
  });

  @HiveField(0)
  late String title;
  @HiveField(1)
  late String body;
  @HiveField(2)
  late String topic;
  @HiveField(3)
  late String url;
  @HiveField(4)
  late String image;
  @HiveField(5)
  late DateTime createdAt;
}
