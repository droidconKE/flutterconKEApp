import 'package:isar/isar.dart';

part 'local_session.g.dart';

@collection
class LocalSession {
  LocalSession({
    required this.serverId,
    required this.title,
    required this.description,
    required this.slug,
    required this.sessionCategory,
    required this.sessionFormat,
    required this.startDateTime,
    required this.endDateTime,
    required this.startTime,
    required this.endTime,
    required this.sessionLevel,
    required this.isKeynote,
    required this.isBookmarked,
    required this.isServiceSession,
    required this.speakers,
    required this.rooms,
    required this.sessionImage,
  });
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late int serverId;
  late String title;
  late String description;
  late String slug;
  late String sessionCategory;
  late String sessionFormat;
  late DateTime startDateTime;
  late DateTime endDateTime;
  late String startTime;
  late String endTime;
  late String sessionLevel;
  late bool isKeynote;
  late bool isBookmarked;
  late bool isServiceSession;
  late String sessionImage;
  late List<EmbeddedSpeaker> speakers;
  late List<LocalRoom> rooms;
}

@embedded
class EmbeddedSpeaker {
  EmbeddedSpeaker({
    this.name,
    this.biography,
    this.avatar,
    this.tagline,
    this.twitter,
    this.facebook,
    this.linkedin,
    this.instagram,
    this.blog,
    this.companyWebsite,
  });

  String? name;
  String? biography;
  String? avatar;
  String? tagline;
  String? twitter;
  String? facebook;
  String? linkedin;
  String? instagram;
  String? blog;
  String? companyWebsite;
}

@embedded
class LocalRoom {
  LocalRoom({
    this.title,
    this.id,
  });

  int? id;
  String? title;
}
