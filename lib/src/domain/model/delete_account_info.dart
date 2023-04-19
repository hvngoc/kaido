import 'package:json_annotation/json_annotation.dart';

part 'delete_account_info.g.dart';

@JsonSerializable(createToJson: true, checked: true)
class DeleteAccountInfo {
  String? createdBy;
  String? updatedBy;
  String? status;
  String? propzyId;
  String? userId;
  String? username;
  String? fullName;
  String? reqDeleteBy;
  String? reqDeleteReason;
  String? activated;
  int? remainTime;

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? createdAt;

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? updatedAt;

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? activatedAt;

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? reqDeleteAt;

  DeleteAccountInfo(
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.status,
    this.propzyId,
    this.userId,
    this.username,
    this.fullName,
    this.activatedAt,
    this.reqDeleteAt,
    this.reqDeleteBy,
    this.reqDeleteReason,
    this.activated,
    this.remainTime,
  );

  factory DeleteAccountInfo.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAccountInfoToJson(this);

  static DateTime? _fromJson(int? int) {
    if (int != null) {
      return DateTime.fromMillisecondsSinceEpoch(int);
    }
    return null;
  }

  static int? _toJson(DateTime? time) {
    return time?.millisecondsSinceEpoch;
  }
}
