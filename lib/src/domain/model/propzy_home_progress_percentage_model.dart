import 'package:json_annotation/json_annotation.dart';

part 'propzy_home_progress_percentage_model.g.dart';

@JsonSerializable(checked: true)
class PropzyHomeProgressPercentageModel {
  double? totalPercent;
  List<PropzyHomeStepModel>? steps;

  PropzyHomeProgressPercentageModel({
    this.totalPercent,
    this.steps,
  });

  factory PropzyHomeProgressPercentageModel.fromJson(Map<String, dynamic> json) => _$PropzyHomeProgressPercentageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeProgressPercentageModelToJson(this);
}

@JsonSerializable(checked: true)
class PropzyHomeStepModel {
  int? id;
  String? name, icon;
  double? percent;
  bool? active;

  PropzyHomeStepModel({
    this.id,
    this.name,
    this.icon,
    this.percent,
    this.active,
  });

  factory PropzyHomeStepModel.fromJson(Map<String, dynamic> json) => _$PropzyHomeStepModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropzyHomeStepModelToJson(this);
}
