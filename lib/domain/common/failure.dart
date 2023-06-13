abstract class Failure {}

class ServerFailure extends Failure {
  final String? message;

  ServerFailure({this.message = ""});
}

class NetworkFailure extends Failure {}

class CacheFailure extends Failure {}