import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/listing_building.dart';
import 'package:propzy_home/src/domain/request/listing_position_request.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_project_info/bloc/choose_project_info_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_project_info/choose_building/choose_building_widget.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/bold_section_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/field_checkbox_item.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/field_text_drop_no_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/field_text_input_no_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/header_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/title_description_info_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class ChooseProjectInfoWidget extends StatefulWidget {
  const ChooseProjectInfoWidget({
    Key? key,
    required this.propertiesType,
    required this.listingID,
    required this.districtId,
  }) : super(key: key);

  final int propertiesType;
  final int listingID;
  final int districtId;

  @override
  State<ChooseProjectInfoWidget> createState() => _ChooseProjectInfoWidgetState();
}

class _ChooseProjectInfoWidgetState extends State<ChooseProjectInfoWidget> {
  final ChooseProjectInfoBloc _bloc = ChooseProjectInfoBloc();
  final CreateListingBloc _createListingBloc = GetIt.instance.get<CreateListingBloc>();
  final String currentStep = "POSITION_STEP";

  TextEditingController _modelCodeController = TextEditingController();
  TextEditingController _floorController = TextEditingController();

  ListingBuilding? listingBuilding;
  String? modelCode;
  int? floor;
  bool? isHideModelCode = false;

  @override
  void initState() {
    super.initState();
    _createListingBloc.add(GetDraftListingDetailEvent(widget.listingID));
  }

  @override
  void dispose() {
    super.dispose();
    _modelCodeController.dispose();
    _floorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _bloc),
        BlocProvider(create: (_) => _createListingBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ChooseProjectInfoBloc, ChooseProjectInfoState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is UpdateProjectInfoSuccess) {
                NavigationController.navigateCreateNumberOfRoom(
                    context, widget.listingID, widget.propertiesType);
              }
            },
          ),
          BlocListener<CreateListingBloc, BaseCreateListingState>(
            bloc: _createListingBloc,
            listener: (context, state) {
              if (state is GetDraftListingDetailSuccessState) {
                listingBuilding = _createListingBloc.draftListing?.building;
                modelCode = _createListingBloc.draftListing?.modelCode;
                _modelCodeController.text = modelCode ?? '';
                floor = _createListingBloc.draftListing?.floor;
                if (floor != null) {
                  _floorController.text = '${floor}';
                }
                isHideModelCode = _createListingBloc.draftListing?.isHideModelCode;
                setState(() {});
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
                Flexible(
                  child: ListView(
                    children: [
                      CreateListingProgressBarView(
                        currentStep: 2,
                        currentScreenInStep: 2,
                        totalScreensInStep: 7,
                      ),
                      TitleDescriptionInfoView(
                        title: 'Thông tin chi tiết bất động sản của bạn',
                        description:
                            'Cung cấp thông tin đầy đủ giúp bạn tiếp cận được nhiều khách hàng hơn',
                      ),
                      BoldSectionTitle(text: 'Dự án'),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FieldTextDropNoTitle(
                          title: listingBuilding?.name,
                          hint: 'Nhập tên chung cư/dự án',
                          onTap: () async {
                            final screen = ChooseBuildingWidget(
                              lastChooser: listingBuilding,
                              districtId: widget.districtId,
                            );
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => screen),
                            );
                            final data = result[ChooseBuildingWidget.PARAM] as ListingBuilding;
                            setState(() {
                              this.listingBuilding = data;
                            });
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                BoldSectionTitle(text: 'Mã căn'),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FieldTextInputNoTitle(
                                    textEditingController: _modelCodeController,
                                    unit: '',
                                    hint: 'Nhập mã căn',
                                    keyboardType: TextInputType.text,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    onChanged: (e) {
                                      setState(() {
                                        modelCode = e;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                BoldSectionTitle(text: 'Vị trí tầng'),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FieldTextInputNoTitle(
                                    textEditingController: _floorController,
                                    unit: '',
                                    hint: 'Nhập vị trí tầng',
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'),
                                      ),
                                      FilteringTextInputFormatter.deny(
                                        RegExp(r'^0+'),
                                      ),
                                    ],
                                    onChanged: (e) {
                                      setState(() {
                                        floor = int.tryParse(e);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FieldCheckboxItem(
                          title: 'Không hiển thị mã căn trên tin đăng',
                          isSelected: isHideModelCode ?? false,
                          onPress: () {
                            setState(() {
                              isHideModelCode = !(isHideModelCode ?? false);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OrangeButton(
                    title: 'Tiếp tục',
                    isEnabled: listingBuilding != null &&
                        modelCode != null &&
                        modelCode!.isNotEmpty &&
                        floor != null,
                    onPressed: () {
                      final request = ListingPositionRequest(
                        id: widget.listingID,
                        currentStep: currentStep,
                        buildingId: listingBuilding?.id,
                        buildingName: listingBuilding?.name,
                        floor: floor,
                        modelCode: modelCode,
                        isHideModelCode: isHideModelCode,
                      );
                      _bloc.add(UpdateProjectInfoListingEvent(request));
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
}
