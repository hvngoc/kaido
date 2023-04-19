import 'package:propzy_home/src/domain/model/propzy_home_page_config_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'propzy_home_property_type_model.g.dart';

@JsonSerializable(checked: true)
class PropzyHomePropertyType {
  PropzyHomePropertyType({
    this.id,
    this.typeName,
    this.listingTypeID,
    this.pageConfigs,
    this.isSelected = false,
  });

  int? id;
  String? typeName;
  int? listingTypeID;
  List<PageConfig>? pageConfigs;
  bool isSelected = false;

  factory PropzyHomePropertyType.fromJson(Map<String, dynamic> json) =>
      _$PropzyHomePropertyTypeFromJson(json);
}
