import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/config/app_config.dart';
import 'package:propzy_home/src/data/data.dart';
import 'package:propzy_home/src/domain/domain.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/input/bloc/input_address_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/map/bloc/confirm_map_address_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/contact_info/bloc/owner_info_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/delete_account/bloc/delete_account_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/utilities/bloc/utilities_info_bloc.dart';
import 'package:propzy_home/src/presentation/ui/home/home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/bloc/detail_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/profile/bloc/authentication_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/bloc/propzy_home_progress_view_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/confirm_owner/confirm_owner_bloc.dart';
import 'package:propzy_home/src/presentation/ui/ibuy_landing_page/bloc/ibuy_landing_page_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/my_offer/my_offer_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/pick_address_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/apartment/step_1/bloc/Apartment1Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_10/bloc/Step10Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_2/bloc/Step2Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_3/bloc/Step3Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_4/bloc/Step4Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_5/bloc/Step5Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_6/bloc/Step6Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_7/bloc/Step7Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_8/bloc/Step8Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_9/bloc/Step9Bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_type/property_type_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/purchase_price/widgets/map_info_card/bloc/map_info_card_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/result/next_visit/next_vist_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/search/search_bloc.dart';

final locator = GetIt.instance..allowReassignment = true;

Future setupLocator() async {
  _registerBloc();
  await Data.init();
  Domain.init();
}

String getEnvironment() {
  return locator<AppConfig>().baseUrl;
}

String getPropzyMapUrl() {
  return locator<AppConfig>().propzyMapURL;
}

String getPortalUrl() {
  return locator<AppConfig>().portalURL;
}

String getCoreUrl() {
  return locator<AppConfig>().coreUrl;
}

String getChatWithCSURL() {
  return locator<AppConfig>().chatWithCSURL;
}

void _registerBloc() {
  locator.registerLazySingleton<HomeBloc>(() => HomeBloc());
  locator.registerLazySingleton<SearchBloc>(() => SearchBloc());
  locator.registerLazySingleton<NextVisitBloc>(() => NextVisitBloc());
  locator.registerLazySingleton<DetailListingBloc>(() => DetailListingBloc());
  locator
      .registerLazySingleton<IbuyLandingPageBloc>(() => IbuyLandingPageBloc());
  locator.registerLazySingleton<PropzyHomeBloc>(() => PropzyHomeBloc());
  locator.registerLazySingleton<PropzyHomePropertyTypeBloc>(
      () => PropzyHomePropertyTypeBloc());
  locator.registerLazySingleton<PickAddressBloc>(() => PickAddressBloc());
  locator.registerLazySingleton<ConfirmOwnerBloc>(() => ConfirmOwnerBloc());
  locator.registerLazySingleton<Step2Bloc>(() => Step2Bloc());
  locator.registerLazySingleton<Step3Bloc>(() => Step3Bloc());
  locator.registerLazySingleton<Step4Bloc>(() => Step4Bloc());
  locator.registerLazySingleton<Step5Bloc>(() => Step5Bloc());
  locator.registerLazySingleton<Step6Bloc>(() => Step6Bloc());
  locator.registerLazySingleton<Step7Bloc>(() => Step7Bloc());
  locator.registerLazySingleton<Step8Bloc>(() => Step8Bloc());
  locator.registerLazySingleton<Step9Bloc>(() => Step9Bloc());
  locator.registerLazySingleton<Step10Bloc>(() => Step10Bloc());
  locator.registerLazySingleton<MyOfferBloc>(() => MyOfferBloc());

  locator.registerLazySingleton<Apartment1Bloc>(() => Apartment1Bloc());
  locator.registerLazySingleton<MapInfoCardBloc>(() => MapInfoCardBloc());
  locator.registerLazySingleton<AuthenticationBloc>(() => AuthenticationBloc());
  locator.registerLazySingleton<PropzyHomeProgressViewBloc>(
      () => PropzyHomeProgressViewBloc());

  // create listing
  locator.registerLazySingleton<CreateListingBloc>(() => CreateListingBloc());
  locator.registerLazySingleton<InputAddressBloc>(() => InputAddressBloc());
  locator.registerLazySingleton<ConfirmMapAddressBloc>(
      () => ConfirmMapAddressBloc());

  // delete account
  locator.registerLazySingleton<DeleteAccountBloc>(() => DeleteAccountBloc());
  locator.registerLazySingleton<ConfirmMapAddressBloc>(() => ConfirmMapAddressBloc());
  locator.registerLazySingleton<OwnerInfoBloc>(() => OwnerInfoBloc());
  locator.registerLazySingleton<UtilitiesInfoBloc>(() => UtilitiesInfoBloc());
}
