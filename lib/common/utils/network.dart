import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
import 'package:fluttercon/common/utils/env/flavor_config.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkUtil {
  factory NetworkUtil() => _networkUtil;

  NetworkUtil._internal();

  static final NetworkUtil _networkUtil = NetworkUtil._internal();

  final _logger = Logger();

  Dio _getHttpClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: '${FlutterConConfig.instance!.values.baseUrl}/v1',
        contentType: 'application/json',
        headers: <String, dynamic>{
          'Accept': 'application/json',
          'Api-Authorization-Key': 'droidconKe-2020',
        },
        connectTimeout: const Duration(seconds: 60 * 1000),
        receiveTimeout: const Duration(seconds: 60 * 1000),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Authorization'] =
              'Bearer ${getIt<HiveRepository>().retrieveToken() ?? ''}';
          return handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ),
      );
    }

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
        () => HttpClient()..badCertificateCallback = (_, __, ___) => true;
    return dio;
  }

  Future<Map<String, dynamic>> getReq(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _getHttpClient().get<dynamic>(
        url,
        queryParameters: queryParameters,
      );

      final responseBody = response.data as Map<String, dynamic>;

      if (responseBody.isEmpty) {
        throw Failure(message: 'An error occured, please try again later');
      }

      return responseBody;
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Session timeout');
    } on DioException catch (err) {
      _logger
        ..d('Error: $err')
        ..i('${err.response?.statusCode}')
        ..i('Error: ${err.response?.data}');

      if (err.response?.statusCode == 401) {
        throw Failure(
          message: 'Session timeout',
        );
      }

      if (err.response?.statusCode == 404) {
        throw Failure(
          message: 'Not found',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 500) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (DioExceptionType.unknown == err.type) {
        _logger
          ..d('Error: $err')
          ..i('${err.response?.statusCode}')
          ..i('Error: ${err.response?.data}');
        throw Exception('Server error');
      } else if (DioExceptionType.connectionTimeout == err.type) {
        throw const SocketException('No internet connection');
      } else if (DioExceptionType.connectionError == err.type) {
        throw const SocketException('No Internet Connection');
      }
      throw Exception('Server error');
    }
  }

  Future<Map<String, dynamic>> postReq(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _getHttpClient().post<dynamic>(
        url,
        data: json.encode(body),
        queryParameters: queryParameters,
      );

      final responseBody = response.data as Map<String, dynamic>;

      Logger().i(responseBody);

      if (responseBody.isEmpty) {
        throw Failure(message: 'An error occured, please try again later');
      }

      return responseBody;
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Session timeout');
    } on DioException catch (err) {
      _logger
        ..d('Error: $err')
        ..i('${err.response?.statusCode}')
        ..i('Error: ${err.response?.data}');

      if (err.response?.statusCode == 401) {
        throw Failure(
          message: 'Session timeout',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 404) {
        throw Failure(
          message: 'Not found',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 422) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 500) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (DioExceptionType.unknown == err.type) {
        _logger
          ..d('Error: $err')
          ..i('${err.response?.statusCode}')
          ..i('Error: ${err.response?.data}');
        throw Exception('Server error');
      } else if (DioExceptionType.connectionTimeout == err.type) {
        throw const SocketException('No internet connection');
      } else if (DioExceptionType.connectionError == err.type) {
        throw const SocketException('No Internet Connection');
      }
      throw Exception('Server error');
    }
  }

  Future<Map<String, dynamic>> putReq(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _getHttpClient().put<dynamic>(
        url,
        data: json.encode(body),
        queryParameters: queryParameters,
      );

      final responseBody = response.data as Map<String, dynamic>;

      Logger().i(responseBody);

      if (responseBody.isEmpty) {
        throw Failure(message: 'An error occured, please try again later');
      }

      return responseBody;
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Session timeout');
    } on DioException catch (err) {
      _logger
        ..d('Error: $err')
        ..i('${err.response?.statusCode}')
        ..i('Error: ${err.response?.data}');

      if (err.response?.statusCode == 401) {
        throw Failure(
          message: 'Session timeout',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 404) {
        throw Failure(
          message: 'Not found',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 422) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 500) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (DioExceptionType.unknown == err.type) {
        _logger
          ..d('Error: $err')
          ..i('${err.response?.statusCode}')
          ..i('Error: ${err.response?.data}');
        throw Exception('Server error');
      } else if (DioExceptionType.connectionTimeout == err.type) {
        throw const SocketException('No internet connection');
      } else if (DioExceptionType.connectionError == err.type) {
        throw const SocketException('No Internet Connection');
      }
      throw Exception('Server error');
    }
  }

  Future<Map<String, dynamic>> postWithFormData(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    String? filePath,
    String? field,
  }) async {
    try {
      final response = await _getHttpClient().post<dynamic>(
        url,
        data: FormData.fromMap(<String, dynamic>{
          if (field != null && filePath != null)
            field: await MultipartFile.fromFile(filePath),
          ...?body,
        }),
        queryParameters: queryParameters,
      );

      final responseBody = response.data as Map<String, dynamic>;

      Logger().i(responseBody);

      if (responseBody.isEmpty) {
        throw Failure(message: 'An error occured, please try again later');
      }

      return responseBody;
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Session timeout');
    } on DioException catch (err) {
      _logger
        ..d('Error: $err')
        ..i('${err.response?.statusCode}')
        ..i('Error: ${err.response?.data}');

      if (err.response?.statusCode == 401) {
        throw Failure(
          message: 'Session timeout',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 404) {
        throw Failure(
          message: 'Not found',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 422) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 500) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (DioExceptionType.unknown == err.type) {
        _logger
          ..d('Error: $err')
          ..i('${err.response?.statusCode}')
          ..i('Error: ${err.response?.data}');
        throw Exception('Server error');
      } else if (DioExceptionType.connectionTimeout == err.type) {
        throw const SocketException('No internet connection');
      } else if (DioExceptionType.connectionError == err.type) {
        throw const SocketException('No Internet Connection');
      }
      throw Exception('Server error');
    }
  }
}
