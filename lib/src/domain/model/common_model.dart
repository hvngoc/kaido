import 'package:json_annotation/json_annotation.dart';

part 'common_model.g.dart';

abstract class CommonModel {
  int? id;
  String? name;
}

@JsonSerializable(checked: true)
class UtilitiesCategory extends CommonModel {
  bool? isChecked;

  UtilitiesCategory(int? id, String? name, {this.isChecked = false}) {
    super.id = id;
    super.name = name;
  }

  factory UtilitiesCategory.fromJson(Map<String, dynamic> json) =>
      _$UtilitiesCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$UtilitiesCategoryToJson(this);
}

@JsonSerializable(checked: true)
class Direction extends CommonModel {
  bool? isChecked;

  Direction(int? id, String? name, {this.isChecked = false}) {
    super.id = id;
    super.name = name;
  }

  factory Direction.fromJson(Map<String, dynamic> json) => _$DirectionFromJson(json);

  Map<String, dynamic> toJson() => _$DirectionToJson(this);
}

@JsonSerializable(checked: true)
class Advantage extends CommonModel {
  bool? isChecked;

  Advantage(int? id, String? name, {this.isChecked = false}) {
    super.id = id;
    super.name = name;
  }

  factory Advantage.fromJson(Map<String, dynamic> json) => _$AdvantageFromJson(json);

  Map<String, dynamic> toJson() => _$AdvantageToJson(this);
}

@JsonSerializable(checked: true)
class Amenity extends CommonModel {
  bool? isChecked;

  Amenity(int id, String name, {this.isChecked = false}) {
    super.id = id;
    super.name = name;
  }

  factory Amenity.fromJson(Map<String, dynamic> json) => _$AmenityFromJson(json);

  Map<String, dynamic> toJson() => _$AmenityToJson(this);
}

@JsonSerializable(checked: true)
class UseRightType extends CommonModel {
  bool? isChecked;

  UseRightType(int id, String name, {this.isChecked = false}) {
    super.id = id;
    super.name = name;
  }

  factory UseRightType.fromJson(Map<String, dynamic> json) => _$UseRightTypeFromJson(json);

  Map<String, dynamic> toJson() => _$UseRightTypeToJson(this);
}

@JsonSerializable(checked: true)
class StatusQuo extends CommonModel {
  bool? isChecked;

  StatusQuo(int id, String name, {this.isChecked = false}) {
    super.id = id;
    super.name = name;
  }

  factory StatusQuo.fromJson(Map<String, dynamic> json) => _$StatusQuoFromJson(json);

  Map<String, dynamic> toJson() => _$StatusQuoToJson(this);
}
