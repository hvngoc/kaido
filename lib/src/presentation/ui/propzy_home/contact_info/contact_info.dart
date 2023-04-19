import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/header_view.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_state.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class ContactInfoScreen extends StatefulWidget {
  const ContactInfoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final PropzyHomeBloc _propzyHomeBloc = GetIt.instance.get<PropzyHomeBloc>();
  final PrefHelper prefHelper = GetIt.instance.get<PrefHelper>();

  String SCREEN_PAGE_CODE = PropzyHomeScreenDirect.CONTACT_INFO.pageCode;
  bool _isEnableButtonContinue = false;
  UserInfo? userInfo = null;

  String? contactName = "";
  String? contactPhone = "";
  String? contactEmail = "";

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    userInfo = await prefHelper.getUserInfo();
    _propzyHomeBloc.add(GetOfferDetailEvent());
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider(create: (BuildContext context) => _propzyHomeBloc);
    return BlocConsumer<PropzyHomeBloc, PropzyHomeState>(
      bloc: _propzyHomeBloc,
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent == true) {
          if (state is UpdateOfferSuccessState) {
            Util.hideLoading();
            if (_propzyHomeBloc.draftOffer?.ownerType?.id == 1) {
              // chu nha
              navigateToStep9();
            } else {
              navigateToLoadingProcessRequest();
            }
          } else if (state is GetOfferDetailSuccess) {
            contactName = _propzyHomeBloc.draftOffer?.contactName ?? userInfo?.name;
            contactPhone = _propzyHomeBloc.draftOffer?.contactPhone ?? userInfo?.phone;
            contactEmail = _propzyHomeBloc.draftOffer?.contactEmail ?? userInfo?.email;

            _controllerName.value = TextEditingValue(text: contactName ?? "");
            _controllerPhone.value = TextEditingValue(text: contactPhone ?? "");
            _controllerEmail.value = TextEditingValue(text: contactEmail ?? "");

            validateInput();
            setState(() {});
            Util.hideLoading();
          } else if (state is LoadingState) {
            Util.showLoading();
          } else if (state is UpdateOfferErrorState) {
            Util.hideLoading();
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _renderHeaderView(),
                SizedBox(height: 16),
                _renderContent(),
                _renderFooter(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _renderHeaderView() {
    return PropzyHomeHeaderView(isLoadOfferDetail: true);
  }

  Widget _renderTitle() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Text(
          "Thông tin liên hệ của bạn",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColor.blackDefault,
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
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Text(
          "Cung cấp thông tin “chính chủ” để giúp Propzy phục vụ bạn tốt nhất!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColor.propzyHomeDes,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _renderContent() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 30),
          children: [
            Container(
              width: double.infinity,
              height: 192,
              child: Center(
                child: Image.asset(
                  'assets/images/icon_walking_propzy_home_input_contact.png',
                  width: 192,
                  height: 192,
                ),
              ),
            ),
            SizedBox(height: 16),
            _renderTitle(),
            SizedBox(height: 8),
            _renderSubTitle(),
            _renderInputField(
              "Họ tên",
              TextInputType.text,
              _controllerName,
              contactName?.isEmpty == true,
              "Vui lòng nhập Họ tên của bạn",
              (value) {
                setState(() {
                  contactName = value;
                });
                validateInput();
              },
            ),
            SizedBox(height: 16),
            _renderInputField(
              "Số điện thoại",
              TextInputType.number,
              _controllerPhone,
              !Util.isPhoneNumber(contactPhone),
              "Vui lòng nhập số điện thoại hợp lệ",
              (value) {
                setState(() {
                  contactPhone = value;
                });
                validateInput();
              },
            ),
            SizedBox(height: 16),
            _renderInputField(
              "Email",
              TextInputType.emailAddress,
              _controllerEmail,
              !Util.isEmailAddress(contactEmail),
              "Vui lòng nhập địa chỉ email hợp lệ",
              (value) {
                setState(() {
                  contactEmail = value;
                });
                validateInput();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderInputField(
    String title,
    TextInputType? keyboardType,
    TextEditingController controller,
    bool isError,
    String errorMessage,
    ValueChanged<String>? onChanged,
  ) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    color: HexColor("898989"),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: " *",
                  style: TextStyle(
                    color: HexColor("C93400"),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.secondaryText,
              height: 1.3,
            ),
            keyboardType: keyboardType,
            inputFormatters: title == "Số điện thoại" ? [LengthLimitingTextInputFormatter(10)] : [],
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 15),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(60, 60, 67, 0.36)),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
        SizedBox(height: 7),
        isError
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: HexColor("F36E59"),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  Widget _renderFooter() {
    return PropzyHomeContinueButton(
      isEnable: _isEnableButtonContinue,
      onClick: () {
        updateOffer();
      },
    );
  }

  void validateInput() {
    setState(() {
      _isEnableButtonContinue = contactName?.isNotEmpty == true &&
          Util.isPhoneNumber(contactPhone) &&
          Util.isEmailAddress(contactEmail);
    });
  }

  void updateOffer() {
    // update offer
    int? reachedPage = _propzyHomeBloc.getReachedPageId(SCREEN_PAGE_CODE);
    final event = UpdateOfferEvent(
      reachedPageId: reachedPage,
      contactName: contactName,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
    );
    _propzyHomeBloc.add(event);
  }

  void navigateToStep9() async {
    NavigationController.navigateToIBuyQAHomeStep9(context);
  }

  void navigateToLoadingProcessRequest() {
    NavigationController.navigateToLoadingProcessRequest(
      context,
      _propzyHomeBloc.draftOffer?.id ?? 0,
    );
  }
}
