sealed class Result<T, E extends Exception> {}

class Success<T, E extends Exception> extends Result<T, E> {
  final T value;
  Success(this.value);
}

class FailureResult<T, E extends Exception> extends Result<T, E> {
  final E error;
  FailureResult(this.error);
}
