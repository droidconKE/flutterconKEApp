import 'package:fluttercon/core/di/injectable.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

final getIt = GetIt.instance;
late Isar localDB;

@InjectableInit(initializerName: 'initGetIt', generateForDir: ['lib'])
Future<void> configureDependencies() async {
  getIt.initGetIt();
  await getIt.allReady();
}

@module
abstract class RegisterModule {}
