import 'package:propzy_home/src/data/model/base_response.dart';

abstract class CommonRepository {
  Future<BaseResponse> checkUpdateVersion();
}