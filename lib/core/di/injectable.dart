import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttercon/core/di/injectable.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'initGetIt',
  generateForDir: ['lib'],
)
Future<void> configureDependencies() async {
  await getIt.initGetIt();
  await getIt.allReady();
}

@module
abstract class RegisterModule {
  @singleton
  @preResolve
  Future<SharedPreferences> prefs() => SharedPreferences.getInstance();

  @singleton
  Dio dio() => Dio();
}

dynamic _parseAndDecode(String response) => jsonDecode(response);

dynamic parseJson(String text) =>
    compute<String, dynamic>(_parseAndDecode, text);
