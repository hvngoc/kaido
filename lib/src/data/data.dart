import 'package:propzy_home/src/data/di/locator.dart';

class Data {
  static Future init() async {
    await setupDataLocator();
  }
}
