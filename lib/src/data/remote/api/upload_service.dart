import 'dart:io';

import 'package:dio/dio.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/listing_photo.dart';
import 'package:retrofit/retrofit.dart';

part 'upload_service.g.dart';

@RestApi()
abstract class UploadService {
  factory UploadService(Dio dio, {required String baseUrl}) = _UploadService;

  @POST("?type=propzy-app")
  @MultiPart()
  Future<BaseResponse<ListingLinkMedia>> uploadImage(
    @Part(name: 'file') File file,
  );
}
