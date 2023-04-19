import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/config/app_config.dart';

final locator = GetIt.instance..allowReassignment = true;

void setupLocator(Environment environment) {
  locator.registerSingleton(AppConfig(environment));
}
