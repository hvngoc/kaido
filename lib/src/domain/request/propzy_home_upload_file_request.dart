import 'dart:io';

class PropzyHomeUploadFileRequest {
  File file;
  int? captionId;
  int? offerId;
  int? id;
  int? typeSource;
  int? typeFile;

  PropzyHomeUploadFileRequest({
    required this.file,
    this.captionId,
    this.offerId,
    this.id,
    this.typeSource,
    this.typeFile,
  });
}
