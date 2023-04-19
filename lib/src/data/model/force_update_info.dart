

import 'package:json_annotation/json_annotation.dart';

part 'force_update_info.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class ForceUpdateInfo {
  String? apis;
  String? appCode;
  String? content;
  int? countryCacheUnit;
  String? moreContent;
  bool? morel;
  String? osName;
  bool? required;
  int? versionCode;
  String? versionNumber;
  ForceUpdateInfo({
    this.apis, this.appCode, this.content, this.countryCacheUnit, this.moreContent, this.morel, this.osName, this.required,
    this.versionCode, this.versionNumber
});

  factory ForceUpdateInfo.fromJson(Map<String, dynamic> json) => _$ForceUpdateInfoFromJson(json);
}