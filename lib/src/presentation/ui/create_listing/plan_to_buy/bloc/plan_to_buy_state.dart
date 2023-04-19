abstract class BasePlanToBuyState {}

class PlanToBuyStateInitial extends BasePlanToBuyState {}

class PlanToBuyStateLoading extends BasePlanToBuyState {}

class PlanToBuyStateSuccess extends BasePlanToBuyState {
  final bool navigateScreen;

  PlanToBuyStateSuccess(this.navigateScreen);
}
