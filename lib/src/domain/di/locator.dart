import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/config/app_config.dart';
import 'package:propzy_home/src/data/local/db/app_database.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/remote/api/app_service.dart';
import 'package:propzy_home/src/data/remote/api/listing_service.dart';
import 'package:propzy_home/src/data/remote/api/search_service.dart';
import 'package:propzy_home/src/data/remote/api/upload_service.dart';
import 'package:propzy_home/src/data/remote/api/user_service.dart';
import 'package:propzy_home/src/data/repository/app_repository_impl.dart';
import 'package:propzy_home/src/data/repository/auth_repository_impl.dart';
import 'package:propzy_home/src/data/repository/common_repository_impl.dart';
import 'package:propzy_home/src/data/repository/ibuyer_repository_impl.dart';
import 'package:propzy_home/src/data/repository/listing_repository_impl.dart';
import 'package:propzy_home/src/data/repository/propzy_home_repository_impl.dart';
import 'package:propzy_home/src/data/repository/upload_repository_impl.dart';
import 'package:propzy_home/src/data/repository/user_repository_impl.dart';
import 'package:propzy_home/src/domain/repository/app_repository.dart';
import 'package:propzy_home/src/domain/repository/auth_repository.dart';
import 'package:propzy_home/src/domain/repository/common_repository.dart';
import 'package:propzy_home/src/domain/repository/ibuyer_repository.dart';
import 'package:propzy_home/src/domain/repository/listing_repository.dart';
import 'package:propzy_home/src/domain/repository/propzy_home_repository.dart';
import 'package:propzy_home/src/domain/repository/upload_repository.dart';
import 'package:propzy_home/src/domain/repository/user_repository.dart';
import 'package:propzy_home/src/domain/usecase/auth_use_case.dart';
import 'package:propzy_home/src/domain/usecase/check_update_version_use_case.dart';
import 'package:propzy_home/src/domain/usecase/create_listing_use_case.dart';
import 'package:propzy_home/src/domain/usecase/delete_account_use_case.dart';
import 'package:propzy_home/src/domain/usecase/detail_listing_use_case.dart';
import 'package:propzy_home/src/domain/usecase/filter/get_property_type_list_project_use_case.dart';
import 'package:propzy_home/src/domain/usecase/get_address_use_case.dart';
import 'package:propzy_home/src/domain/usecase/get_chooser_list_use_case.dart';
import 'package:propzy_home/src/domain/usecase/get_listing_search_home.dart';
import 'package:propzy_home/src/domain/usecase/get_profile_use_case.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';
import 'package:propzy_home/src/domain/usecase/propzy_home/get_list_owner_type_use_case.dart';
import 'package:propzy_home/src/domain/usecase/propzy_home/get_list_property_type_use_case.dart';
import 'package:propzy_home/src/domain/usecase/propzy_home/propzy_map_use_case.dart';
import 'package:propzy_home/src/domain/usecase/search_use_case.dart';
import 'package:propzy_home/src/domain/usecase/update_address_use_case.dart';
import 'package:propzy_home/src/domain/usecase/upload_image_use_case.dart';

import '../../data/remote/api/ibuy_service.dart';
import '../../data/repository/search_repository_impl.dart';
import '../repository/search_repository.dart';
import '../usecase/filter/get_advantage_category_list_usecase.dart';
import '../usecase/filter/get_amenity_category_list_usecase.dart';
import '../usecase/filter/get_bathroom_list_usecase.dart';
import '../usecase/filter/get_bedroom_list_usecase.dart';
import '../usecase/filter/get_content_list_usecase.dart';
import '../usecase/filter/get_direction_list_usecase.dart';
import '../usecase/filter/get_position_list_usecase.dart';
import '../usecase/filter/get_property_type_list_usecase.dart';

final locator = GetIt.instance;

Future setupDomainLocator() async {
  _registerRepository();
  _registerUseCase();
}

Future _registerRepository() async {
  locator.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(locator<SearchService>()));
  locator.registerLazySingleton<IBuyerRepository>(() => IBuyerRepositoryImpl(
        locator<IbuyService>(),
        locator<PrefHelper>(),
      ));
  locator.registerLazySingleton<CommonRepository>(
      () => CommonRepositoryImpl(locator<IbuyService>()));
  locator.registerLazySingleton<ListingRepository>(
      () => ListingRepositoryImpl(locator<ListingService>()));
  locator.registerLazySingleton<PropzyHomeRepository>(
      () => PropzyHomeRepositoryImpl(locator<IbuyService>()));
  locator.registerLazySingleton<AppRepository>(
      () => AppRepositoryImpl(locator<AppService>(), locator<AppDatabase>()));
  locator.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(locator<UserService>()));
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
        locator<AppConfig>().coreUrl,
        locator<AppConfig>().coreUrlFE,
        locator<UserService>(),
        locator<PrefHelper>()),
  );
  locator.registerLazySingleton<UploadRepository>(
      () => UploadRepositoryImpl(locator<UploadService>()));
}

Future _registerUseCase() async {
  locator.registerLazySingleton(
      () => GetSearchHistoryUseCase(locator<SearchRepository>()));
  locator.registerLazySingleton(
      () => SaveSearchHistoryUseCase(locator<SearchRepository>()));
  locator.registerLazySingleton(
      () => GetListingSearchHomeUseCase(locator<SearchRepository>()));
  locator.registerLazySingleton(
      () => GetCategoryProjectSearchHomeUseCase(locator<SearchRepository>()));
  locator.registerLazySingleton(
      () => CheckUpdateVersionUseCase(locator<CommonRepository>()));

  locator.registerLazySingleton(
      () => GetLocationAutoCompleteUseCase(locator<SearchRepository>()));
  locator.registerLazySingleton(
      () => GetListCityUseCase(locator<AppRepository>()));
  locator.registerLazySingleton(
      () => GetListDistrictUseCase(locator<AppRepository>()));
  locator.registerLazySingleton(
      () => GetListWardUseCase(locator<AppRepository>()));
  locator.registerLazySingleton(
      () => GetListStreetUseCase(locator<AppRepository>()));
  locator.registerLazySingleton(
      () => GetListPropertyBuyUseCase(locator<AppRepository>()));
  locator.registerLazySingleton(
      () => GetListPropertyRentUseCase(locator<AppRepository>()));
  locator.registerLazySingleton(
      () => UpdateDistrictUseCase(locator<AppRepository>()));
  locator
      .registerLazySingleton(() => UpdateWardUseCase(locator<AppRepository>()));
  locator.registerLazySingleton(
      () => UpdateStreetUseCase(locator<AppRepository>()));
  locator.registerLazySingleton(
      () => GetDistrictUseCase(locator<AppRepository>()));
  locator.registerLazySingleton(() => GetWardUseCase(locator<AppRepository>()));
  locator
      .registerLazySingleton(() => GetStreetUseCase(locator<AppRepository>()));

  locator
      .registerLazySingleton(() => GetPropertyTypeListUseCase(locator.get()));
  locator.registerLazySingleton(
      () => GetPropertyTypeListProjectUseCase(locator.get()));
  locator.registerLazySingleton(() => GetBedRoomListUseCase(locator.get()));
  locator.registerLazySingleton(() => GetBathRoomListUseCase(locator.get()));
  locator.registerLazySingleton(() => GetDirectionListUseCase(locator.get()));
  locator.registerLazySingleton(() => GetPositionListUseCase(locator.get()));
  locator.registerLazySingleton(() => GetContentListUseCase(locator.get()));
  locator.registerLazySingleton(
      () => GetAdvantageCategoryListUseCase(locator.get()));
  locator.registerLazySingleton(
      () => GetAmenityCategoryListUseCase(locator.get()));

  locator.registerLazySingleton(() => GetListParentHouseUseCase(locator.get()));
  locator.registerLazySingleton(() => GetListContiguousUseCase(locator.get()));
  locator.registerLazySingleton(() => GetListHouseDirectionUseCase());
  locator.registerLazySingleton(() => GetListHouseShapeUseCase(locator.get()));
  locator
      .registerLazySingleton(() => GetListExpectedTimeUseCase(locator.get()));
  locator.registerLazySingleton(() => GetListPlanToBuyUseCase());
  locator.registerLazySingleton(() => GetListCaptionUseCase(locator.get()));
  locator.registerLazySingleton(() => UploadFileUseCase(locator.get()));
  locator.registerLazySingleton(() => DeleteFileUseCase(locator.get()));

  locator.registerLazySingleton(() => UpdateOfferUseCase(locator.get()));
  locator.registerLazySingleton(() => GetOfferDetailUseCase(locator.get()));
  locator.registerLazySingleton(() => CallScheduleOfferUseCase(locator.get()));
  locator.registerLazySingleton(() => UpdateCaptionFileUseCase(locator.get()));
  locator.registerLazySingleton(() => GetOfferPriceUseCase(locator.get()));
  locator.registerLazySingleton(
      () => GetCompletionPercentageUseCase(locator.get()));
  locator.registerLazySingleton(() => GetProcessOfferUseCase(locator.get()));

  locator.registerLazySingleton(
      () => GetDetailListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => GetListingInteractionUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => GetListAlleysUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => GetListBuildingsUseCase(locator<ListingRepository>()));

  locator.registerLazySingleton(
      () => GetProfileUseCase(locator<UserRepository>()));

  locator.registerLazySingleton(
      () => GetCurrentUserUseCase(locator<AuthRepository>()));
  locator.registerLazySingleton(
      () => SingleSignOnUseCase(locator<AuthRepository>()));
  locator.registerLazySingleton(
      () => ReloadAccessTokenUseCase(locator<AuthRepository>()));
  locator
      .registerLazySingleton(() => SignOutUseCase(locator<AuthRepository>()));

  locator.registerLazySingleton(
      () => GetListPropertyTypeUseCase(locator<PropzyHomeRepository>()));
  locator.registerLazySingleton(
      () => GetPropzyMapSessionUseCase(locator<PropzyHomeRepository>()));
  locator.registerLazySingleton(
      () => GetAddressSearchUseCase(locator<PropzyHomeRepository>()));
  locator.registerLazySingleton(
      () => GetAddressInformationUseCase(locator<PropzyHomeRepository>()));

  locator.registerLazySingleton(
      () => GetListingInDistanceUseCase(locator<IBuyerRepository>()));
  locator.registerLazySingleton(
      () => PredictLocationUseCase(locator<PropzyHomeRepository>()));
  locator.registerLazySingleton(
      () => SearchAddressWithStreetUseCase(locator<PropzyHomeRepository>()));
  locator.registerLazySingleton(
      () => GetListOwnerTypeUseCase(locator<PropzyHomeRepository>()));
  locator.registerLazySingleton(
      () => CreateOfferUseCase(locator<IBuyerRepository>()));

  locator.registerLazySingleton(
      () => GetListCategoriesOfferUseCase(locator<IBuyerRepository>()));
  locator.registerLazySingleton(
      () => GetListOffersByCategoryUseCase(locator<IBuyerRepository>()));

  locator.registerLazySingleton(
      () => UpdateCategoryListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdateAreaDirectionListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdateLegalDocsListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => GetListStatusQuos(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => GetListUseRightType(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => GetListPlanToBuyServicesUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdatePlanToBuyListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdateAreaDirectionListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdatePositionListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdateProjectInfoListingUseCase(locator<ListingRepository>()));

  locator.registerLazySingleton(
      () => SearchAddressListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => GetLocationInformationUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => CreateListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdateAddressListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdateTitleDescriptionStepUseCase(locator<ListingRepository>()));

  locator.registerLazySingleton(
      () => DeleteAccountUseCase(locator<UserRepository>()));
  locator.registerLazySingleton(
      () => UpdateCategoryListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdateAreaDirectionListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdatePositionListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdateProjectInfoListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdateImageListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => SearchAddressListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => GetLocationInformationUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdateTextureStepUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdateAddressListingUseCase(locator<ListingRepository>()));

  locator.registerLazySingleton(
      () => UploadImageUseCase(locator<UploadRepository>()));
  locator.registerLazySingleton(
      () => UpdateOwnerInfoListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdateUtilitiesListingUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => GetDraftListingDetailUseCase(locator<ListingRepository>()));
  locator.registerLazySingleton(
      () => UpdatePriceStepUseCase(locator<ListingRepository>()));
}
