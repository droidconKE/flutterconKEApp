import 'package:dio/dio.dart';
import 'package:fluttercon/common/utils/logger.dart';
import 'package:fluttercon/core/app_extension.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final RequestOptions(:baseUrl, :path, :queryParameters) = options;
    logger('====================START====================');
    logger('HTTP method => ${options.method} ');
    logger(
      'Request => $baseUrl$path${queryParameters.format}',
    );
    logger('Header  => ${options.headers}');
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    logger(options.method); // Debug log
    logger('Error: ${err.error}, Message: ${err.message}'); // Error log
    return super.onError(err, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    logger('Response => StatusCode: ${response.statusCode}'); // Debug log
    logger('Response => Body: ${response.data}'); // Debug log
    return super.onResponse(response, handler);
  }
}
