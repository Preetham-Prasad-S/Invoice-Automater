import 'package:app_prototype/app/app.dart';
import 'package:app_prototype/app/bootstrap.dart';

void main() async {
  await bootstrap(() async => const App());
}
