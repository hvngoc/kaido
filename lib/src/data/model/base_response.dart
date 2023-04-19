import 'package:json_annotation/json_annotation.dart';
import 'package:propzy_home/src/data/model/force_update_info.dart';

part 'base_response.g.dart';

@JsonSerializable(
    createToJson: false, checked: true, genericArgumentFactories: true)
class BaseResponse<T> {
  bool? result;
  String? code;
  String? message;
  String? messageHtml;
  String? validatedMessage;
  final T? data;
  ForceUpdateInfo? forceUpdateInfo;

  bool isSuccess() {
    return (result == true && code == "200");
  }

  BaseResponse(
      {this.result,
      this.code,
      this.message,
      this.messageHtml,
      this.validatedMessage,
      this.data,
      this.forceUpdateInfo});

  factory BaseResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseResponseFromJson<T>(json, fromJsonT);
}
