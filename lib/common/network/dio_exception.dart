import 'package:dio/dio.dart' show DioException, DioExceptionType;

import 'package:fluttercon/common/utils/constants/api_constants.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioException dioException) {
    message = switch (dioException.type) {
      DioExceptionType.cancel => ApiConstants.cancelRequest,
      DioExceptionType.connectionTimeout => ApiConstants.connectionTimeOut,
      DioExceptionType.receiveTimeout => ApiConstants.receiveTimeOut,
      DioExceptionType.badResponse => _handleError(
          dioException.response?.statusCode,
          dioException.response?.data,
        ),
      DioExceptionType.sendTimeout => ApiConstants.sendTimeOut,
      DioExceptionType.connectionError => ApiConstants.socketException,
      DioExceptionType.badCertificate ||
      DioExceptionType.unknown =>
        ApiConstants.unknownError,
    };
  }

  late String message;

  String _handleError(int? statusCode, dynamic error) {
    return switch (statusCode) {
      400 => ApiConstants.badRequest,
      401 => ApiConstants.unauthorized,
      403 => ApiConstants.forbidden,
      404 => ApiConstants.notFound,
      422 => ApiConstants.duplicateEmail,
      500 => ApiConstants.internalServerError,
      502 => ApiConstants.badGateway,
      _ => ApiConstants.unknownError
    };
  }

  @override
  String toString() => message;
}
