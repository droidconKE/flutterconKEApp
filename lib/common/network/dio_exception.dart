import 'package:dio/dio.dart' show DioException, DioExceptionType;

import '../utils/constants/api_constants.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = ApiConstants.cancelRequest;
        break;
      case DioExceptionType.connectionTimeout:
        message = ApiConstants.connectionTimeOut;
        break;
      case DioExceptionType.receiveTimeout:
        message = ApiConstants.receiveTimeOut;
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
          dioException.response?.statusCode,
          dioException.response?.data,
        );
        break;
      case DioExceptionType.sendTimeout:
        message = ApiConstants.sendTimeOut;
        break;
      case DioExceptionType.connectionError:
        message = ApiConstants.socketException;
        break;
      default:
        message = ApiConstants.unknownError;
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return ApiConstants.badRequest;
      case 401:
        return ApiConstants.unauthorized;
      case 403:
        return ApiConstants.forbidden;
      case 404:
        return ApiConstants.notFound;
      case 422:
        return ApiConstants.duplicateEmail;
      case 500:
        return ApiConstants.internalServerError;
      case 502:
        return ApiConstants.badGateway;
      default:
        return ApiConstants.unknownError;
    }
  }

  @override
  String toString() => message;
}
