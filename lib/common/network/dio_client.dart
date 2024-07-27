import 'package:dio/dio.dart' show Dio, ResponseType;
import 'package:fluttercon/common/network/dio_interceptor.dart';
import 'package:fluttercon/common/utils/constants/api_constants.dart';
import 'package:fluttercon/common/utils/env/flavor_config.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DioClient {
  DioClient(this.dio) {
    dio
      ..options.baseUrl = FlutterConConfig.instance!.values.baseUrl
      ..options.headers = ApiConstants.headers
      ..options.connectTimeout = ApiConstants.connectionTimeout
      ..options.receiveTimeout = ApiConstants.receiveTimeout
      ..options.responseType = ResponseType.json
      ..interceptors.add(DioInterceptor());
  }
  final Dio dio;
}
