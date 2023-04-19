import 'package:propzy_home/src/config/injection.dart';

import 'app_config.dart';

class Core {
  static void init(Environment environment) {
    setupLocator(environment);
  }
}
