import 'package:injectable/injectable.dart';

class Environments {
  static const String dev = 'dev';
  static const String uat = 'uat';
  static const String prod = 'prod';
}

const dummy = Environment(Environments.dev);
