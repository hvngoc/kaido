import 'package:propzy_home/src/domain/di/locator.dart';

class Domain {
  static Future init() async {
    setupDomainLocator();
  }
}
