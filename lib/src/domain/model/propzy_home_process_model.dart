import 'package:json_annotation/json_annotation.dart';

part 'propzy_home_process_model.g.dart';

@JsonSerializable(checked: true)
class PropzyHomeProcessModel {
  String? name;
  bool? active;
  double? percent;
  String? processIcon, completedIcon;
  int? scheduleTime;

  PropzyHomeProcessModel({
    this.name,
    this.active,
    this.percent,
    this.processIcon,
    this.completedIcon,
    this.scheduleTime,
  });

  factory PropzyHomeProcessModel.fromJson(Map<String, dynamic> json) => _$PropzyHomeProcessModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeProcessModelToJson(this);
}
