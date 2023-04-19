class ChoosePropertyEvent {
  final int listingTypeId;
  final int? propertyTypeId;
  final int id;

  ChoosePropertyEvent({
    required this.listingTypeId,
    required this.propertyTypeId,
    required this.id,
  });
}
