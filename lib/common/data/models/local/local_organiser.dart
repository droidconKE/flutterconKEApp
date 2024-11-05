import 'package:isar/isar.dart';

part 'local_organiser.g.dart';

@collection
class LocalOrganiser {
  LocalOrganiser({
    required this.logo,
    required this.name,
  });

  Id id = Isar.autoIncrement;
  
  late String logo;
  @Index(unique: true, replace: true)
  
  late String name;
}
