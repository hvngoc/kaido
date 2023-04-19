import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/common_model.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/header_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/utilities/bloc/utilities_info_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/utilities/bloc/utilities_info_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/utilities/bloc/utilities_info_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/app_style.dart';
import 'package:propzy_home/src/util/message_util.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class UtilitiesInfoScreen extends StatefulWidget {
  const UtilitiesInfoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UtilitiesInfoScreenState();
}

class _UtilitiesInfoScreenState extends State<UtilitiesInfoScreen> {
  final CreateListingBloc _createListingBloc = GetIt.instance.get<CreateListingBloc>();
  final UtilitiesInfoBloc _utilitiesInfoBloc = GetIt.instance.get<UtilitiesInfoBloc>();

  List<Advantage>? listAdvantages = [];
  List<Amenity>? listAmenities = [];
  String otherContent = "";
  TextEditingController _controllerOtherContent = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_createListingBloc.createListingRequest?.id != null) {
      _createListingBloc.add(
        GetDraftListingDetailEvent(_createListingBloc.createListingRequest!.id!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _utilitiesInfoBloc),
        BlocProvider(create: (_) => _createListingBloc),
      ],
      child: BlocConsumer<CreateListingBloc, BaseCreateListingState>(
        bloc: _createListingBloc,
        listener: (context, state) {
          if (ModalRoute.of(context)?.isCurrent == true) {
            if (state is GetDraftListingDetailSuccessState) {
              Util.hideLoading();
              DraftListing? draftListing = _createListingBloc.draftListing;
              if (draftListing?.listingType?.listingTypeID == CategoryType.BUY.type) {
                _utilitiesInfoBloc.add(LoadListAdvantageEvent());
              } else if (draftListing?.listingType?.listingTypeID == CategoryType.RENT.type) {
                _utilitiesInfoBloc.add(LoadListAmenityEvent());
              }
            } else if (state is ListingLoadingState) {
              Util.showLoading();
            } else if (state is ErrorMessageState) {
              Util.hideLoading();
              Util.showMyDialog(
                context: context,
                message: state.errorMessage ?? MessageUtil.errorMessageDefault,
              );
            }
          }
        },
        builder: (context, state) {
          return BlocConsumer<UtilitiesInfoBloc, UtilitiesInfoState>(
            bloc: _utilitiesInfoBloc,
            listener: (context, state) {
              if (state is LoadingState) {
                Util.showLoading();
              } else if (state is ErrorState) {
                Util.hideLoading();
                Util.showMyDialog(
                  context: context,
                  message: state.message ?? MessageUtil.errorMessageDefault,
                );
              } else if (state is SuccessUpdateUtilitiesInfoState) {
                Util.hideLoading();
                navigateToPostListing();
              } else if (state is SuccessLoadListAdvantageState) {
                Util.hideLoading();

                DraftListing? draftListing = _createListingBloc.draftListing;
                List<Advantage>? list = state.listAdvantages;
                if ((list?.length ?? 0) > 0) {
                  for (int i = 0; i < (list?.length ?? 0); i++) {
                    Advantage advantage = list![i];
                    advantage.isChecked = draftListing?.utilities
                            ?.indexWhere((element) => advantage.id == element.id) !=
                        -1;
                  }
                }

                setState(() {
                  listAdvantages = list;
                  listAmenities = null;
                });
              } else if (state is SuccessLoadListAmenityState) {
                Util.hideLoading();

                DraftListing? draftListing = _createListingBloc.draftListing;
                List<Amenity>? list = state.listAmenities;
                if ((list?.length ?? 0) > 0) {
                  for (int i = 0; i < (list?.length ?? 0); i++) {
                    Amenity amenity = list![i];
                    amenity.isChecked = draftListing?.utilities
                            ?.indexWhere((element) => amenity.id == element.id) !=
                        -1;
                  }
                }

                setState(() {
                  listAdvantages = null;
                  listAmenities = list;
                });
              }
            },
            builder: (context, state) {
              return _renderUI();
            },
          );
        },
      ),
    );
  }

  Widget _renderUI() {
    return Scaffold(
      appBar: PropzyAppBar(
        title: 'Đăng tin bất động sản',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // _renderHeaderBar(),
            // SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _renderProgressBar(),
                    SizedBox(height: 16),
                    _renderTitle(),
                    SizedBox(height: 8),
                    _renderSubTitle(),
                    SizedBox(height: 24),
                    _renderContent(),
                    SizedBox(height: 8),
                    _renderFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderHeaderBar() {
    return HeaderBarView();
  }

  Widget _renderProgressBar() {
    return CreateListingProgressBarView(
      currentStep: 2,
      currentScreenInStep: _createListingBloc.isPrivateHouseOrVillaDraft() ? 7 : 6,
      totalScreensInStep: _createListingBloc.isPrivateHouseOrVillaDraft() ? 8 : 7,
      parentPadding: 16,
    );
  }

  Widget _renderTitle() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(
          "Thông tin thêm về bất động sản của bạn",
          style: TextStyle(
            color: AppColor.secondaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _renderSubTitle() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(
          "Giới thiệu thêm về những tiện ích khác giúp bất động sản của bạn thu hút hơn",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColor.secondaryText,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _renderContent() {
    DraftListing? draftListing = _createListingBloc.draftListing;
    if (draftListing?.listingType?.listingTypeID == CategoryType.BUY.type) {
      int indexItemOther = listAdvantages?.indexWhere((element) => element.id == 20) ?? -1;
      List<Widget> listWidgets = [];
      for (int i = 0; i < (listAdvantages?.length ?? 0); i++) {
        listWidgets.add(_renderItemUtilities(context, i));
      }

      if (indexItemOther != -1) {
        listWidgets.add(_renderInputOtherUtilities());
      }

      return Expanded(
        child: ListView(
          children: listWidgets,
        ),
      );
    } else if (draftListing?.listingType?.listingTypeID == CategoryType.RENT.type) {
      int indexItemOther = listAmenities?.indexWhere((element) => element.id == 20) ?? -1;
      List<Widget> listWidgets = [];
      for (int i = 0; i < (listAmenities?.length ?? 0); i++) {
        listWidgets.add(_renderItemUtilities(context, i));
      }

      if (indexItemOther != -1) {
        listWidgets.add(_renderInputOtherUtilities());
      }

      return Expanded(
        child: ListView(
          children: listWidgets,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _renderFooter() {
    return PropzyHomeContinueButton(
      isEnable: true,
      fontWeight: FontWeight.w700,
      onClick: () {
        if (_createListingBloc.createListingRequest?.id != null) {
          List<int> utilities = [];
          bool isSelectedItemOther = false;

          DraftListing? draftListing = _createListingBloc.draftListing;
          if (draftListing?.listingType?.listingTypeID == CategoryType.BUY.type) {
            if (listAdvantages != null) {
              int indexItemOther = listAdvantages?.indexWhere((element) => element.id == 20) ?? -1;
              isSelectedItemOther = indexItemOther != -1;

              for (int i = 0; i < listAdvantages!.length; i++) {
                if (listAdvantages![i].isChecked == true) {
                  utilities.add(listAdvantages![i].id ?? 0);
                }
              }
            }
          } else if (draftListing?.listingType?.listingTypeID == CategoryType.RENT.type) {
            if (listAmenities != null) {
              int indexItemOther = listAmenities?.indexWhere((element) => element.id == 20) ?? -1;
              isSelectedItemOther = indexItemOther != -1;

              for (int i = 0; i < listAmenities!.length; i++) {
                if (listAmenities![i].isChecked == true) {
                  utilities.add(listAmenities![i].id ?? 0);
                }
              }
            }
          }

          UpdateUtilitiesListingRequest request = UpdateUtilitiesListingRequest(
            id: _createListingBloc.createListingRequest!.id!,
            utilities: utilities,
            content: isSelectedItemOther ? otherContent : null,
          );
          _utilitiesInfoBloc.add(UpdateUtilitiesInfoEvent(request));
        }
      },
    );
  }

  Widget _renderItemUtilities(BuildContext context, int index) {
    DraftListing? draftListing = _createListingBloc.draftListing;
    String? display = "";
    bool? isSelected = false;

    if (draftListing?.listingType?.listingTypeID == CategoryType.BUY.type) {
      Advantage advantage = listAdvantages![index];
      display = advantage.name;
      isSelected = advantage.isChecked;
    } else if (draftListing?.listingType?.listingTypeID == CategoryType.RENT.type) {
      Amenity amenity = listAmenities![index];
      display = amenity.name;
      isSelected = amenity.isChecked;
    }

    if (display?.isNotEmpty == true) {
      return InkWell(
        onTap: () {
          if (draftListing?.listingType?.listingTypeID == CategoryType.BUY.type) {
            listAdvantages!.elementAt(index).isChecked = !(listAdvantages![index].isChecked!);
            setState(() {
              listAdvantages = listAdvantages;
            });
          } else if (draftListing?.listingType?.listingTypeID == CategoryType.RENT.type) {
            listAmenities!.elementAt(index).isChecked = !(listAmenities![index].isChecked!);
            setState(() {
              listAmenities = listAmenities;
            });
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 8,
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: Util.checkboxFilter(isSelected),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                child: Text(
                  display ?? '',
                  style: BigRevampStyle.checkboxTextStyle,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }

  Widget _renderInputOtherUtilities() {
    InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: otherContent.isEmpty ? HexColor("D6180C") : HexColor("DBDBDB"),
        width: 1,
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Vui lòng thêm tiện ích cho BĐS của bạn",
                    style: TextStyle(
                      color: AppColor.secondaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: " *",
                    style: TextStyle(
                      color: HexColor("DD3E3A"),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _controllerOtherContent,
            decoration: InputDecoration(
              hintText: "Ví dụ: Nhà có máy nước nóng, lạnh sử dụng năng lượng mặt trời...",
              hintStyle: TextStyle(
                color: Color.fromRGBO(54, 54, 54, 0.8),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
              labelStyle: TextStyle(
                color: AppColor.secondaryText,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              focusedBorder: border,
              enabledBorder: border,
              disabledBorder: border,
            ),
            maxLines: 6,
            keyboardType: TextInputType.multiline,
            inputFormatters: [LengthLimitingTextInputFormatter(300)],
            onChanged: (value) {
              setState(() {
                otherContent = value;
              });
            },
          ),
        ],
      ),
    );
  }

  void navigateToPostListing() {
    final listingId = _createListingBloc.createListingRequest?.id;
    if (listingId != null) {
      NavigationController.navigateToTitleDescriptionCreateListing(context, listingId);
    }
  }
}
