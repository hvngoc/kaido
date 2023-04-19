import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/domain/request/listing_price_request.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/bold_section_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/title_description_info_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_expected_price/bloc/create_listing_expected_price_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_price.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/util/alert_dialog.dart';
import 'package:propzy_home/src/util/message_util.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/util/util.dart';

class CreateListingExpectedPriceScreen extends StatefulWidget {
  const CreateListingExpectedPriceScreen({
    Key? key,
    required this.listingId,
  }) : super(key: key);

  final int listingId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateListingExpectedPriceScreenState();
  }
}

class CreateListingExpectedPriceScreenState
    extends State<CreateListingExpectedPriceScreen> {
  CreateListingBloc _createListingBloc = GetIt.I.get<CreateListingBloc>();
  CreateListingExpectedPriceBloc _createListingExpectedPriceBloc =
      CreateListingExpectedPriceBloc();
  int? _expectedPrice = null;
  int? _expectedPriceInit = null;
  ListingPriceRequest _request = ListingPriceRequest();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_createListingBloc.createListingRequest?.id != null) {
      _createListingBloc.add(GetDraftListingDetailEvent(
          _createListingBloc.createListingRequest!.id!));
    }
    _request.id = widget.listingId;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PropzyAppBar(
        title: 'Đăng tin bất động sản',
      ),
      body: SafeArea(
        child: BlocConsumer(
          bloc: _createListingBloc,
          listener: (context, state) {
            Util.hideLoading();
            if (state is ListingLoadingState) {
              Util.showLoading();
            }
            if (state is ErrorMessageState) {
              AppAlert.showErrorAlert(
                context,
                state.errorMessage ?? MessageUtil.errorMessageDefault,
              );
              return;
            }
            if (state is GetDraftListingDetailSuccessState) {
              final draftListing = _createListingBloc.draftListing;
              if (draftListing != null) {
                setState(() {
                  _expectedPriceInit = draftListing.priceVND?.toInt();
                  _expectedPrice = draftListing.priceVND?.toInt();
                });
              }
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      CreateListingProgressBarView(
                        currentStep: 2,
                        currentScreenInStep: 2,
                        totalScreensInStep: 8,
                      ),
                      TitleDescriptionInfoView(
                        title: 'Mức giá mong muốn',
                        description:
                            'Giá hợp lý, minh bạch giúp giao dịch diễn ra nhanh chóng',
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      BoldSectionTitle(
                        text: 'Mức giá mong muốn',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: FieldTextPrice(
                          hint: 'Nhập giá',
                          unit: 'VND',
                          initValue: _expectedPriceInit?.toString(),
                          allowZero: false,
                          onChange: (e) {
                            _expectedPrice = e;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BlocListener(
                    bloc: _createListingExpectedPriceBloc,
                    listener: (context, state) {
                      // TODO: implement listener
                      Util.hideLoading();
                      if (state is LoadingState) {
                        Util.showLoading();
                      }
                      if (state is SuccessState) {
                        // US 10
                        int? listingTypeId = _createListingBloc
                            .draftListing?.listingType?.listingTypeID;
                        if (listingTypeId == CategoryType.BUY.type) {
                          NavigationController
                              .navigateToUtilitiesInfoCreateListing(context);
                          return;
                        }
                        if (listingTypeId == CategoryType.RENT.type) {
                          int? propertyTypeId =
                              _createListingBloc.draftListing?.propertyType?.id;
                          if (propertyTypeId != null &&
                              _createListingBloc.isRentGroundOrAgriculturalLand(
                                      propertyTypeId) ==
                                  false) {
                            NavigationController
                                .navigateToUtilitiesInfoCreateListing(context);
                            return;
                          }
                        }
                        // US 11
                        NavigationController
                            .navigateToTitleDescriptionCreateListing(
                          context,
                          widget.listingId,
                        );
                        return;
                      }
                      if (state is ErrorState) {
                        AppAlert.showErrorAlert(
                          context,
                          state.errorMessage ?? MessageUtil.errorMessageDefault,
                        );
                      }
                    },
                    child: PropzyHomeContinueButton(
                      isEnable: _isValid(),
                      onClick: () {
                        _request.priceVND = _expectedPrice;
                        _createListingExpectedPriceBloc
                            .add(UpdateListingPriceEvent(
                          request: _request,
                        ));
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _isValid() {
    return _expectedPrice != null;
  }
}
