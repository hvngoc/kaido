import 'package:flutter/material.dart';
import 'package:propzy_home/src/domain/model/delete_account_info.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_property_type_model.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/input/input_address.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/address/map/confirm_map_address.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_facade/choose_facade_widget.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_media/choose_media_widget.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_project_info/choose_project_info_widget.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_property/choose_property_widget.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/contact_info/owner_info.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_expected_price/create_listing_expected_price.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_texture/create_listing_texture.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/in_house/in_house_widget.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/legal_documents/legal_documents_widget.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/plan_to_buy/plan_to_buy_widget.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/thank_you/thank_you_widget.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/title_description/title_description_widget.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/utilities/utilities_info.dart';
import 'package:propzy_home/src/presentation/ui/delete_account/delete_account_confirm.dart';
import 'package:propzy_home/src/presentation/ui/delete_account/delete_account_count_down.dart';
import 'package:propzy_home/src/presentation/ui/delete_account/delete_account_input.dart';
import 'package:propzy_home/src/presentation/ui/key_condo/key_condo_web_view.dart';
import 'package:propzy_home/src/presentation/ui/listing/detail/detail_listing_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/complete_request/complete_request.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/complete_request/invalid_request.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/confirm_owner/confirm_owner.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/contact_info/contact_info.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/detail_offer/detail_offer.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/loading_process_request/loading_process_request_page.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/my_offer/list_media_slider_my_offer.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/my_offer/my_offer.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/pick_address.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/apartment/step_1/apartment_step_1.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/apartment/step_2/apartment_step_2.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_1/information_step_1.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_10/information_step_10.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_2/information_step_2.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_3/information_step_3.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_4/information_step_4.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_5/information_step_5.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_6/information_step_6.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_7/information_step_7.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_8/information_step_8.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_9/information_step_9.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_media/property_media.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_type/property_type.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/purchase_price/purchase_price.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/summary/summary.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';
import 'package:propzy_home/src/presentation/ui/update_profile/update_profile_screen.dart';

import 'nav_helper.dart';

class NavigationController {
  static void navigateToIBuyPropertyType(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PropertyTypeScreen(),
    //   ),
    // );
    navigateToWidgets(
      context,
      [
        PropertyTypeScreen(isResetOffer: true),
      ],
    );
  }

  static void navigateToIBuyPickAddress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickAddressScreen(),
      ),
    );
  }

  static void navigateToIBuySummary(BuildContext context,
      {Function(dynamic)? callBack = null}) async {
    final result = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(),
      ),
    );

    callBack?.call(result);
  }

  static void navigateToIBuyConfirmOwner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmOwnerScreen(),
      ),
    );
  }

  static void navigateToIBuyContactInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactInfoScreen(),
      ),
    );
  }

  static void navigateToIBuyQAHomeStep1(BuildContext context,
      {Function(dynamic)? callBack = null}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeInformationStep1(),
      ),
    );

    callBack?.call(result);
  }

  static void navigateToIBuyQAHomeStep2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeInformationStep2(),
      ),
    );
  }

  static void navigateToIBuyQAHomeStep3(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeInformationStep3(),
      ),
    );
  }

  static void navigateToIBuyQAHomeStep4(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeInformationStep4(),
      ),
    );
  }

  static void navigateToIBuyQAHomeStep5(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeInformationStep5(),
      ),
    );
  }

  static void navigateToIBuyQAHomeStep6(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeInformationStep6(),
      ),
    );
  }

  static void navigateToIBuyQAHomeStep7(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeInformationStep7(),
      ),
    );
  }

  static void navigateToIBuyQAHomeStep8(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeInformationStep8(),
      ),
    );
  }

  static void navigateToIBuyQAHomeStep9(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeInformationStep9(),
      ),
    );
  }

  static void navigateToIBuyQAHomeStep10(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeInformationStep10(),
      ),
    );
  }

  static void navigateToIBuyApartmentStep1(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApartmentStep1(),
      ),
    );
  }

  static void navigateToIBuyApartmentStep2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApartmentStep2(),
      ),
    );
  }

  static void navigateToCompleteRequest(BuildContext context, int offerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompleteRequest(offerId: offerId),
      ),
    );
  }

  static void navigateToInvalidRequest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvalidRequest(),
      ),
    );
  }

  static void navigateToPropertyMedia(BuildContext context, int offerId,
      {int typeSource = 1}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PropertyMedia(offerId: offerId, typeSource: typeSource),
      ),
    );
  }

  static void navigateToLoadingProcessRequest(
      BuildContext context, int offerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingProcessRequestPage(offerId: offerId),
      ),
    );
  }

  static void navigateToPurchasePrice(BuildContext context, int offerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchasePrice(offerId: offerId),
      ),
    );
  }

  static void navigateToMyOffer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyOfferScreen(),
      ),
    );
  }

  static void navigateToListMediaSliderMyOffer(
      BuildContext context, List<HomeFileModel>? files) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListMediaSliderMyOfferScreen(files: files),
      ),
    );
  }

  static void navigateToDetailOffer(BuildContext context, int offerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailOffer(offerId: offerId),
      ),
    );
  }

  static void navigateToKeyCondo(BuildContext context, String? projectId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KeyCondoWebView(projectId: projectId),
      ),
    );
  }

  static void navigateToListingDetail(BuildContext context, int listingId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailListingPage(listingId: listingId),
      ),
    );
  }

  static void navigateToWidgets(BuildContext context, List<Widget> widgets) {
    List<MaterialPageRoute> routes = [];
    for (Widget widget in widgets) {
      routes.add(MaterialPageRoute(builder: (context) => widget));
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Nav(
          routes: routes,
        ),
      ),
    );
  }

  static void navigateCreatePropertyType(BuildContext context, int listingId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChoosePropertyWidget(listingId: listingId),
      ),
    );
  }

  static void navigateCreateNumberOfRoom(
      BuildContext context, int listingId, int propertiesType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            InHouseWidget(listingID: listingId, propertiesType: propertiesType),
      ),
    );
  }

  static void navigateCreateLegalDocs(BuildContext context, int listingId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LegalDocsWidget(listingId: listingId),
      ),
    );
  }

  static void navigateThankYouPage(
    BuildContext context,
    int listingId, {
    bool showRecommend = false,
    ChooserData? districtId = null,
    int? priceFrom = null,
    int? priceTo = null,
    ChooserData? propertyTypeId = null,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThankYouWidget(
          listingId: listingId,
          showRecommend: showRecommend,
          districtId: districtId,
          priceFrom: priceFrom,
          priceTo: priceTo,
          propertyTypeId: propertyTypeId,
        ),
      ),
    );
  }

  static void navigatePlanToBuy(BuildContext context, int listingId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanToBuyWidget(listingId: listingId),
      ),
    );
  }

  static void navigateToChooseFacadeCreateListing(
      BuildContext context, int listingID, int propertiesType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseFacadeWidget(
            listingID: listingID, propertiesType: propertiesType),
      ),
    );
  }

  static void navigateToChooseProjectInfoCreateListing(
      BuildContext context, int listingID, int propertiesType, int districtId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseProjectInfoWidget(
            listingID: listingID,
            propertiesType: propertiesType,
            districtId: districtId),
      ),
    );
  }

  static void navigateToChooseMediaCreateListing(
      BuildContext context, int listingID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseMediaWidget(listingID: listingID),
      ),
    );
  }

  static void navigateToInputAddressCreateListing(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => InputAddressScreen(),
    //   ),
    // );
    navigateToWidgets(
      context,
      [
        InputAddressScreen(),
      ],
    );
  }

  static void navigateToConfirmMapAddressCreateListing(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmMapAddressScreen(),
      ),
    );
  }

  static void navigateToUpdateProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return UpdateProfileScreen(
            navTitle: 'Thông tin tài khoản',
          );
        },
      ),
    );
  }

  static void navigateToDeleteAccount(BuildContext context) {
    NavigationController.navigateToWidgets(
      context,
      [
        DeleteAccountConfirmScreen(),
      ],
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return DeleteAccountConfirmScreen();
    //     },
    //   ),
    // );
  }

  static void navigateToDeleteAccountInput(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DeleteAccountInputScreen();
        },
      ),
    );
  }

  static void navigateToDeleteAccountCountDown(
    BuildContext context,
    DeleteAccountInfo info,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DeleteAccountCountDownScreen(
            info: info,
          );
        },
      ),
    );
  }

  static void navigateToOwnerInfoCreateListing(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OwnerInfoScreen(),
      ),
    );
  }

  static void navigateToUtilitiesInfoCreateListing(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UtilitiesInfoScreen(),
      ),
    );
  }

  static void navigateToTextureCreateListing(
    BuildContext context, {
    required int listingId,
    required int propertyTypeId,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateListingTextureScreen(
            listingId: listingId, propertyTypeId: propertyTypeId),
      ),
    );
  }

  static void navigateToTitleDescriptionCreateListing(
      BuildContext context, int listingId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TitleDescriptionWidget(listingId: listingId),
      ),
    );
  }

  static void navigateToExpectedPriceCreateListing(
    BuildContext context, {
    required int listingId,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateListingExpectedPriceScreen(
          listingId: listingId,
        ),
      ),
    );
  }
}
