import 'package:json_annotation/json_annotation.dart';

part 'tracking_response.g.dart';

@JsonSerializable(
    createToJson: false, checked: true, genericArgumentFactories: true)
class TrackingResponse {
  TrackingBody? body;
  String? statusCode;
  String? statusCodeValue;

  bool isSuccess() {
    return (body != null && body?.code == '200');
  }

  TrackingResponse({
    this.body,
    this.statusCode,
    this.statusCodeValue,
  });

  factory TrackingResponse.fromJson(Map<String, dynamic> json) =>
      _$TrackingResponseFromJson(json);
}

@JsonSerializable(
    createToJson: false, checked: true, genericArgumentFactories: true)
class TrackingBody {
  String? code;
  String? data;
  String? message;

  TrackingBody({
    this.code,
    this.data,
    this.message,
  });

  factory TrackingBody.fromJson(Map<String, dynamic> json) =>
      _$TrackingBodyFromJson(json);
}
