part of 'ibuy_landing_page_bloc.dart';

@immutable
abstract class IbuyLandingPageEvent {}

class IbuyLandingPageSingleSignOnRequestEvent extends IbuyLandingPageEvent {
  final bool isGoToIBuy;

  IbuyLandingPageSingleSignOnRequestEvent(this.isGoToIBuy);
}