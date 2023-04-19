import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/presentation/ui/address_picker/base_chooser_widget.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_property/bloc/choose_property_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_property/bloc/choose_property_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/choose_property/bloc/choose_property_state.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/bold_section_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/field_text_drop_no_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/header_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/choose_type_buy_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/choose_type_rent_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

class ChoosePropertyWidget extends StatefulWidget {
  final int listingId;

  const ChoosePropertyWidget({
    Key? key,
    required this.listingId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChoosePropertyState();
}

class _ChoosePropertyState extends State<ChoosePropertyWidget> {
  final ChoosePropertyBloc _bloc = ChoosePropertyBloc();
  final CreateListingBloc _createListingBloc = CreateListingBloc();

  int type = CategoryType.BUY.type;
  ChooserData? categoryProperties = null;

  @override
  void initState() {
    super.initState();
    _createListingBloc.add(GetDraftListingDetailEvent(widget.listingId));
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
          BlocListener<CreateListingBloc, BaseCreateListingState>(
            bloc: _createListingBloc,
            listener: (context, state) {
              if (state is GetDraftListingDetailSuccessState) {
                final draftType = _createListingBloc.draftListing?.listingType?.listingTypeID;
                if (draftType != null) {
                  type = draftType;
                }
                final properties = _createListingBloc.draftListing?.propertyType;
                if (properties != null) {
                  categoryProperties = ChooserData(properties.id, properties.name);
                }
                setState(() {});
              }
            },
          ),
          BlocListener<ChoosePropertyBloc, ChoosePropertyState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is ChoosePropertySuccess) {
                final propId = categoryProperties?.id;
                if (propId == null) {
                  return;
                }
                //US4
                if (_createListingBloc.isHouse(propId)) {
                  NavigationController.navigateToTextureCreateListing(
                    context,
                    listingId: widget.listingId,
                    propertyTypeId: propId,
                  );
                }
                //US 5
                else if (_createListingBloc.isLand(propId)) {
                  NavigationController.navigateToChooseFacadeCreateListing(
                    context,
                    widget.listingId,
                    propId,
                  );
                }
                //US 6
                else {
                  NavigationController.navigateToChooseProjectInfoCreateListing(
                    context,
                    widget.listingId,
                    propId,
                    _createListingBloc.draftListing?.district?.districtId ?? 0,
                  );
                }
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
                  currentScreenInStep: 1,
                  totalScreensInStep: 8,
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Loại giao dịch bất động sản của bạn',
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
                    'Xác định loại giao dịch bạn mong muốn',
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
                SizedBox(height: 24),
                BoldSectionTitle(text: 'Loại giao dịch'),
                Row(
                  children: [
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        if (type == CategoryType.BUY.type) {
                          return;
                        }
                        setState(() {
                          type = CategoryType.BUY.type;
                          categoryProperties = null;
                        });
                      },
                      child: Container(
                        height: 48,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset(type == CategoryType.BUY.type
                                ? "assets/images/vector_ic_type_properties_checked.svg"
                                : "assets/images/vector_ic_type_properties_normal.svg"),
                            SizedBox(width: 8),
                            Text(
                              'Bán',
                              style: TextStyle(
                                color: AppColor.gray4A,
                                fontWeight: FontWeight.w600,
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
                        if (type == CategoryType.RENT.type) {
                          return;
                        }
                        setState(() {
                          type = CategoryType.RENT.type;
                          categoryProperties = null;
                        });
                      },
                      child: Container(
                        height: 48,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset(type == CategoryType.RENT.type
                                ? "assets/images/vector_ic_type_properties_checked.svg"
                                : "assets/images/vector_ic_type_properties_normal.svg"),
                            SizedBox(width: 6),
                            Text(
                              'Cho thuê',
                              style: TextStyle(
                                color: AppColor.gray4A,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                BoldSectionTitle(text: 'Loại BĐS'),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: FieldTextDropNoTitle(
                    title: categoryProperties?.name,
                    hint: 'Chọn loại BĐS',
                    onTap: () async {
                      final screen = type == CategoryType.BUY.type
                          ? ChoosePropertiesBuyScreen(lastChooser: categoryProperties)
                          : ChoosePropertiesRentScreen(lastChooser: categoryProperties);
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => screen),
                      );
                      final data = result[BaseChooserScreen.PARAM] as ChooserData;
                      setState(() {
                        this.categoryProperties = data;
                      });
                    },
                  ),
                ),
                Spacer(),
                PropzyHomeContinueButton(
                  isEnable: isValid(),
                  onClick: () {
                    _bloc.add(ChoosePropertyEvent(
                      id: widget.listingId,
                      listingTypeId: type,
                      propertyTypeId: categoryProperties?.id,
                    ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValid() {
    return categoryProperties != null;
  }
}
