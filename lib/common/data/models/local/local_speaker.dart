import 'package:hive_ce/hive.dart';

part 'local_speaker.g.dart';

@HiveType(typeId: 2)
class LocalSpeaker extends HiveObject {
  LocalSpeaker({
    required this.name,
    required this.biography,
    required this.avatar,
    this.tagline,
    this.twitter,
    this.facebook,
    this.linkedin,
    this.instagram,
    this.blog,
    this.companyWebsite,
  });

  @HiveField(0)
  late String name;
  @HiveField(1)
  late String biography;
  @HiveField(2)
  late String avatar;
  @HiveField(3)
  String? tagline;
  @HiveField(4)
  String? twitter;
  @HiveField(5)
  String? facebook;
  @HiveField(6)
  String? linkedin;
  @HiveField(7)
  String? instagram;
  @HiveField(8)
  String? blog;
  @HiveField(9)
  String? companyWebsite;
}
