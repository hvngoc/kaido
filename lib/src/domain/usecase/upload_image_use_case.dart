import 'dart:io';

import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/listing_photo.dart';
import 'package:propzy_home/src/domain/repository/upload_repository.dart';

class UploadImageUseCase {
  late final UploadRepository _repository;

  UploadImageUseCase(this._repository);

  Future<BaseResponse<ListingLinkMedia>> uploadImage(File file) {
    return _repository.uploadImage(file);
  }
}