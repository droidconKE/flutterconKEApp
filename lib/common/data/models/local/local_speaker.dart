import 'package:isar/isar.dart';

part 'local_speaker.g.dart';

@collection
class LocalSpeaker {
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

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String name;
  late String biography;
  late String avatar;
  String? tagline;
  String? twitter;
  String? facebook;
  String? linkedin;
  String? instagram;
  String? blog;
  String? companyWebsite;
}
