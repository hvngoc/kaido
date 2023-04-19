import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/model/base_response.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_property_type_model.dart';
import 'package:propzy_home/src/domain/request/propzy_home_create_offer_request.dart';
import 'package:propzy_home/src/domain/request/propzy_home_update_offer_request.dart';
import 'package:propzy_home/src/domain/usecase/ibuyer_use_case.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_state.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/util.dart';

class PropzyHomeBloc extends Bloc<PropzyHomeEvent, PropzyHomeState> {
  final UpdateOfferUseCase updateOfferUseCase = GetIt.instance.get<UpdateOfferUseCase>();
  final GetOfferDetailUseCase _getOfferDetailUseCase = GetIt.instance.get<GetOfferDetailUseCase>();
  final CreateOfferUseCase createOfferUseCase = GetIt.instance.get<CreateOfferUseCase>();

  HomeOfferModel? draftOffer = null;
  PropzyHomePropertyType? propertyTypeSelected = null;

  PropzyHomeBloc() : super(InitialPropzyHomeState());

  @override
  Stream<PropzyHomeState> mapEventToState(PropzyHomeEvent event) async* {
    if (event is SaveDraftOfferEvent) {
      _safeCopyAddressOffer(event.draftOffer);
    } else if (event is SavePropertyTypeSelectedEvent) {
      propertyTypeSelected = event.propertyType;
    } else if (event is UpdateOfferEvent) {
      yield* callUpdate(event);
    } else if (event is ResetDraftOfferEvent) {
      _resetDraftOffer();
    } else if (event is UpdateFacadeEvent) {
      yield* updateFacade(event);
    } else if (event is UpdateAlleyEvent) {
      yield* updateAlley(event);
    } else if (event is GetOfferDetailEvent) {
      yield* getOfferDetail();
    } else if (event is CreateOfferEvent) {
      yield* createOffer(event.request);
    }
  }

  void _resetDraftOffer() {
    Log.w('_resetDraftOffer');
    draftOffer = null;
    propertyTypeSelected = null;
  }

  void _safeCopyAddressOffer(HomeOfferModel? offer) {
    if (offer == null) {
      return;
    }
    if (draftOffer == null) {
      draftOffer = offer;
      return;
    }
    draftOffer?.address = offer.address ?? draftOffer?.address;
    draftOffer?.cityId = offer.cityId ?? draftOffer?.cityId;
    draftOffer?.districtId = offer.districtId ?? draftOffer?.districtId;
    draftOffer?.wardID = offer.wardID ?? draftOffer?.wardID;
    draftOffer?.streetId = offer.streetId ?? draftOffer?.streetId;
    draftOffer?.houseNumber = offer.houseNumber ?? draftOffer?.houseNumber;
    draftOffer?.unspecifiedLocation = offer.unspecifiedLocation ?? draftOffer?.unspecifiedLocation;
    draftOffer?.buildingId = offer.buildingId ?? draftOffer?.buildingId;
    draftOffer?.buildingName = offer.buildingName ?? draftOffer?.buildingName;
    draftOffer?.blockBuildingId = offer.blockBuildingId ?? draftOffer?.blockBuildingId;
    draftOffer?.blockBuildingName = offer.blockBuildingName ?? draftOffer?.blockBuildingName;
    draftOffer?.latitude = offer.latitude ?? draftOffer?.latitude;
    draftOffer?.longitude = offer.longitude ?? draftOffer?.longitude;
  }

  Stream<PropzyHomeState> getOfferDetail() async* {
    yield LoadingState();
    final response = await _getOfferDetailUseCase.call(draftOffer?.id);
    yield response.fold(
      (l) => UpdateOfferErrorState(),
      (r) {
        draftOffer = r;
        return GetOfferDetailSuccess();
      },
    );
  }

  Stream<PropzyHomeState> createOffer(PropzyHomeCreateOfferRequest request) async* {
    yield LoadingCreateOfferState();
    try {
      BaseResponse<int> response = await createOfferUseCase.createOffer(request);
      if (response.result == true) {
        draftOffer?.id = response.data;
        yield SuccessCreateOfferState(response.data);
      } else {
        yield ErrorCreateOfferState(response.message);
      }
    } catch (ex) {
      yield ErrorCreateOfferState(ex.toString());
    }
  }

  Stream<PropzyHomeState> callUpdate(UpdateOfferEvent event) async* {
    Util.showLoading();
    final request = _mapOfferToRequest();
    request
      ..reachedPageId = event.reachedPageId ?? request.reachedPageId
      ..houseTexturesIds = event.listHomeTextureIds ?? request.houseTexturesIds
      ..length = event.length ?? request.length
      ..width = event.width ?? request.width
      ..lotSize = event.lotSize ?? request.lotSize
      ..floorSize = event.floorSize ?? request.floorSize
      ..numberFloor = event.numberFloor?.toInt() ?? request.numberFloor
      ..directionId = event.directionId ?? request.directionId
      ..houseShapeId = event.houseShapeId ?? request.houseShapeId
      ..ownerTypeId = event.ownerTypeId ?? request.ownerTypeId
      ..modelCode = event.modelCode ?? request.modelCode
      ..carpetArea = event.carpetArea ?? request.carpetArea
      ..builtUpArea = event.builtUpArea ?? request.builtUpArea
      ..floorOrdinalNumber = event.floorOrdinalNumber?.toInt() ?? request.floorOrdinalNumber
      ..mainDoorDirectionId = event.mainDoorDirectionId ?? request.mainDoorDirectionId
      ..windowDirectionId = event.windowDirectionId ?? request.windowDirectionId
      ..bedroom = event.bedroom ?? request.bedroom
      ..bathroom = event.bathroom ?? request.bathroom
      ..livingRoom = event.livingRoom ?? request.livingRoom
      ..kitchen = event.kitchen ?? request.kitchen
      ..certificateLandId = event.certificateLandId ?? request.certificateLandId
      ..yearBuilt = event.yearBuilt ?? request.yearBuilt
      ..expectedTimeId = event.expectedTimeId ?? request.expectedTimeId
      ..expectedPriceTo = event.expectedPriceTo ?? request.expectedPriceTo
      ..expectedPriceFrom = event.expectedPriceFrom ?? request.expectedPriceFrom
      ..latitude = event.latitude ?? request.latitude
      ..longitude = event.longitude ?? request.longitude
      ..cityId = event.cityId ?? request.cityId
      ..districtId = event.districtId ?? request.districtId
      ..address = event.address ?? request.address
      ..wardID = event.wardID ?? request.wardID
      ..streetId = event.streetId ?? request.streetId
      ..houseNumber = event.houseNumber ?? request.houseNumber
      ..contactName = event.contactName ?? request.contactName
      ..contactPhone = event.contactPhone ?? request.contactPhone
      ..contactEmail = event.contactEmail ?? request.contactEmail
      ..unspecifiedLocation = event.unspecifiedLocation ?? request.unspecifiedLocation
      ..blockBuildingId = event.blockBuildingId ?? request.blockBuildingId
      ..blockBuildingName = event.blockBuildingName ?? request.blockBuildingName
      ..buildingId = event.buildingId ?? request.buildingId
      ..buildingName = event.buildingName ?? request.buildingName;

    if (event.planning != null) {
      request.planning = PropzyHomeOfferPlanning(
        planningToBuy: event.planning?.planningToBuy ?? request.planning?.planningToBuy,
        propertyTypeId: event.planning?.propertyTypeId ?? request.planning?.propertyTypeId,
        priceFrom: event.planning?.priceFrom ?? request.planning?.priceFrom,
        priceTo: event.planning?.priceTo ?? request.planning?.priceTo,
        cities: event.planning?.cities ?? request.planning?.cities,
        districts: event.planning?.districts ?? request.planning?.districts,
        wards: event.planning?.wards ?? request.planning?.wards,
      );
    }

    final response = await updateOfferUseCase.call(request);
    Util.hideLoading();
    yield response.fold(
      (l) => UpdateOfferErrorState(),
      (r) {
        return UpdateOfferSuccessState();
      },
    );
  }

  Stream<PropzyHomeState> updateFacade(UpdateFacadeEvent event) async* {
    Util.showLoading();
    final request = _mapOfferToRequest();
    if (request.facadeRoad == null) {
      request.facadeRoad = PropzyHomeFacadeContentRoad();
    }
    request
      ..reachedPageId = event.reachedPageId ?? request.reachedPageId
      ..facadeType = Constants.FACADE_TYPE_ID_FOR_FACADE
      ..facadeAlley = null
      ..facadeRoad?.roadWidth = event.roadWidth
      ..facadeRoad?.contiguousId = event.id;

    final response = await updateOfferUseCase.call(request);
    Util.hideLoading();
    yield response.fold(
      (l) => UpdateOfferErrorState(),
      (r) {
        return UpdateOfferSuccessState();
      },
    );
  }

  Stream<PropzyHomeState> updateAlley(UpdateAlleyEvent event) async* {
    Util.showLoading();
    final request = _mapOfferToRequest();
    if (request.facadeAlley == null) {
      request.facadeAlley = PropzyHomeFacadeContentAlley();
    }
    request
      ..reachedPageId = event.reachedPageId ?? request.reachedPageId
      ..facadeRoad = null
      ..facadeType = Constants.FACADE_TYPE_ID_FOR_ALLEY
      ..facadeAlley?.alleyWidth = event.alleyWidth
      ..facadeAlley?.distanceToRoad = event.distanceToRoad
      ..facadeAlley?.contiguousId = event.id;

    final response = await updateOfferUseCase.call(request);
    Util.hideLoading();
    yield response.fold(
      (l) => UpdateOfferErrorState(),
      (r) {
        return UpdateOfferSuccessState();
      },
    );
  }

  int? getReachedPageId(String code) {
    int? reachPageId = propertyTypeSelected?.pageConfigs?.firstWhere((e) => e.code == code).pageId;
    return reachPageId;
  }

  PropzyHomeUpdateOfferRequest _mapOfferToRequest() {
    final offer = draftOffer;
    if (offer == null) {
      return PropzyHomeUpdateOfferRequest();
    }
    final request = PropzyHomeUpdateOfferRequest();
    request.id = offer.id;
    request.stepId = offer.stepId;
    request.reachedPageId = offer.reachedPageId;
    request.currentPage = offer.currentPage;
    request.status = offer.status;
    request.ownerTypeId = offer.ownerTypeId;
    request.assignedTo = offer.assignedTo;
    request.propertyTypeId = offer.propertyTypeId;
    request.address = offer.address;
    request.latitude = offer.latitude;
    request.longitude = offer.longitude;
    request.cityId = offer.cityId;
    request.districtId = offer.districtId;
    request.wardID = offer.wardID;
    request.streetId = offer.streetId;
    request.houseNumber = offer.houseNumber;
    request.length = offer.length;
    request.width = offer.width;
    request.lotSize = offer.lotSize;
    request.floorSize = offer.floorSize;
    request.numberFloor = offer.numberFloor;
    request.bathroom = offer.bathroom;
    request.bedroom = offer.bedroom;
    request.kitchen = offer.kitchen;
    request.livingRoom = offer.livingRoom;
    request.directionId = offer.directionId;
    request.certificateLandId = offer.certificateLandId;
    request.yearBuilt = offer.yearBuilt;
    request.facadeType = offer.facadeType;
    request.expectedTimeId = offer.expectedTimeId;
    request.expectedPriceFrom = offer.expectedPriceFrom;
    request.expectedPriceTo = offer.expectedPriceTo;
    request.suggestedPrice = offer.suggestedPrice;
    request.offeredPrice = offer.offeredPrice;
    request.contactName = offer.contactName;
    request.contactPhone = offer.contactPhone;
    request.contactEmail = offer.contactEmail;
    request.planning = offer.planning;
    request.facadeAlley = offer.facadeAlley;
    request.facadeAlley?.updateContiguousId();

    request.facadeRoad = offer.facadeRoad;
    request.facadeRoad?.updateContiguousId();

    request.houseTexturesIds = offer.houseTextures?.map((e) => e.id).toList();
    request.propertyInfo = offer.propertyInfo;
    request.unspecifiedLocation = offer.unspecifiedLocation;
    request.appointmentDate = offer.appointmentDate;
    request.modelCode = offer.modelCode;
    request.carpetArea = offer.carpetArea;
    request.builtUpArea = offer.builtUpArea;
    request.floorOrdinalNumber = offer.floorOrdinalNumber;
    request.mainDoorDirectionId = offer.mainDoorDirectionId;
    request.windowDirectionId = offer.windowDirectionId;
    request.view = offer.view;
    request.buildingId = offer.buildingId;
    request.buildingName = offer.buildingName;
    request.blockBuildingId = offer.blockBuildingId;
    request.blockBuildingName = offer.blockBuildingName;
    request.houseShapeId = offer.houseShapeId;
    request.ownerTypeId = offer.ownerTypeId;
    return request;
  }
}
