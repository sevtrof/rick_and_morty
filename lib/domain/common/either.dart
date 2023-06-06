class Either<F, S> {
  final F? failure;
  final S? success;

  Either({this.failure, this.success});

  T fold<T>(T Function(F) failureCase, T Function(S) successCase) {
    if (failure != null) {
      return failureCase(failure!);
    } else if (success != null) {
      return successCase(success!);
    }

    throw StateError('Either should contain a failure or success case');
  }
}