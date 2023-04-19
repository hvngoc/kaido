import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propzy_home/src/presentation/ui/delete_account/bloc/delete_account_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/presentation/view/orange_appbar.dart';
import 'package:propzy_home/src/presentation/view/password_field/password_field.dart';
import 'package:propzy_home/src/util/alert_dialog.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class DeleteAccountInputScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DeleteAccountInputScreenState();
  }
}

class DeleteAccountInputScreenState extends State<DeleteAccountInputScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _password;
  String? _reason;
  bool _isValid = false;
  DeleteAccountBloc _bloc = DeleteAccountBloc();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: OrangeAppBar(
        title: 'Xóa tài khoản',
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: formUI(),
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                color: AppColor.yellowBgDelete,
                child: DottedBorder(
                  padding: EdgeInsets.all(
                    10,
                  ),
                  dashPattern: [
                    6,
                    2,
                  ],
                  radius: Radius.circular(4),
                  color: AppColor.dashLineDelete,
                  child: Center(
                    child: Text(
                      'Để xóa tài khoản này, bạn vui lòng xác thực',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.redDelete,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    'Mật khẩu*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 14,
              ),
              PasswordField(
                autoFocus: true,
                passwordConstraint: r'^.',
                onChanged: (String? value) {
                  _password = value;
                  _validateInputs();
                },
                border: PasswordBorder(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.grayD7,
                    ),
                  ),
                ),
                inputDecoration: PasswordDecoration(
                  hintStyle: GoogleFonts.sourceSansPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  inputStyle: GoogleFonts.sourceSansPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.blackDefault,
                  ),
                  errorStyle: GoogleFonts.sourceSansPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.red,
                  ),
                ),
                errorMessage: 'Vui lòng nhập mật khẩu',
                hintText: 'Nhập mật khẩu',
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    'Lý do xóa tài khoản*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 14,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.grayD7,
                    ),
                  ),
                  hintText: 'Nhập lý do',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  errorStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.red,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.blackDefault,
                ),
                onChanged: (String? value) {
                  _reason = value;
                  _validateInputs();
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập lý do';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: BlocListener(
            bloc: _bloc,
            listener: (context, state) {
              // TODO: implement listener
              Util.hideLoading();
              if (state is DeleteAccountLoadingState) {
                Util.showLoading();
              }
              if (state is SendDeleteSuccessState) {
                _bloc.add(GetDeleteAccountInfoEvent());
              }
              if (state is GetDeleteAccountInfoSuccessState) {
                if (state.deleteAccountStatus == DeleteAccountStatus.deleted) {
                  AppAlert.showWarningAlert(
                    context,
                    'Tài khoản đã bị xóa',
                  );
                  Util.signOut();
                  Navigator.of(context, rootNavigator: true).pop();
                } else if (state.deleteAccountStatus ==
                    DeleteAccountStatus.confirm) {
                  Navigator.of(context).pop();
                } else if (state.deleteAccountStatus ==
                    DeleteAccountStatus.countDown) {
                  NavigationController.navigateToDeleteAccountCountDown(
                      context, state.info);
                }
              }
              if (state is DeleteAccountErrorState) {
                AppAlert.showErrorAlert(
                  context,
                  state.errorMessage,
                );
              }
            },
            child: Container(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              child: OrangeButton(
                isEnabled: _isValid,
                title: 'Xác nhận',
                onPressed: () {
                  if (_password?.isNotEmpty == true &&
                      _reason?.isNotEmpty == true) {
                    _bloc.add(RequestDeleteAccountEvent(
                      password: _password!,
                      reason: _reason!,
                    ));
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _validateInputs() {
    if (_formKey.currentState?.validate() == true &&
        _password?.isNotEmpty == true) {
      _formKey.currentState?.save();
      setState(() {
        _isValid = true;
      });
      return;
    }
    setState(() {
      _isValid = false;
    });
  }
}
