part of 'ibuy_landing_page_bloc.dart';

@immutable
abstract class IbuyLandingPageState {}

class IbuyLandingPageInitial extends IbuyLandingPageState {}

class IbuyLandingPageLoadingState extends IbuyLandingPageState {}

class IbuyLandingPageSuccessSingleSignOnState extends IbuyLandingPageState {
  final bool isGoToIBuy;

  IbuyLandingPageSuccessSingleSignOnState(this.isGoToIBuy);
}

class IbuyLandingPageErrorSingleSignOnState extends IbuyLandingPageState {}