import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/request/propzy_home_update_offer_request.dart';
import 'package:propzy_home/src/domain/usecase/get_address_use_case.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_10/bloc/Step10Event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_10/bloc/Step10State.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_10/data/address_list_ward.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

class Step10Bloc extends Bloc<Step10Event, Step10State> {
  final GetDistrictUseCase getDistrictUseCase = GetIt.instance.get<GetDistrictUseCase>();
  final GetWardUseCase getWardUseCase = GetIt.instance.get<GetWardUseCase>();

  Step10Bloc() : super(Step10State()) {}

  Future<List<AddressListWard>> prepareDistrict(PropzyHomeOfferPlanning plan) async {
    final List<AddressListWard> result = [];

    final size = plan.districts?.length ?? 0;
    for (int i = 0; i < size; ++i) {
      final d = plan.districts![i];
      final rawDistrict = await getDistrictUseCase.call(d.districtId!);
      final district = AddressChooser(
        ChooserData(d.districtId, rawDistrict?.districtName),
        d.preferred ?? false,
      );

      final wards = plan.wards?.where((w) => w.districtId == d.districtId).toList();
      final List<AddressChooser> listWard = [];
      final sizeWards = wards?.length ?? 0;
      for (int j = 0; j < sizeWards; ++j) {
        final w = wards![j];
        final rawWard = await getWardUseCase.call(w.wardId!);
        final ward = AddressChooser(
          ChooserData(w.wardId, rawWard?.wardName),
          w.preferred ?? false,
        );
        listWard.add(ward);
      }
      final address = AddressListWard(district, listWard: listWard);
      result.add(address);
    }
    return result;
  }
}
