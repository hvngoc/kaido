import 'package:json_annotation/json_annotation.dart';

part 'delete_account_request.g.dart';

@JsonSerializable(checked: true, createToJson: true)
class DeleteAccountRequest {
  String? password;
  String? reason;

  DeleteAccountRequest(
    this.password,
    this.reason,
  );

  factory DeleteAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAccountRequestToJson(this);
}
