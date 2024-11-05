import 'package:isar/isar.dart';

part 'local_organiser.g.dart';

@collection
class LocalOrganiser {
  LocalOrganiser({
    required this.logo,
    required this.name,
    required this.type,
    required this.tagline,
    required this.bio,
  });

  Id id = Isar.autoIncrement;
  
  late String logo;
  @Index(unique: true, replace: true)
  
  late String name;
  late String type;
  @Enumerated(EnumType.name)
  late String tagline;
  late String bio;
}
