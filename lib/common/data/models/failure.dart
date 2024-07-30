class Failure implements Exception {
  Failure({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;
}
