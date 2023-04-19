import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/district.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/model/propzy_map_model.dart';
import 'package:propzy_home/src/domain/model/street.dart';
import 'package:propzy_home/src/domain/model/ward.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/domain/usecase/get_address_use_case.dart';
import 'package:propzy_home/src/domain/usecase/propzy_home/propzy_map_use_case.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/input/bloc/input_address_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/input/bloc/input_address_state.dart';

class InputAddressBloc extends Bloc<InputAddressEvent, InputAddressState> {
  InputAddressBloc() : super(InitialInputAddressState());

  final SearchAddressListingUseCase searchAddressListingUseCase =
      GetIt.instance.get<SearchAddressListingUseCase>();

  final GetLocationInformationUseCase getLocationInformationUseCase =
      GetIt.instance.get<GetLocationInformationUseCase>();

  final PredictLocationUseCase predictLocationUseCase =
      GetIt.instance.get<PredictLocationUseCase>();

  final GetDistrictUseCase getDistrictUseCase = GetIt.instance.get<GetDistrictUseCase>();
  final GetWardUseCase getWardUseCase = GetIt.instance.get<GetWardUseCase>();
  final GetStreetUseCase getStreetUseCase = GetIt.instance.get<GetStreetUseCase>();
  final UpdateAddressListingUseCase updateAddressListingUseCase =
      GetIt.instance.get<UpdateAddressListingUseCase>();

  List<SearchAddress> listSuggestion = [];

  @override
  Stream<InputAddressState> mapEventToState(InputAddressEvent event) async* {
    if (event is GetLocationInformationEvent) {
      yield* getAddressInformation(event.location);
    } else if (event is PredictLocationEvent) {
      yield* predictLocation(event.streetId);
    } else if (event is UpdateListingAddressEvent) {
      yield* updateListingAddress(event.request);
    }
  }

  Future<List<String>> searchAddressSuggestion(String textSearch) async {
    listSuggestion = [SearchAddress(null, "Vị trí hiện tại của bạn", null, isFakeLocation: true)];
    try {
      BaseResponse<List<SearchAddress>> response =
          await searchAddressListingUseCase.searchAddressSuggestion(textSearch);
      if (response.result == true) {
        if (response.data != null) {
          listSuggestion.addAll(response.data!);
        }
      } else {}
    } catch (ex) {}

    List<String> listData = listSuggestion.map((e) {
      if (e.isFakeLocation) {
        return "Vị trí hiện tại của bạn";
      } else {
        return e.address ?? "";
      }
    }).toList();

    return Future.value(listData);
  }

  Stream<InputAddressState> getAddressInformation(String location) async* {
    yield LoadingState();
    try {
      BaseResponse<AddressByLocation> response =
          await getLocationInformationUseCase.getLocationInformation(location);
      if (response.result == true) {
        if (response.data != null) {
          AddressByLocation addressByLocation = response.data!;
          if ((addressByLocation.cityId ?? 0) == 1) {
            addressByLocation.cityName = "Hồ Chí Minh";
          }

          if (addressByLocation.districtId != null) {
            addressByLocation.districtName =
                (await getDistrictById(addressByLocation.districtId!))?.districtName;
          }

          if (addressByLocation.wardId != null) {
            addressByLocation.wardName = (await getWardById(addressByLocation.wardId!))?.wardName;
          }

          if (addressByLocation.streetId != null) {
            addressByLocation.streetName =
                (await getStreetById(addressByLocation.streetId!))?.streetName;
          }

          yield SuccessGetAddressInformationState(addressByLocation);
        } else {
          yield SuccessGetAddressInformationState(null);
        }
      } else {
        yield ErrorState(response.message);
      }
    } catch (ex) {
      yield ErrorState(ex.toString());
    }
  }

  Future<District?> getDistrictById(int districtId) async {
    return getDistrictUseCase.call(districtId);
  }

  Future<Ward?> getWardById(int wardId) async {
    return getWardUseCase.call(wardId);
  }

  Future<Street?> getStreetById(int streetId) async {
    return getStreetUseCase.call(streetId);
  }

  Stream<InputAddressState> predictLocation(int streetId) async* {
    try {
      BaseResponse<PredictLocation?> response =
          await predictLocationUseCase.predictLocation(streetId);
      if (response.result == true) {
        yield SuccessPredictLocationState(response.data);
      } else {
        yield ErrorState(response.message);
      }
    } catch (ex) {
      yield ErrorState(ex.toString());
    }
  }

  Stream<InputAddressState> updateListingAddress(CreateListingRequest request) async* {
    yield LoadingState();
    try {
      BaseResponse<dynamic> response =
          await updateAddressListingUseCase.updateAddressListing(request);
      if (response.result == true) {
        yield SuccessUpdateAddressState();
      } else {
        yield ErrorState(response.message);
      }
    } catch (ex) {
      yield ErrorState(ex.toString());
    }
  }
}
