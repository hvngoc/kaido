import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/data/remote/api/ibuy_service.dart';
import 'package:propzy_home/src/domain/model/owner_type_model.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/model/propzy_home_property_type_model.dart';
import 'package:propzy_home/src/domain/model/propzy_map_model.dart';
import 'package:propzy_home/src/domain/repository/propzy_home_repository.dart';
import 'package:propzy_home/src/domain/request/propzy_map_request.dart';

class PropzyHomeRepositoryImpl extends PropzyHomeRepository {
  final IbuyService service;

  PropzyHomeRepositoryImpl(this.service);

  @override
  Future<BaseResponse<List<PropzyHomePropertyType>>> getListPropertyType() {
    return service.getListPropertyType();
  }

  @override
  Future<BaseResponse<PropzyMapSession>> getPropzyMapSession() {
    return service.getPropzyMapSession();
  }

  @override
  Future<BaseResponse<AddressSearchContent>> searchAddressPropzyMap(
    String address,
    int page,
    int size,
    int property_type_id,
    String? sort,
  ) {
    return service.searchAddressPropzyMap(
      address,
      page,
      size,
      property_type_id,
      sort,
    );
  }

  @override
  Future<BaseResponse<List<AddressInformation>?>> getAddressInformation(
    PropzyMapInformationRequest request,
  ) {
    return service.getAddressInformation(request);
  }

  @override
  Future<BaseResponse<PredictLocation?>> predictLocation(int streetId) {
    return service.predictLocation(streetId);
  }

  @override
  Future<BaseResponse<PagingResponse<SearchAddressWithStreet>>> searchAddressWithStreet(
    int page,
    int size,
    SearchAddressWithStreetRequest request,
  ) {
    return service.searchAddressWithStreet(page, size, request);
  }

  @override
  Future<BaseResponse<List<OwnerType>>> getListOwnerType() {
    return service.getListOwnerType();
  }
}
