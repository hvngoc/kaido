import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/header_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/contact_info/bloc/owner_info_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/contact_info/bloc/owner_info_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/contact_info/bloc/owner_info_state.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/message_util.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class OwnerInfoScreen extends StatefulWidget {
  const OwnerInfoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OwnerInfoScreenState();
}

class _OwnerInfoScreenState extends State<OwnerInfoScreen> {
  final CreateListingBloc _createListingBloc = GetIt.instance.get<CreateListingBloc>();
  final OwnerInfoBloc _ownerInfoBloc = GetIt.instance.get<OwnerInfoBloc>();

  String ownerName = "";
  String ownerPhone = "";
  String ownerEmail = "";

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_createListingBloc.createListingRequest?.id != null) {
      _createListingBloc.add(GetDraftListingDetailEvent(
        _createListingBloc.createListingRequest!.id!,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _ownerInfoBloc),
        BlocProvider(create: (_) => _createListingBloc),
      ],
      child: BlocConsumer<CreateListingBloc, BaseCreateListingState>(
        bloc: _createListingBloc,
        listener: (context, state) {
          if (ModalRoute.of(context)?.isCurrent == true) {
            if (state is GetDraftListingDetailSuccessState) {
              Util.hideLoading();
              DraftListing? draftListing = _createListingBloc.draftListing;
              ownerName = draftListing?.ownerName ?? "";
              ownerPhone = draftListing?.ownerPhone ?? "";
              ownerEmail = draftListing?.ownerEmail ?? "";

              _controllerName.value = TextEditingValue(text: ownerName);
              _controllerPhone.value = TextEditingValue(text: ownerPhone);
              _controllerEmail.value = TextEditingValue(text: ownerEmail);
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
          return BlocConsumer<OwnerInfoBloc, OwnerInfoState>(
            bloc: _ownerInfoBloc,
            listener: (context, state) {
              if (state is LoadingState) {
                Util.showLoading();
              } else if (state is ErrorState) {
                Util.hideLoading();
                Util.showMyDialog(
                  context: context,
                  message: state.message ?? MessageUtil.errorMessageDefault,
                );
              } else if (state is SuccessUpdateOwnerInfoState) {
                Util.hideLoading();
                navigateToPlanToBuy();
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
      currentStep: 4,
      parentPadding: 16,
    );
  }

  Widget _renderTitle() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(
          "Thông tin liên hệ",
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
          "Khách hàng sẽ liên hệ với bạn qua thông tin này, hãy cung cấp thông tin chính xác!",
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
    return Expanded(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          _renderInputField(
            title: "Họ và tên",
            value: ownerName,
            hint: "Nhập tên của bạn",
            isRequire: true,
            controller: _controllerName,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              setState(() {
                ownerName = value;
              });
            },
          ),
          SizedBox(height: 20),
          _renderInputField(
            title: "Số điện thoại",
            value: ownerPhone,
            hint: "Nhập số điện thoại của bạn",
            isRequire: true,
            controller: _controllerPhone,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              setState(() {
                ownerPhone = value;
              });
            },
          ),
          SizedBox(height: 20),
          _renderInputField(
            title: "Email",
            value: ownerEmail,
            hint: "Nhập email của bạn",
            isRequire: false,
            controller: _controllerEmail,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              setState(() {
                ownerEmail = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _renderInputField({
    required String title,
    required String value,
    required String hint,
    required bool isRequire,
    required TextEditingController controller,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: isRequire && value.isEmpty ? HexColor("D6180C") : HexColor("DEE1E2"),
        width: 1,
      ),
    );

    return Column(
      children: [
        Container(
          width: double.infinity,
          child: isRequire
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: title,
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
                )
              : Text(
                  title,
                  style: TextStyle(
                    color: AppColor.secondaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        SizedBox(height: 10),
        Container(
          height: 42,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            onChanged: (value) {
              onChanged?.call(value);
            },
            keyboardType: keyboardType,
            controller: controller,
            inputFormatters: title == "Số điện thoại" ? [LengthLimitingTextInputFormatter(10)] : [],
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: HexColor("4A4A4A"),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              isDense: true,
              contentPadding: EdgeInsets.all(12),
              focusedBorder: border,
              enabledBorder: border,
              disabledBorder: border,
            ),
          ),
        ),
        SizedBox(height: 5),
        isRequire && value.isEmpty
            ? Container(
                width: double.infinity,
                height: 17,
                child: Text(
                  "Thông tin bắt buộc",
                  style: TextStyle(
                    color: HexColor("D6180C"),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : Container(
                height: 17,
              )
      ],
    );
  }

  Widget _renderFooter() {
    bool isEnable = ownerName.isNotEmpty &&
        ownerPhone.isNotEmpty &&
        Util.isPhoneNumber(ownerPhone) &&
        (ownerEmail.isEmpty || (ownerEmail.isNotEmpty == true && Util.isEmailAddress(ownerEmail)));

    return PropzyHomeContinueButton(
      isEnable: isEnable,
      fontWeight: FontWeight.w700,
      onClick: () {
        if (_createListingBloc.createListingRequest?.id != null) {
          UpdateOwnerInfoListingRequest request = UpdateOwnerInfoListingRequest(
            id: _createListingBloc.createListingRequest!.id!,
            ownerName: ownerName,
            ownerPhone: ownerPhone,
            ownerEmail: ownerEmail,
          );
          _ownerInfoBloc.add(UpdateOwnerInfoEvent(request));
        }
      },
    );
  }

  void navigateToPlanToBuy() {
    NavigationController.navigatePlanToBuy(
      context,
      _createListingBloc.createListingRequest?.id ?? 0,
    );
  }
}
