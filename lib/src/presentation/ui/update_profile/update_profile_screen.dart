import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:propzy_home/src/presentation/ui/delete_account/bloc/delete_account_bloc.dart';
import 'package:propzy_home/src/presentation/ui/delete_account/delete_account_count_down.dart';
import 'package:propzy_home/src/presentation/ui/update_profile/widgets/update_profile_item.dart';
import 'package:propzy_home/src/presentation/view/image_thumbnail_view.dart';
import 'package:propzy_home/src/util/alert_dialog.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class UpdateProfileScreen extends StatefulWidget {
  UpdateProfileScreen({required this.navTitle});

  final String navTitle;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UpdateProfileScreenState();
  }
}

class UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final PrefHelper prefHelper = GetIt.I.get<PrefHelper>();
  final DeleteAccountBloc _deleteAccountBloc =
      DeleteAccountBloc(); //GetIt.I.get<DeleteAccountBloc>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // Override the default Back button
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            child: Image(
              image: AssetImage(
                'assets/images/ico_back.png',
              ),
            ),
          ),
        ),
        backgroundColor: AppColor.propzyOrange,
        title: Text.rich(
          TextSpan(
            text: widget.navTitle ?? '',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(
            20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: 88,
                  height: 88,
                  child: ClipOval(
                    child: FutureBuilder<Widget>(
                      future: _buildImage(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Widget> snapshot) {
                        return snapshot.data ??
                            Image(
                              image: AssetImage(
                                'assets/images/no_avatar.png',
                              ),
                              fit: BoxFit.cover,
                            );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                FutureBuilder<UserInfo?>(
                  future: _getProfile(),
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        UpdateProfileItem(
                          name: 'Họ và tên',
                          iconPath: 'assets/images/ic_profile_name.png',
                          defaultValue: snapshot.data?.name ?? '',
                        ),
                        UpdateProfileItem(
                          name: 'Giới tính',
                          iconPath: 'assets/images/ic_profile_gender.png',
                          defaultValue: snapshot.data?.gender ?? '',
                        ),
                        UpdateProfileItem(
                          name: 'Ngày sinh',
                          iconPath: 'assets/images/ic_profile_birthday.png',
                          defaultValue: snapshot.data?.birthDay ?? '',
                        ),
                        UpdateProfileItem(
                          name: 'Email',
                          iconPath: 'assets/images/ic_profile_mail.png',
                          defaultValue: snapshot.data?.email ?? '',
                        ),
                        UpdateProfileItem(
                          name: 'Số điện thoại',
                          iconPath: 'assets/images/ic_profile_phone.png',
                          defaultValue: snapshot.data?.phone ?? '',
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                BlocListener(
                  bloc: _deleteAccountBloc,
                  listener: (context, state) {
                    // TODO: implement listener
                    // TODO: implement listener}
                    Util.hideLoading();
                    if (state is DeleteAccountLoadingState) {
                      Util.showLoading();
                    }
                    if (state is GetDeleteAccountInfoSuccessState) {
                      if (state.deleteAccountStatus ==
                          DeleteAccountStatus.deleted) {
                        AppAlert.showWarningAlert(
                          context,
                          'Tài khoản đã bị xóa',
                        );
                        Util.signOut();
                        Navigator.of(context, rootNavigator: true).pop();
                      } else if (state.deleteAccountStatus ==
                          DeleteAccountStatus.confirm) {
                        NavigationController.navigateToDeleteAccount(context);
                      } else if (state.deleteAccountStatus ==
                          DeleteAccountStatus.countDown) {
                        NavigationController.navigateToWidgets(
                          context,
                          [
                            DeleteAccountCountDownScreen(
                              info: state.info,
                            ),
                          ],
                        );
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
                    height: 45,
                    child: InkWell(
                      onTap: () async {
                        UserInfo? userInfo = await prefHelper.getUserInfo();
                        if (userInfo != null) {
                          _deleteAccountBloc.add(GetDeleteAccountInfoEvent());
                        } else {
                          AppAlert.showErrorAlert(
                            context,
                            'Lỗi',
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            'Xóa tài khoản',
                            style: TextStyle(
                              color: AppColor.redDelete,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Image.asset(
                            'assets/images/ic_indicator_delete_acc.png',
                            width: 6,
                            height: 11,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserInfo?> _getProfile() async {
    return await prefHelper.getUserInfo();
  }

  Future<Widget> _buildImage() async {
    UserInfo? userInfo = await prefHelper.getUserInfo();
    String? url = userInfo?.photo;
    if (url != null) {
      return ImageThumbnailView(
        fileUrl: url,
        progressColor: AppColor.orangeDark,
      );
    }
    return Image(
      image: AssetImage(
        'assets/images/no_avatar.png',
      ),
      fit: BoxFit.cover,
    );
  }
}
