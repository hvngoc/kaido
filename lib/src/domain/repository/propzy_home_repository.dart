import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/owner_type_model.dart';
import 'package:propzy_home/src/domain/model/paging_response.dart';
import 'package:propzy_home/src/domain/model/propzy_home_property_type_model.dart';
import 'package:propzy_home/src/domain/model/propzy_map_model.dart';
import 'package:propzy_home/src/domain/request/propzy_map_request.dart';

abstract class PropzyHomeRepository {
  Future<BaseResponse<List<PropzyHomePropertyType>>> getListPropertyType();

  Future<BaseResponse<PropzyMapSession>> getPropzyMapSession();

  Future<BaseResponse<AddressSearchContent>> searchAddressPropzyMap(
    String address,
    int page,
    int size,
    int property_type_id,
    String? sort,
  );

  Future<BaseResponse<List<AddressInformation>?>> getAddressInformation(
    PropzyMapInformationRequest request,
  );

  Future<BaseResponse<PredictLocation?>> predictLocation(int streetId);

  Future<BaseResponse<PagingResponse<SearchAddressWithStreet>>> searchAddressWithStreet(
    int page,
    int size,
    SearchAddressWithStreetRequest request,
  );

  Future<BaseResponse<List<OwnerType>>> getListOwnerType();
}
