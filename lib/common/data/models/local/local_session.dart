import 'package:hive_ce/hive.dart';

part 'local_session.g.dart';

@HiveType(typeId: 6)
class LocalSession extends HiveObject {
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

  @HiveField(0)
  late int serverId;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String description;
  @HiveField(3)
  late String slug;
  @HiveField(4)
  late String sessionCategory;
  @HiveField(5)
  late String sessionFormat;
  @HiveField(6)
  late DateTime startDateTime;
  @HiveField(7)
  late DateTime endDateTime;
  @HiveField(8)
  late String startTime;
  @HiveField(9)
  late String endTime;
  @HiveField(10)
  late String sessionLevel;
  @HiveField(11)
  late bool isKeynote;
  @HiveField(12)
  late bool isBookmarked;
  @HiveField(13)
  late bool isServiceSession;
  @HiveField(14)
  late String sessionImage;
  @HiveField(15)
  late List<EmbeddedSpeaker> speakers;
  @HiveField(16)
  late List<LocalRoom> rooms;
}

@HiveType(typeId: 7)
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

  @HiveField(0)
  String? name;
  @HiveField(1)
  String? biography;
  @HiveField(2)
  String? avatar;
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

@HiveType(typeId: 8)
class LocalRoom {
  LocalRoom({this.title, this.id});

  @HiveField(0)
  int? id;
  @HiveField(1)
  String? title;
}
