const ERROR_MSG = "Common msg error";

class Failure {
  const Failure({this.message = ERROR_MSG});

  final String message;

  @override
  String toString() {
    return message;
  }
}
