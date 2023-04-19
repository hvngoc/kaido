import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/request/listing_texture_request.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/bold_section_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/title_description_info_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_texture/bloc/create_listing_texture_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_input.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/util/alert_dialog.dart';
import 'package:propzy_home/src/util/app_style.dart';
import 'package:propzy_home/src/util/decimal_input_formatter.dart';
import 'package:propzy_home/src/util/message_util.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';
import 'package:string_validator/string_validator.dart';

class CreateListingTextureScreen extends StatefulWidget {
  const CreateListingTextureScreen({
    Key? key,
    required this.listingId,
    required this.propertyTypeId,
  }) : super(key: key);

  final int listingId;
  final int propertyTypeId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateListingTextureScreenState();
  }
}

class CreateListingTextureScreenState
    extends State<CreateListingTextureScreen> {
  int? _numberOfFloor = null;
  bool _isValid = false;
  TextEditingController _numberOfFloorController =
      TextEditingController(text: '');
  CreateListingBloc _createListingBloc = GetIt.I.get<CreateListingBloc>();
  CreateListingTextureBloc _createListingTextureBloc =
      CreateListingTextureBloc();
  ListingTextureRequest _request = ListingTextureRequest();

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _numberOfFloorController.dispose();
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
            // TODO: implement listener
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
              setState(() {
                _request.isMezzanine =
                    _createListingBloc.draftListing?.isMezzanine ?? false;
                _request.isAttic =
                    _createListingBloc.draftListing?.isAttic ?? false;
                _request.isRooftop =
                    _createListingBloc.draftListing?.isRooftop ?? false;
                _request.isPenthouse =
                    _createListingBloc.draftListing?.isPenthouse ?? false;
                _request.isBasement =
                    _createListingBloc.draftListing?.isBasement ?? false;

                if (_createListingBloc.draftListing?.numberFloor != null) {
                  _numberOfFloor = _createListingBloc.draftListing?.numberFloor;
                  _numberOfFloorController = TextEditingController(
                    text:
                        _createListingBloc.draftListing?.numberFloor.toString(),
                  );
                } else {
                  _numberOfFloorController = TextEditingController(
                    text: '',
                  );
                }
                _checkValid();
              });
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
                        title: 'Kết cấu căn nhà của bạn',
                        description:
                            'Mô tả chi tiết giúp tin đăng bất động sản của bạn minh bạch và thu hút nhiều khách hàng hơn. Vì thế đừng bỏ qua bất kỳ chi tíết nào.',
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      BoldSectionTitle(
                        text: 'Số tầng',
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: FieldTextInput(
                          keyboardType: TextInputType.numberWithOptions(),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          isFixFieldSize: false,
                          title: '',
                          childWidth: 150,
                          unit: 'tầng',
                          hint: null,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                            FilteringTextInputFormatter.allow(
                              RegExp('[0-9]'),
                            ),
                            FilteringTextInputFormatter.deny(
                              RegExp(r'^0+'),
                            ),
                          ],
                          textEditingController: _numberOfFloorController,
                          onChanged: (str) {
                            if (str.length > 0 && isNumeric(str)) {
                              _numberOfFloor = int.parse(str);
                            } else {
                              _numberOfFloor = null;
                            }
                            _checkValid();
                          },
                        ),
                      ),
                      BoldSectionTitle(
                        text: 'Kết cấu căn nhà',
                        displayStar: false,
                      ),
                      GridView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (2 / .5),
                        ),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return _buildCheckBox(
                                title: 'Có tầng lửng',
                                isSelected: _request.isMezzanine,
                                onTap: () {
                                  setState(() {
                                    _request.isMezzanine =
                                        !_request.isMezzanine;
                                  });
                                },
                              );
                            case 1:
                              return _buildCheckBox(
                                title: 'Có gác xếp',
                                isSelected: _request.isAttic,
                                onTap: () {
                                  setState(() {
                                    _request.isAttic = !_request.isAttic;
                                  });
                                },
                              );
                            case 2:
                              return _buildCheckBox(
                                title: 'Có sân thượng',
                                isSelected: _request.isRooftop,
                                onTap: () {
                                  setState(() {
                                    _request.isRooftop = !_request.isRooftop;
                                  });
                                },
                              );
                            case 3:
                              return _buildCheckBox(
                                title: 'Có áp mái',
                                isSelected: _request.isPenthouse,
                                onTap: () {
                                  setState(() {
                                    _request.isPenthouse =
                                        !_request.isPenthouse;
                                  });
                                },
                              );
                            case 4:
                              return _buildCheckBox(
                                title: 'Có tầng hầm',
                                isSelected: _request.isBasement,
                                onTap: () {
                                  setState(() {
                                    _request.isBasement = !_request.isBasement;
                                  });
                                },
                              );
                            default:
                              return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BlocListener(
                    bloc: _createListingTextureBloc,
                    listener: (context, state) {
                      // TODO: implement listener
                      Util.hideLoading();

                      if (state is LoadingState) {
                        Util.showLoading();
                      }

                      if (state is SuccessState) {
                        // US5
                        if (_createListingBloc.isHouse(widget.propertyTypeId) ||
                            _createListingBloc.isLand(widget.propertyTypeId)) {
                          NavigationController
                              .navigateToChooseFacadeCreateListing(
                            context,
                            widget.listingId,
                            widget.propertyTypeId,
                          );
                          return;
                        }
                        //US 6
                        NavigationController
                            .navigateToChooseProjectInfoCreateListing(
                          context,
                          widget.listingId,
                          widget.propertyTypeId,
                          _createListingBloc
                                  .draftListing?.district?.districtId ??
                              0,
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
                      isEnable: _isValid,
                      onClick: () {
                        _createListingTextureBloc.add(UpdateTextureEvent(
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

  void _checkValid() {
    setState(() {
      if (_numberOfFloor != null) {
        _request.numberFloor = _numberOfFloor!;
        _isValid = true;
      } else {
        _request.numberFloor = 0;
        _isValid = false;
      }
    });
  }

  Widget _buildCheckBox({
    required String title,
    required isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
            width: 111,
            child: Text(
              title,
              style: BigRevampStyle.checkboxTextStyle,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
