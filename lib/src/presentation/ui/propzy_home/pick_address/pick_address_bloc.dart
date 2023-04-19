import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/district.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/model/propzy_map_model.dart';
import 'package:propzy_home/src/domain/model/street.dart';
import 'package:propzy_home/src/domain/model/ward.dart';
import 'package:propzy_home/src/domain/request/propzy_map_request.dart';
import 'package:propzy_home/src/domain/usecase/get_address_use_case.dart';
import 'package:propzy_home/src/domain/usecase/propzy_home/propzy_map_use_case.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/pick_address_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/pick_address_state.dart';

class PickAddressBloc extends Bloc<PickAddressEvent, PickAddressState> {
  PickAddressBloc() : super(InitialPickAddressState());

  final GetPropzyMapSessionUseCase getPropzyMapSessionUseCase =
      GetIt.instance.get<GetPropzyMapSessionUseCase>();

  final GetAddressSearchUseCase getAddressSearchUseCase =
      GetIt.instance.get<GetAddressSearchUseCase>();

  final GetAddressInformationUseCase getAddressInformationUseCase =
      GetIt.instance.get<GetAddressInformationUseCase>();

  final PredictLocationUseCase predictLocationUseCase =
      GetIt.instance.get<PredictLocationUseCase>();

  final SearchAddressWithStreetUseCase searchAddressWithStreetUseCase =
      GetIt.instance.get<SearchAddressWithStreetUseCase>();

  final GetDistrictUseCase getDistrictUseCase = GetIt.instance.get<GetDistrictUseCase>();
  final GetWardUseCase getWardUseCase = GetIt.instance.get<GetWardUseCase>();
  final GetStreetUseCase getStreetUseCase = GetIt.instance.get<GetStreetUseCase>();

  List<AddressSearch>? listSearch = null;

  @override
  Stream<PickAddressState> mapEventToState(PickAddressEvent event) async* {
    if (event is GetPropzyMapSessionEvent) {
      yield* getListPropertyType();
    } else if (event is SearchAddressEvent) {
      yield* searchAddress(
        event.address,
        event.page,
        event.size,
        event.property_type_id,
        event.sort,
      );
    } else if (event is GetAddressInformationEvent) {
      yield* getAddressInformation(event.request);
    } else if (event is PredictLocationEvent) {
      yield* predictLocation(event.streetId);
    } else if (event is SearchAddressWithStreetEvent) {
      yield* searchAddressWithStreet(event.page, event.size, event.request);
    }
  }

  Stream<PickAddressState> getListPropertyType() async* {
    yield LoadingGetPropzyMapSessionState();
    try {
      BaseResponse<PropzyMapSession> response =
          await getPropzyMapSessionUseCase.getPropzyMapSession();
      if (response.result == true) {
        yield SuccessGetPropzyMapSessionState(response.data);
      } else {
        yield ErrorGetPropzyMapSessionState();
      }
    } catch (ex) {
      yield ErrorGetPropzyMapSessionState();
    }
  }

  Stream<PickAddressState> searchAddress(
    String address,
    int page,
    int size,
    int property_type_id,
    String? sort,
  ) async* {
    yield LoadingGetSearchAddressState(page > 1);
    try {
      BaseResponse<AddressSearchContent> response =
          await getAddressSearchUseCase.searchAddressPropzyMap(
        address,
        page,
        size,
        property_type_id,
        sort,
      );
      if (response.result == true) {
        if (page > 1) {
          response.data?.list?.forEach((element) {
            listSearch?.add(element);
          });
        } else {
          listSearch = response.data?.list;
        }
        yield SuccessGetSearchAddressState(
          response.data?.list,
          response.data?.totalPages,
        );
      } else {
        yield ErrorGetSearchAddressState(response.message);
      }
    } catch (ex) {
      yield ErrorGetSearchAddressState(ex.toString());
    }
  }

  Stream<PickAddressState> getAddressInformation(PropzyMapInformationRequest request) async* {
    yield LoadingGetAddressInformationState();
    try {
      BaseResponse<List<AddressInformation>?> response =
          await getAddressInformationUseCase.getAddressInformation(request);
      if (response.result == true) {
        yield SuccessGetAddressInformationState(response.data);
      } else {
        yield ErrorShowMessageState(response.message);
      }
    } catch (ex) {
      yield ErrorShowMessageState(ex.toString());
    }
  }

  Stream<PickAddressState> predictLocation(int streetId) async* {
    try {
      BaseResponse<PredictLocation?> response =
          await predictLocationUseCase.predictLocation(streetId);
      if (response.result == true) {
        yield SuccessPredictLocationState(response.data);
      } else {
        yield ErrorShowMessageState(response.message);
      }
    } catch (ex) {
      yield ErrorShowMessageState(ex.toString());
    }
  }

  Stream<PickAddressState> searchAddressWithStreet(
    int page,
    int size,
    SearchAddressWithStreetRequest request,
  ) async* {
    try {
      BaseResponse<PagingResponse<SearchAddressWithStreet>> response =
          await searchAddressWithStreetUseCase.searchAddressWithStreet(
        page,
        size,
        request,
      );
      if (response.result == true) {
        yield SuccessSearchAddressWithStreetState(response.data?.content);
      } else {
        yield ErrorShowMessageState(response.message);
      }
    } catch (ex) {
      yield ErrorShowMessageState(ex.toString());
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
}
