class AppException implements Exception {
  AppException([
    this.message = '',
    this.debugString = '',
  ]);

  /// This MUST be a user friendly error message
  final String message;

  final String debugString;

  @override
  String toString() {
    return '$message $debugString';
  }
}
