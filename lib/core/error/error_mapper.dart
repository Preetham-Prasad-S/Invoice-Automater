import 'exception.dart';
import 'failure.dart';

class ErrorMapper {
  static Failure map(Exception e) {
    if (e is ServerException) return ServerFailure(e.message);
    if (e is NetworkException) return NetworkFailure(e.message);
    if (e is CacheException) return CacheFailure(e.message);
    if (e is ValidationException) return ValidationFailure(e.message);
    return UnknownFailure(e.toString());
  }
}
