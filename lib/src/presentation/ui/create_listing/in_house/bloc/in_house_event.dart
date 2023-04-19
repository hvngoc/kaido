abstract class InHouseEvent {}

class LoadDirectionEvent extends InHouseEvent {}

class UpdateInHouseEvent extends InHouseEvent {
  final int? id;
  final int? bathrooms;
  final int? bedrooms;
  final int? directionId;
  final double? floorSize;
  final double? lotSize;
  final double? sizeLength;
  final double? sizeWidth;

  UpdateInHouseEvent({
    this.id,
    this.bathrooms,
    this.bedrooms,
    this.directionId,
    this.floorSize,
    this.lotSize,
    this.sizeLength,
    this.sizeWidth,
  });
}
