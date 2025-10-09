import 'package:fluttercon/common/data/enums/sponsor_type.dart';
import 'package:hive_ce/hive.dart';

part 'local_sponsor.g.dart';

@HiveType(typeId: 3)
class LocalSponsor extends HiveObject {
  LocalSponsor({
    required this.name,
    required this.tagline,
    required this.link,
    required this.sponsorType,
    required this.logo,
    required this.createdAt,
  });

  @HiveField(0)
  late String name;
  @HiveField(1)
  late String tagline;
  @HiveField(2)
  late String link;
  @HiveField(3)
  late SponsorType sponsorType;
  @HiveField(4)
  late String logo;
  @HiveField(5)
  late String createdAt;
}
