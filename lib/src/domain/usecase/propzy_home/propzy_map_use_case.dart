import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/model/propzy_map_model.dart';
import 'package:propzy_home/src/domain/repository/propzy_home_repository.dart';
import 'package:propzy_home/src/domain/request/propzy_map_request.dart';

class GetPropzyMapSessionUseCase {
  late final PropzyHomeRepository _repository;

  GetPropzyMapSessionUseCase(this._repository);

  Future<BaseResponse<PropzyMapSession>> getPropzyMapSession() {
    return _repository.getPropzyMapSession();
  }
}

class GetAddressSearchUseCase {
  late final PropzyHomeRepository _repository;

  GetAddressSearchUseCase(this._repository);

  Future<BaseResponse<AddressSearchContent>> searchAddressPropzyMap(
    String address,
    int page,
    int size,
    int property_type_id,
    String? sort,
  ) {
    return _repository.searchAddressPropzyMap(
      address,
      page,
      size,
      property_type_id,
      sort,
    );
  }
}

class GetAddressInformationUseCase {
  late final PropzyHomeRepository _repository;

  GetAddressInformationUseCase(this._repository);

  Future<BaseResponse<List<AddressInformation>?>> getAddressInformation(
    PropzyMapInformationRequest request,
  ) {
    return _repository.getAddressInformation(request);
  }
}

class PredictLocationUseCase {
  late final PropzyHomeRepository _repository;

  PredictLocationUseCase(this._repository);

  Future<BaseResponse<PredictLocation?>> predictLocation(int streetId) {
    return _repository.predictLocation(streetId);
  }
}

class SearchAddressWithStreetUseCase {
  late final PropzyHomeRepository _repository;

  SearchAddressWithStreetUseCase(this._repository);

  Future<BaseResponse<PagingResponse<SearchAddressWithStreet>>> searchAddressWithStreet(
    int page,
    int size,
    SearchAddressWithStreetRequest request,
  ) {
    return _repository.searchAddressWithStreet(page, size, request);
  }
}
