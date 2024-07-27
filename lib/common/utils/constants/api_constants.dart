class ApiConstants {
  ApiConstants._();
  static const Duration receiveTimeout = Duration(milliseconds: 15000);
  static const Duration connectionTimeout = Duration(milliseconds: 15000);
  static const String users = '/users';
  static const String posts = '/posts';
  static const String comments = '/comments';
  static const String todos = '/todos';
  static const headers = {
    'content-Type': 'application/json',
  };

  //Api call error
  static const cancelRequest = 'Request to API server was cancelled';
  static const connectionTimeOut = 'Connection timeout with API server';
  static const receiveTimeOut = 'Receive timeout in connection with API server';
  static const sendTimeOut = 'Send timeout in connection with API server';
  static const socketException = 'Check your internet connection';
  static const unknownError = 'Something went wrong';
  static const duplicateEmail = 'Email has already been taken';

  //Status code
  static const badRequest = 'Bad request';
  static const unauthorized = 'Unauthorized';
  static const forbidden = 'Forbidden';
  static const notFound = 'Not found';
  static const internalServerError = 'Internal server error';
  static const badGateway = 'Bad gateway';

  static const appFont = 'Roboto';
}
