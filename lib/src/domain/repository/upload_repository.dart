import 'dart:io';

import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/listing_photo.dart';

abstract class UploadRepository {
  Future<BaseResponse<ListingLinkMedia>> uploadImage(
    File file,
  );
}
