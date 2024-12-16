import 'failure.dart';

class ApiFailure extends Failure {
  final int statusCode;
  final String serverResponseBody;

  const ApiFailure({
    required String message,
    required this.statusCode,
    required this.serverResponseBody,
  }) : super(message: message);

  @override
  List<Object?> get props => [message, statusCode, serverResponseBody];
}
