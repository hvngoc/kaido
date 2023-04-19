import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_direction.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/bold_section_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/field_text_drop_no_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/field_text_input_no_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/in_house/bloc/in_house_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/in_house/bloc/in_house_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/in_house/bloc/in_house_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/presentation/view/sort_item_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/decimal_input_formatter.dart';
import 'package:propzy_home/src/util/extensions.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class InHouseWidget extends StatefulWidget {
  final CreateListingBloc _helper = GetIt.instance.get<CreateListingBloc>();

  final int propertiesType;
  final int listingID;

  InHouseWidget({
    Key? key,
    required this.listingID,
    required this.propertiesType,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    if (_helper.isHouse(propertiesType)) {
      return InHouseHouseState();
    } else if (_helper.isLand(propertiesType)) {
      return InHouseLandState();
    } else {
      return InHouseOtherState();
    }
  }
}

class InHouseHouseState extends InHouseState {
  @override
  bool isValid() {
    return Util.isDecimalNumber(length) &&
        Util.isDecimalNumber(width) &&
        Util.isDecimalNumber(lotSize) &&
        Util.isDecimalNumber(floorSize) &&
        bedroom != null &&
        directionId != null &&
        bathroom != null;
  }
}

class InHouseLandState extends InHouseState {
  @override
  bool requireFloorSize = false;

  @override
  bool showBathroom = false;

  @override
  bool showBedroom = false;

  @override
  bool isValid() {
    return Util.isDecimalNumber(length) &&
        Util.isDecimalNumber(width) &&
        Util.isDecimalNumber(lotSize) &&
        directionId != null;
  }
}

class InHouseOtherState extends InHouseState {
  @override
  bool requireLotSize = false;

  @override
  bool showLength = false;

  @override
  bool showWidth = false;

  @override
  bool isValid() {
    return Util.isDecimalNumber(floorSize) &&
        bedroom != null &&
        directionId != null &&
        bathroom != null;
  }
}

abstract class InHouseState extends State<InHouseWidget> {
  final InHouseBloc _bloc = InHouseBloc();
  final CreateListingBloc _createListingBloc = CreateListingBloc();

  bool showLength = true;
  bool showWidth = true;
  bool showBedroom = true;
  bool showBathroom = true;

  bool requireFloorSize = true;
  bool requireLotSize = true;

  double? length = null;
  double? width = null;
  double? lotSize = null;
  double? floorSize = null;

  HomeDirection? directionId = null;
  int? bedroom = null;
  int? bathroom = null;

  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController lotSizeController = TextEditingController();
  final TextEditingController floorSizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc.add(LoadDirectionEvent());
    _createListingBloc.add(GetDraftListingDetailEvent(widget.listingID));
  }

  @override
  void dispose() {
    super.dispose();
    lengthController.dispose();
    widthController.dispose();
    lotSizeController.dispose();
    floorSizeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> listWidget = [];
    if (showLength) {
      final view = Column(
        children: [
          BoldSectionTitle(
            text: 'Chiều dài',
            paddingLeft: 0,
          ),
          SizedBox(height: 4),
          FieldTextInputNoTitle(
            unit: 'm',
            hint: 'Nhập số',
            textEditingController: lengthController,
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp('[-|\ ]'),
              ),
              DecimalInputFormatter(),
            ],
            onChanged: (value) {
              length = value.parseVndDouble();
              setState(() {});
            },
          ),
        ],
      );
      listWidget.add(view);
    }
    if (showWidth) {
      final view = Column(
        children: [
          BoldSectionTitle(
            text: 'Chiều rộng',
            paddingLeft: 0,
          ),
          SizedBox(height: 4),
          FieldTextInputNoTitle(
            unit: 'm',
            hint: 'Nhập số',
            textEditingController: widthController,
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp('[-|\ ]'),
              ),
              DecimalInputFormatter(),
            ],
            onChanged: (value) {
              width = value.parseVndDouble();
              setState(() {});
            },
          ),
        ],
      );
      listWidget.add(view);
    }
    final viewLotSize = Column(
      children: [
        BoldSectionTitle(
          text: 'Diện tích đất',
          displayStar: requireLotSize,
          paddingLeft: 0,
        ),
        SizedBox(height: 4),
        FieldTextInputNoTitle(
          unit: 'm²',
          hint: 'Nhập số',
          textEditingController: lotSizeController,
          inputFormatters: [
            FilteringTextInputFormatter.deny(
              RegExp('[-|\ ]'),
            ),
            DecimalInputFormatter(),
          ],
          onChanged: (value) {
            lotSize = value.parseVndDouble();
            setState(() {});
          },
        ),
      ],
    );
    listWidget.add(viewLotSize);
    final viewFloorSize = Column(
      children: [
        BoldSectionTitle(
          text: 'Diện tích sử dụng',
          displayStar: requireFloorSize,
          paddingLeft: 0,
        ),
        SizedBox(height: 4),
        FieldTextInputNoTitle(
          unit: 'm²',
          hint: 'Nhập số',
          textEditingController: floorSizeController,
          inputFormatters: [
            FilteringTextInputFormatter.deny(
              RegExp('[-|\ ]'),
            ),
            DecimalInputFormatter(),
          ],
          onChanged: (value) {
            floorSize = value.parseVndDouble();
            setState(() {});
          },
        ),
      ],
    );
    listWidget.add(viewFloorSize);
    if (showBedroom) {
      final view = Column(
        children: [
          BoldSectionTitle(
            text: 'Số phòng ngủ',
            paddingLeft: 0,
          ),
          SizedBox(height: 4),
          FieldTextDropNoTitle(
            hint: 'Chọn số',
            title: bedroom?.toString(),
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              showModalBottomSheet(context: context, builder: showPickerBedroom);
            },
          ),
        ],
      );
      listWidget.add(view);
    }
    if (showBathroom) {
      final view = Column(
        children: [
          BoldSectionTitle(
            text: 'Số phòng tắm',
            paddingLeft: 0,
          ),
          SizedBox(height: 4),
          FieldTextDropNoTitle(
            title: bathroom?.toString(),
            hint: 'Chọn số',
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              showModalBottomSheet(context: context, builder: showPickerBathroom);
            },
          ),
        ],
      );
      listWidget.add(view);
    }
    final viewDirection = Column(
      children: [
        BoldSectionTitle(
          text: 'Hướng',
          paddingLeft: 0,
        ),
        SizedBox(height: 4),
        FieldTextDropNoTitle(
          title: directionId?.name,
          hint: 'Chọn hướng',
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            showModalBottomSheet(context: context, builder: showPickerDirection);
          },
        ),
      ],
    );
    listWidget.add(viewDirection);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _bloc),
        BlocProvider(create: (_) => _createListingBloc),
      ],
      child: MultiBlocListener(
          listeners: [
            BlocListener<CreateListingBloc, BaseCreateListingState>(
              bloc: _createListingBloc,
              listener: (context, state) {
                if (state is GetDraftListingDetailSuccessState) {
                  length = _createListingBloc.draftListing?.sizeLength;
                  width = _createListingBloc.draftListing?.sizeWidth;
                  lotSize = _createListingBloc.draftListing?.lotSize;
                  floorSize = _createListingBloc.draftListing?.floorSize;

                  lengthController.text = length?.toString().trailing000() ?? '';
                  widthController.text = width?.toString().trailing000() ?? '';
                  lotSizeController.text = lotSize?.toString().trailing000() ?? '';
                  floorSizeController.text = floorSize?.toString().trailing000() ?? '';

                  final direction = _createListingBloc.draftListing?.direction;
                  if (direction != null) {
                    directionId = HomeDirection(direction.id, direction.name);
                  }
                  bedroom = _createListingBloc.draftListing?.bedrooms;
                  bathroom = _createListingBloc.draftListing?.bathrooms;
                  setState(() {});
                }
              },
            ),
            BlocListener<InHouseBloc, BaseInHouseState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is InHouseStateSuccess) {
                  NavigationController.navigateCreateLegalDocs(context, widget.listingID);
                }
              },
            )
          ],
          child: Scaffold(
            appBar: PropzyAppBar(
              title: 'Đăng tin bất động sản',
            ),
            body: SafeArea(
              child: Column(
                children: [
                  CreateListingProgressBarView(
                    currentStep: 2,
                    currentScreenInStep: _createListingBloc.isPrivateHouseOrVillaDraft() ? 4 : 3,
                    totalScreensInStep: _createListingBloc.isPrivateHouseOrVillaDraft() ? 8 : 7,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Diện tích và hướng bất động sản của bạn',
                      style: TextStyle(
                        color: AppColor.secondaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Cung cấp thông tin đầy đủ giúp bạn tiếp cận được nhiều khách hàng hơn',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColor.secondaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      padding: EdgeInsets.all(16),
                      physics: ClampingScrollPhysics(),
                      childAspectRatio: 1 / .5,
                      // primary: false,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 6,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      children: listWidget,
                    ),
                  ),
                  PropzyHomeContinueButton(
                    isEnable: isValid(),
                    onClick: () {
                      _bloc.add(
                        UpdateInHouseEvent(
                          id: widget.listingID,
                          bathrooms: bathroom,
                          bedrooms: bedroom,
                          directionId: directionId?.id,
                          floorSize: floorSize,
                          lotSize: lotSize,
                          sizeWidth: width,
                          sizeLength: length,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }

  bool isValid();

  Widget showPickerDirection(BuildContext context) {
    return _showPickerDialog(context, 'Chọn hướng', _bloc.listDirections, directionId, (e) {
      directionId = e;
      Navigator.pop(context);
      setState(() {});
    });
  }

  Widget _showPickerDialog(
    BuildContext context,
    String title,
    List<HomeDirection>? list,
    HomeDirection? current,
    Function(HomeDirection) callback,
  ) {
    if (list == null) {
      return Container();
    }
    List<Widget> view = list
        .map((e) => SortItemChildView(
            text: e.name ?? '',
            isChecked: e.id == current?.id,
            onClick: () {
              callback(e);
            }))
        .toList();
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  color: AppColor.blackDefault,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) => view[index],
                itemCount: view.length,
                padding: EdgeInsets.only(left: 20, right: 20),
                separatorBuilder: (c, i) {
                  return Divider(
                    color: AppColor.dividerGray,
                    height: 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showPickerBedroom(BuildContext context) {
    return _showNumbersDialog(context, 'Số phòng ngủ', bedroom, (e) {
      bedroom = e;
      setState(() {});
    });
  }

  Widget showPickerBathroom(BuildContext context) {
    return _showNumbersDialog(context, 'Số phòng tắm', bathroom, (e) {
      bathroom = e;
      setState(() {});
    });
  }

  Widget _showNumbersDialog(
    BuildContext context,
    String title,
    int? current,
    Function(int) callback,
  ) {
    List<Widget> view = _bloc.numbers
        .map((e) => SortItemChildView(
            text: e.toString(),
            isChecked: e == current,
            onClick: () {
              callback(e);
              Navigator.pop(context);
            }))
        .toList();
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  color: AppColor.blackDefault,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) => view[index],
                itemCount: view.length,
                padding: EdgeInsets.only(left: 20, right: 20),
                separatorBuilder: (c, i) {
                  return Divider(
                    color: AppColor.dividerGray,
                    height: 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
