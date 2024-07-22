
class FirebaseeException implements Exception {
  final String message;

  FirebaseeException(this.message);

  @override
  String toString() {
    return 'FirebaseException: $message';
  }
}
