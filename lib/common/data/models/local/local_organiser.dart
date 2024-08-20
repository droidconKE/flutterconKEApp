import 'package:isar/isar.dart';

part 'local_organiser.g.dart';

@collection
class LocalOrganiser {
  LocalOrganiser({
    required this.serverId,
    required this.logo,
    required this.name,
  });

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late int serverId;
  late String logo;
  late String name;
}
