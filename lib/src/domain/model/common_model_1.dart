import 'package:json_annotation/json_annotation.dart';

part 'common_model_1.g.dart';

abstract class CommonModelDescription {
  int? id;
  int? value;
  String? description;
}

@JsonSerializable(checked: true)
class Content extends CommonModelDescription {
  static final Content ALL = Content(null, null, null);
  bool? isSelected;

  Content(int? id, int? value, String? description, {this.isSelected = false}) {
    super.id = id;
    super.value = value;
    super.description = description;
  }

  Content.clone(Content? content)
      : this(
    content?.id,
    content?.value,
    content?.description,
    isSelected: content?.isSelected,
  );

  factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

@JsonSerializable(checked: true)
class Position extends CommonModelDescription {
  static final Position ALL = Position(null, null, null);
  bool? isSelected;

  Position(int? id, int? value, String? description, {this.isSelected = false}) {
    super.id = id;
    super.value = value;
    super.description = description;
  }

  Position.clone(Position? position)
      : this(
    position?.id,
    position?.value,
    position?.description,
    isSelected: position?.isSelected,
  );

  factory Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);

  Map<String, dynamic> toJson() => _$PositionToJson(this);
}

@JsonSerializable(checked: true)
class BathRoom extends CommonModelDescription {
  static final BathRoom ALL = BathRoom(null, null, null);
  bool? isSelected;

  BathRoom(int? id, int? value, String? description, {this.isSelected = false}) {
    super.id = id;
    super.value = value;
    super.description = description;
  }

  BathRoom.clone(BathRoom? bathRoom)
      : this(
          bathRoom?.id,
          bathRoom?.value,
          bathRoom?.description,
          isSelected: bathRoom?.isSelected,
        );

  factory BathRoom.fromJson(Map<String, dynamic> json) => _$BathRoomFromJson(json);

  Map<String, dynamic> toJson() => _$BathRoomToJson(this);
}

@JsonSerializable(checked: true)
class BedRoom extends CommonModelDescription {
  static final BedRoom ALL = BedRoom(null, null, null);

  bool? isSelected;

  BedRoom(int? id, int? value, String? description, {this.isSelected = false}) {
    super.id = id;
    super.value = value;
    super.description = description;
  }

  BedRoom.clone(BedRoom? bedRoom)
      : this(
          bedRoom?.id,
          bedRoom?.value,
          bedRoom?.description,
          isSelected: bedRoom?.isSelected,
        );

  factory BedRoom.fromJson(Map<String, dynamic> json) => _$BedRoomFromJson(json);

  Map<String, dynamic> toJson() => _$BedRoomToJson(this);
}
