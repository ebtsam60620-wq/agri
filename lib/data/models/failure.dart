class Failure {
  Failure(this.message, this.error, [this.stackTrace]);
  final String message;
  final String error;

  final StackTrace? stackTrace;
}
