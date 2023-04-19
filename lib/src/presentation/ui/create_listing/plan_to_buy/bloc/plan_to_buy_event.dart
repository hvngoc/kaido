abstract class PlanToBuyEvent {}

class LoadListPlanEvent extends PlanToBuyEvent {}

class UpdatePlanToBuyEvent extends PlanToBuyEvent {
  final int? id;
  final int? buyPlanOptionId;
  final int? districtId;
  final int? priceFrom;
  final int? priceTo;
  final int? propertyTypeId;

  UpdatePlanToBuyEvent({
    this.id,
    this.buyPlanOptionId,
    this.districtId,
    this.priceFrom,
    this.priceTo,
    this.propertyTypeId,
  });
}
