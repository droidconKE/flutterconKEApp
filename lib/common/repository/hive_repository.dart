import 'package:fluttercon/common/utils/env/flavor_config.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@singleton
class HiveRepository {
  Future<void> initBoxes() async {
    await Hive.initFlutter();

    // Hive.registerAdapter(SignInDTOAdapter());

    await Hive.openBox<dynamic>(FlutterConConfig.instance!.values.hiveBox);
  }

  void clearPrefs() {
    Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox)
        .deleteAll(<String>[
      'accessToken',
      'profile',
    ]);
  }

  void clearBox() {
    Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox).clear();
  }

  void persistToken(String token) {
    Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox)
        .put('accessToken', token);
  }

  String? retrieveToken() {
    return Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox)
        .get('accessToken') as String?;
  }
}
