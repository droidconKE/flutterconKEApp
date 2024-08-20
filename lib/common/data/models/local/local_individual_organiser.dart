import 'package:isar/isar.dart';

part 'local_individual_organiser.g.dart';

@collection
class LocalIndividualOrganiser {
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

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String name;
  late String tagline;
  late String link;
  late String type;
  late String bio;
  late String designation;
  late String photo;
  late String twitterHandle;
}
