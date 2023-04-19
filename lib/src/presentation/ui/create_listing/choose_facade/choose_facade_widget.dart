import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/listing_alley.dart';
import 'package:propzy_home/src/domain/request/listing_position_request.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_facade/bloc/choose_facade_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/bold_section_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/field_text_drop_no_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/field_text_input_no_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/header_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/title_description_info_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/presentation/view/sort_item_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/decimal_input_formatter.dart';
import 'package:propzy_home/src/util/extensions.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class ChooseFacadeWidget extends StatefulWidget {
  const ChooseFacadeWidget({
    Key? key,
    required this.propertiesType,
    required this.listingID,
  }) : super(key: key);

  final int propertiesType;
  final int listingID;

  @override
  State<ChooseFacadeWidget> createState() => _ChooseFacadeWidgetState();
}

class _ChooseFacadeWidgetState extends State<ChooseFacadeWidget> {
  final ChooseFacadeBloc _bloc = ChooseFacadeBloc();
  final CreateListingBloc _createListingBloc = GetIt.instance.get<CreateListingBloc>();
  final String currentStep = "POSITION_STEP";

  TextEditingController _controller = TextEditingController();

  bool chooseRoad = true;
  bool chooseAlley = false;

  double? roadWidth = null;
  ListingAlley? alleyId;
  RoadFrontageDistanceType? roadFrontageDistance;

  @override
  void initState() {
    super.initState();
    _bloc.add(GetListAlleysEvent());
    _createListingBloc.add(GetDraftListingDetailEvent(widget.listingID));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPrivateHouseOrVilla = _createListingBloc.isHouse(widget.propertiesType);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _bloc),
        BlocProvider(create: (_) => _createListingBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ChooseFacadeBloc, ChooseFacadeState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is UpdatePositionSuccess) {
                NavigationController.navigateCreateNumberOfRoom(
                    context, widget.listingID, widget.propertiesType);
              }
            },
          ),
          BlocListener<CreateListingBloc, BaseCreateListingState>(
            bloc: _createListingBloc,
            listener: (context, state) {
              if (state is GetDraftListingDetailSuccessState) {
                final lsoListingDraftPosition =
                    _createListingBloc.draftListing?.lsoListingDraftPosition;
                if (lsoListingDraftPosition != null) {
                  final positionId =
                      lsoListingDraftPosition.positionId ?? Constants.FACADE_TYPE_ID_FOR_FACADE;
                  if (positionId == Constants.FACADE_TYPE_ID_FOR_FACADE) {
                    chooseRoad = true;
                    chooseAlley = false;
                    final roadFrontageWidth = lsoListingDraftPosition.roadFrontageWidth;
                    if (roadFrontageWidth != null) {
                      roadWidth = roadFrontageWidth;
                      _controller.text = '${roadWidth}';
                    }
                  } else if (positionId == Constants.FACADE_TYPE_ID_FOR_ALLEY) {
                    chooseRoad = false;
                    chooseAlley = true;
                    alleyId = lsoListingDraftPosition.alley;
                    final min = lsoListingDraftPosition.roadFrontageDistanceFrom;
                    final max = lsoListingDraftPosition.roadFrontageDistanceTo;
                    if (min != null) {
                      roadFrontageDistance = RoadFrontageDistanceType.fromMinMax(min, max);
                    }
                  }
                }
                setState(() {});
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: PropzyAppBar(
            title: 'Đăng tin bất động sản',
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      CreateListingProgressBarView(
                        currentStep: 2,
                        currentScreenInStep: isPrivateHouseOrVilla ? 3 : 2,
                        totalScreensInStep: isPrivateHouseOrVilla ? 8 : 7,
                      ),
                      TitleDescriptionInfoView(
                        title: 'Vị trí bất động sản của bạn',
                        description:
                            'Cung cấp thông tin đầy đủ giúp bạn tiếp cận được nhiều khách hàng hơn',
                      ),
                      _renderChooseFacadeType(),
                      SizedBox(height: 12),
                      _renderDetailFacade(),
                      _renderDetailAlley(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OrangeButton(
                    title: 'Tiếp tục',
                    isEnabled:
                    (chooseRoad && roadWidth != null && Util.isDecimalNumber(roadWidth)) ||
                        (chooseAlley && alleyId != null && roadFrontageDistance != null),
                    onPressed: () {
                      final request = ListingPositionRequest(
                        id: widget.listingID,
                        currentStep: currentStep,
                        positionId: chooseRoad
                            ? Constants.FACADE_TYPE_ID_FOR_FACADE
                            : Constants.FACADE_TYPE_ID_FOR_ALLEY,
                        roadFrontageWidth: roadWidth,
                        alleyId: alleyId?.id,
                        roadFrontageDistanceFrom: roadFrontageDistance?.min,
                        roadFrontageDistanceTo: roadFrontageDistance?.max,
                      );
                      _bloc.add(UpdatePositionListingEvent(request));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderChooseFacadeType() {
    return Column(
      children: [
        BoldSectionTitle(text: 'Vị trí'),
        Row(
          children: [
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                if (chooseAlley) {
                  setState(() {
                    chooseRoad = true;
                    chooseAlley = false;
                    alleyId = null;
                    roadFrontageDistance = null;
                  });
                }
              },
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    SvgPicture.asset(chooseRoad
                        ? "assets/images/vector_ic_type_properties_checked.svg"
                        : "assets/images/vector_ic_type_properties_normal.svg"),
                    SizedBox(width: 8),
                    Text(
                      'Mặt tiền',
                      style: TextStyle(
                        color: AppColor.blackDefault,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 50),
            InkWell(
              onTap: () {
                if (chooseRoad) {
                  setState(() {
                    chooseRoad = false;
                    chooseAlley = true;
                    roadWidth = null;
                    _controller.text = '';
                  });
                }
              },
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    SvgPicture.asset(chooseAlley
                        ? "assets/images/vector_ic_type_properties_checked.svg"
                        : "assets/images/vector_ic_type_properties_normal.svg"),
                    SizedBox(width: 6),
                    Text(
                      'Trong hẻm',
                      style: TextStyle(
                        color: AppColor.blackDefault,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _renderDetailFacade() {
    if (!chooseRoad) {
      return Container();
    }
    return Column(
      children: [
        BoldSectionTitle(text: 'Độ rộng mặt tiền đường'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: FieldTextInputNoTitle(
            textEditingController: _controller,
            unit: 'm',
            hint: 'Nhập độ rộng ',
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp('[-|\ ]'),
              ),
              DecimalInputFormatter(),
            ],
            onChanged: (value) {
              roadWidth = value.parseVndDouble();
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _renderDetailAlley() {
    if (!chooseAlley) {
      return Container();
    }
    return Column(
      children: [
        BoldSectionTitle(text: 'Loại hẻm'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: FieldTextDropNoTitle(
            hint: 'Chọn loại hẻm',
            title: alleyId?.name,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              showModalBottomSheet(context: context, builder: showPickerAlley);
            },
          ),
        ),
        BoldSectionTitle(text: 'Khoảng cách đến mặt tiền đường'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: FieldTextDropNoTitle(
            hint: 'Chọn khoảng cách',
            title: roadFrontageDistance?.name,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              showModalBottomSheet(context: context, builder: showPickerDistance);
            },
          ),
        ),
      ],
    );
  }

  Widget showPickerDistance(BuildContext context) {
    return _showPickerDialogDistance(
        context, 'Chọn khoảng cách', _bloc.listDistances, roadFrontageDistance, (e) {
      roadFrontageDistance = e;
      Navigator.pop(context);
      setState(() {});
    });
  }

  Widget showPickerAlley(BuildContext context) {
    return _showPickerDialog(context, 'Chọn loại hẻm', _bloc.listAlleys, alleyId, (e) {
      alleyId = e;
      Navigator.pop(context);
      setState(() {});
    });
  }

  Widget _showPickerDialogDistance(
    BuildContext context,
    String title,
    List<RoadFrontageDistanceType>? list,
    RoadFrontageDistanceType? current,
    Function(RoadFrontageDistanceType) callback,
  ) {
    if (list == null) {
      return Container();
    }
    List<Widget> view = list
        .map((e) => SortItemChildView(
            text: e.name,
            isChecked: e == current,
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

  Widget _showPickerDialog(
    BuildContext context,
    String title,
    List<ListingAlley>? list,
    ListingAlley? current,
    Function(ListingAlley) callback,
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
}
