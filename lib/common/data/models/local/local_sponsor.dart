import 'package:isar/isar.dart';

part 'local_sponsor.g.dart';

@collection
class LocalSponsor {
  LocalSponsor({
    required this.name,
    required this.tagline,
    required this.link,
    required this.sponsorType,
    required this.logo,
    required this.createdAt,
  });

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String name;
  late String tagline;
  late String link;
  late String sponsorType;
  late String logo;
  late String createdAt;
}
