class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure(code: $code, message: $message)';
}
