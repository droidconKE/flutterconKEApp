import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fluttercon/common/data/models/remote_config.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseRepository {
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await remoteConfig.fetchAndActivate();
  }

  RemoteConfig getConfig() {
    final config = remoteConfig.getValue('dev_flutterconke_fluttercon');

    return RemoteConfig.fromJson(
      json.decode(
        config.asString(),
      ) as Map<String, dynamic>,
    );
  }
}
