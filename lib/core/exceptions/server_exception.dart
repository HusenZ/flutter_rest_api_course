class ServerException implements Exception {
  final String message;

  ServerException(
      [this.message =
          'An error occurred while communicating with the server.']);

  @override
  String toString() => 'ServerException: $message';
}
