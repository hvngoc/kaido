import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/model/propzy_map_model.dart';

abstract class InputAddressState {}

class InitialInputAddressState extends InputAddressState {}

class LoadingState extends InputAddressState {}

class ErrorState extends InputAddressState {
  final String? message;

  ErrorState(this.message);
}

class SuccessGetListAddressSuggestionState extends InputAddressState {
  final List<SearchAddress> listSuggestion;

  SuccessGetListAddressSuggestionState(this.listSuggestion);
}

class SuccessGetAddressInformationState extends InputAddressState {
  final AddressByLocation? addressByLocation;

  SuccessGetAddressInformationState(this.addressByLocation);
}

class SuccessPredictLocationState extends InputAddressState {
  final PredictLocation? predictLocation;

  SuccessPredictLocationState(this.predictLocation);
}

class SuccessUpdateAddressState extends InputAddressState {}
