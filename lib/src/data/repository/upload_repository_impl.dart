import 'dart:io';

import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/remote/api/upload_service.dart';
import 'package:propzy_home/src/domain/model/listing_photo.dart';
import 'package:propzy_home/src/domain/repository/upload_repository.dart';

class UploadRepositoryImpl implements UploadRepository {
  final UploadService service;

  UploadRepositoryImpl(this.service);

  @override
  Future<BaseResponse<ListingLinkMedia>> uploadImage(File file) {
    return service.uploadImage(file);
  }
}