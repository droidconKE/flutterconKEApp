import 'package:hive_ce/hive.dart';

part 'local_individual_organiser.g.dart';

@HiveType(typeId: 5)
class LocalIndividualOrganiser extends HiveObject {
  LocalIndividualOrganiser({
    required this.name,
    required this.tagline,
    required this.link,
    required this.type,
    required this.bio,
    required this.designation,
    required this.photo,
    required this.twitterHandle,
  });

  @HiveField(0)
  late String name;
  @HiveField(1)
  late String tagline;
  @HiveField(2)
  late String link;
  @HiveField(3)
  late String type;
  @HiveField(4)
  late String bio;
  @HiveField(5)
  late String designation;
  @HiveField(6)
  late String photo;
  @HiveField(7)
  late String twitterHandle;
}
