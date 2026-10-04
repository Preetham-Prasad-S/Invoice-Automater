abstract class UseCase<In, Out> {
  Future<Out> call(In params);
}
