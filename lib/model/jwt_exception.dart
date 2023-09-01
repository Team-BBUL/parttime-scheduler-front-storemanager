class JWTException implements Exception {
  final String? message;

  JWTException(this.message);

  @override
  String toString() {
    return message ?? 'LoginException';
  }
}