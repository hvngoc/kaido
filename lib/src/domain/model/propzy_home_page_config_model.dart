import 'package:json_annotation/json_annotation.dart';

part 'propzy_home_page_config_model.g.dart';

@JsonSerializable(checked: true)
class PageConfig {
  PageConfig({
    this.code,
    this.title,
    this.description,
    this.content,
    this.pageValue,
    this.pageId,
  });

  String? code;
  String? title;
  String? description;
  String? content;
  String? pageValue;
  int? pageId;

  factory PageConfig.fromJson(Map<String, dynamic> json) => _$PageConfigFromJson(json);
}
