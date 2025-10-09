import 'package:hive_ce/hive.dart';

part 'local_organiser.g.dart';

@HiveType(typeId: 4)
class LocalOrganiser extends HiveObject {
  LocalOrganiser({
    required this.logo,
    required this.name,
    required this.type,
    required this.tagline,
    required this.bio,
    required this.designation,
  });

  @HiveField(0)
  late String logo;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String type;
  @HiveField(3)
  late String tagline;
  @HiveField(4)
  late String bio;
  @HiveField(5)
  late String designation;
}
