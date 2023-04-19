import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/propzy_home_property_type_model.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/propzy_home_bottom_sheet_information.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_type/property_type_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_type/property_type_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/property_type/property_type_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/view/ink_well_without_ripple.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/message_util.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class PropertyTypeScreen extends StatefulWidget {
  bool isResetOffer;

  PropertyTypeScreen({
    Key? key,
    this.isResetOffer = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PropertyTypeScreenState();
}

class _PropertyTypeScreenState extends State<PropertyTypeScreen> {
  final PropzyHomePropertyTypeBloc _bloc = GetIt.instance.get<PropzyHomePropertyTypeBloc>();
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();

  List<PropzyHomePropertyType>? listPropertyTypes;
  bool _isEnableButtonContinue = false;

  @override
  void initState() {
    super.initState();
    if (widget.isResetOffer) {
      _propzyHomeBloc.add(ResetDraftOfferEvent());
    }
    _bloc.add(GetPropertyTypeEvent());
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider(create: (BuildContext context) => _bloc);

    return BlocConsumer<PropzyHomePropertyTypeBloc, PropzyHomePropertyTypeState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is ErrorGetPropertyTypeState) {
          Log.e(state.message);
          Util.showMyDialog(
            context: context,
            message: state.message ?? MessageUtil.errorMessageDefault,
          );
        } else if (state is SuccessGetPropertyTypeState) {
          setState(() {
            listPropertyTypes = state.propertyTypes;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _renderHeaderView(),
                SizedBox(height: 32),
                _renderTitle(),
                SizedBox(height: 8),
                _renderSubTitle(),
                _renderContent(state),
                _renderFooter(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _renderHeaderView() {
    return PropzyHomeHeaderView(
      onClickBack: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
  }

  Widget _renderTitle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Mô tả đúng nhất về loại hình căn nhà của quý khách  ",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color: AppColor.blackDefault,
              ),
            ),
            WidgetSpan(
              child: InkWellWithoutRipple(
                onTap: () {
                  showBottomSheetInformation();
                },
                child: SvgPicture.asset(
                  "assets/images/ic_info_propzy_home.svg",
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _renderSubTitle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Mỗi loại hình BĐS đều có đặc điểm riêng, vui lòng giúp Propzy phân loại để hỗ trợ quý khách hiệu quả nhất",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColor.propzyHomeDes,
        ),
      ),
    );
  }

  Widget _renderContent(PropzyHomePropertyTypeState state) {
    return Expanded(
      child: (state is LoadingState)
          ? Container(
              child: Center(
                child: LoadingView(
                  width: 160,
                  height: 160,
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.only(top: 65),
              child: _renderListPropertyType(),
            ),
    );
  }

  Widget _renderListPropertyType() {
    if ((listPropertyTypes?.length ?? 0) == 0) return Container();
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: _renderItemPropertyType,
      itemCount: listPropertyTypes?.length,
    );
  }

  Widget _renderItemPropertyType(BuildContext context, int index) {
    PropzyHomePropertyType propertyType = listPropertyTypes!.elementAt(index);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 25),
      height: 53,
      decoration: BoxDecoration(
        color: propertyType.isSelected == true ? HexColor("E8EFF6") : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: propertyType.isSelected == true ? HexColor("007AFF") : HexColor("CED4DA"),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          bool isEnable = true;
          for (int i = 0; i < listPropertyTypes!.length; i++) {
            PropzyHomePropertyType propertyType = listPropertyTypes![i];
            if (i == index) {
              propertyType.isSelected = true;
              if (propertyType.id == PROPERTY_TYPES.KHAC.type) {
                isEnable = false;
                showModalBottomSheet(
                  context: context,
                  builder: _renderBottomSheetForOtherPropertyType,
                  backgroundColor: Colors.transparent,
                );
              }
            } else {
              propertyType.isSelected = false;
            }
          }

          setState(() {
            listPropertyTypes = listPropertyTypes;
            _isEnableButtonContinue = isEnable;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              propertyType.isSelected == true
                  ? "assets/images/ic_radio_button_selected_property_type.svg"
                  : "assets/images/ic_radio_button_unselected_property_type.svg",
              width: 16,
              height: 16,
            ),
            SizedBox(width: 8),
            Text(
              propertyType.typeName ?? "",
              style: TextStyle(
                color: AppColor.blackDefault,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderFooter() {
    return PropzyHomeContinueButton(
      isEnable: _isEnableButtonContinue,
      onClick: () {
        PropzyHomePropertyType propertyType =
            listPropertyTypes!.firstWhere((element) => element.isSelected == true);
        _propzyHomeBloc.add(SavePropertyTypeSelectedEvent(propertyType));
        NavigationController.navigateToIBuyPickAddress(
          context,
        );
      },
    );
  }

  Widget _renderBottomSheetForOtherPropertyType(BuildContext context) {
    return Container(
      height: 320,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 14),
          Container(
            height: 5,
            width: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 14),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Dịch vụ “Bán cho Propzy” chỉ áp dụng cho loại hình nhà riêng và căn hộ.",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: AppColor.blackDefault,
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    "Với các loại hình BĐS khác quý khách có thể sử dụng dịch vụ đăng tin miễn phí của Propzy",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColor.secondaryText,
                    ),
                  ),
                  SizedBox(height: 32),
                  PropzyHomeContinueButton(
                    isEnable: true,
                    content: "Đăng ngay",
                    width: 176,
                    height: 48,
                    onClick: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showBottomSheetInformation() async {
    String contentHtml = await rootBundle.loadString(
        "assets/html/${PROPZY_HOME_POPUP_INFORMATION.PROPERTY_TYPES_OF_HOME.assetFileName}");

    showModalBottomSheet(
      context: context,
      builder: (context) => PropzyHomeBottomSheetInformation(contentHtml: contentHtml),
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints.loose(
        Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.75,
        ),
      ),
    );
  }
}
