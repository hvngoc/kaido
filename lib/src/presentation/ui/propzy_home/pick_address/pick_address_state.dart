import 'package:propzy_home/src/domain/model/propzy_map_model.dart';

abstract class PickAddressState {}

class InitialPickAddressState extends PickAddressState {}

class LoadingGetPropzyMapSessionState extends PickAddressState {}

class SuccessGetPropzyMapSessionState extends PickAddressState {
  final PropzyMapSession? propzyMapSession;

  SuccessGetPropzyMapSessionState(this.propzyMapSession);
}

class ErrorGetPropzyMapSessionState extends PickAddressState {}

class LoadingGetSearchAddressState extends PickAddressState {
  final bool isLoadMore;

  LoadingGetSearchAddressState(this.isLoadMore);
}

class SuccessGetSearchAddressState extends PickAddressState {
  final List<AddressSearch>? listSearch;
  final int? totalPages;

  SuccessGetSearchAddressState(this.listSearch, this.totalPages);
}

class ErrorGetSearchAddressState extends ErrorShowMessageState {
  ErrorGetSearchAddressState(String? message) : super(message);
}

class LoadingGetAddressInformationState extends PickAddressState {}

class SuccessGetAddressInformationState extends PickAddressState {
  final List<AddressInformation>? listAddressInformation;

  SuccessGetAddressInformationState(this.listAddressInformation);
}

class SuccessPredictLocationState extends PickAddressState {
  final PredictLocation? predictLocation;

  SuccessPredictLocationState(this.predictLocation);
}

class SuccessSearchAddressWithStreetState extends PickAddressState {
  final List<SearchAddressWithStreet>? listSearchAddressWithStreet;

  SuccessSearchAddressWithStreetState(this.listSearchAddressWithStreet);
}

class ErrorShowMessageState extends PickAddressState {
  final String? message;

  ErrorShowMessageState(this.message);
}
