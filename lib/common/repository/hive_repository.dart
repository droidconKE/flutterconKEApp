import 'package:flutter/material.dart';
import 'package:fluttercon/common/data/models/adapters.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/utils/env/flavor_config.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@singleton
class HiveRepository {
  Future<void> initBoxes() async {
    await Hive.initFlutter();

    Hive
      ..registerAdapter(FlutterConUserAdapter())
      ..registerAdapter(FlutterConSessionAdapter());

    await Hive.openBox<dynamic>(FlutterConConfig.instance!.values.hiveBox);
  }

  void clearPrefs() {
    Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox)
        .deleteAll(<String>[
      'accessToken',
      'profile',
      'sessions',
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

  void persistUser(FlutterConUser user) {
    Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox)
        .put('profile', user);
  }

  FlutterConUser? retrieveUser() {
    return Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox)
        .get('profile') as FlutterConUser?;
  }

  void persistThemeMode(ThemeMode themeMode) {
    Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox)
        .put('themeMode', themeMode.toString());
  }

  ThemeMode retrieveThemeMode() {
    final themeMode =
        Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox)
            .get('themeMode') as String?;

    if (themeMode == null) {
      return ThemeMode.light;
    }

    return ThemeMode.values.firstWhere(
      (element) => element.toString() == themeMode,
      orElse: () => ThemeMode.system,
    );
  }

  void persistSessions({
    required List<Session> sessions,
  }) {
    Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox)
        .put('sessions', SessionResponse(data: sessions));
  }

  bool hasSessions() {
    final sessions =
        Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox)
            .get('sessions') as SessionResponse?;
    if (sessions == null) return false;
    return sessions.data.isNotEmpty;
  }

  List<Session> retrieveSessions({
    String? sessionLevel,
    String? sessionType,
  }) {
    final sessions =
        Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox)
            .get('sessions') as SessionResponse?;

    if (sessions == null) {
      return <Session>[];
    }

    if (sessionLevel == null && sessionType == null) {
      return sessions.data;
    }

    return sessions.data.where((session) {
      if (sessionLevel != null && sessionType != null) {
        return session.sessionLevel == sessionLevel &&
            session.sessionFormat == sessionType;
      } else if (sessionLevel != null) {
        return session.sessionLevel == sessionLevel;
      } else {
        return session.sessionFormat == sessionType;
      }
    }).toList();
  }
}
