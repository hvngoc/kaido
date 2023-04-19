import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/presentation/ui/profile/bloc/authentication_bloc.dart';
import 'package:propzy_home/src/presentation/ui/profile/support_online/support_online.dart';
import 'package:propzy_home/src/presentation/ui/profile/widgets/custom_webview_screen.dart';
import 'package:propzy_home/src/util/alert_dialog.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileListMenuView extends StatelessWidget {
  ProfileListMenuView({
    Key? key,
    this.isLogin = false,
  }) : super(key: key);

  final bool isLogin;

  void buildSignOutDialog(BuildContext context) {
    AppAlert.showWarningAlert(
      context,
      'Đăng xuất khỏi ứng dụng?',
      okAction: () {
        Util.signOut();
      },
      cancelAction: () {},
    );
  }

  List<MenuItemType> _getListMenu(BuildContext context, bool isLogin) {
    final menuItemUpdateProfile = MenuItemType(
      iconName: 'assets/images/ic_user.svg',
      title: 'Cập nhật thông tin',
      onPress: () {
        NavigationController.navigateToUpdateProfile(context);
      },
    );

    final menuItemRealEstatePosted = MenuItemType(
      iconName: 'assets/images/ic_real_estate_posted.svg',
      title: 'BĐS ký gửi',
      onPress: () {
        print('onPress item');
      },
    );

    final menuItemMyOfferPropzyHome = MenuItemType(
      iconName: 'assets/images/vector_ic_sale.svg',
      title: 'Danh sách đề nghị của tôi',
      onPress: () {
        NavigationController.navigateToMyOffer(context);
      },
    );

    final menuItemCooporation = MenuItemType(
      iconName: 'assets/images/ic_cooporation.svg',
      title: 'Hợp tác môi giới',
      onPress: () {
        print('onPress item');
      },
    );

    final menuItemTrading = MenuItemType(
      iconName: 'assets/images/ic_trading.svg',
      title: 'Trung tâm giao dịch',
      onPress: () {
        print('onPress item');
      },
    );

    final menuItemHelpOnline = MenuItemType(
      iconName: 'assets/images/vector_ic_help_online.svg',
      title: 'Propzy hỗ trợ online',
      onPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SupportOnline(),
          ),
        );
      },
    );

    final menuItemPopularQuestion = MenuItemType(
      iconName: 'assets/images/ic_popular_question.svg',
      title: 'Những câu hỏi thường gặp',
      onPress: () {
        Util.launchUrlString('https://propzy.vn/tro-giup?src=menu_side',
            mode: LaunchMode.externalApplication);
      },
    );

    final menuItemIntroFriend = MenuItemType(
      iconName: 'assets/images/ic_add_user.svg',
      title: 'Giới thiệu bạn bè',
      onPress: () {
        print('onPress item');
      },
    );

    final menuItemPolicy = MenuItemType(
      iconName: 'assets/images/ic_policy.svg',
      title: 'Điều khoản sử dụng',
      onPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomWebviewScreen(
              url: 'https://propzy.vn/term.html',
              title: 'Điều khoản sử dụng',
            ),
          ),
        );
      },
    );

    final menuItemSettings = MenuItemType(
      iconName: 'assets/images/ic_settings.svg',
      title: 'Cài đặt',
      onPress: () {
        print('onPress item');
      },
    );

    final menuItemLogout = MenuItemType(
      iconName: 'assets/images/ic_log_out.svg',
      title: 'Đăng xuất',
      onPress: () {
        buildSignOutDialog(context);
      },
    );

    final menuItemAppointment = MenuItemType(
      iconName: 'assets/images/ic_schedule.svg',
      title: 'Lịch hẹn',
      onPress: () {
        print('onPress item');
      },
    );

    final menuItemAgentInfo = MenuItemType(
      iconName: 'assets/images/ic_agent_info.svg',
      title: 'Thông tin môi giới',
      onPress: () {
        print('onPress item');
      },
    );

    final menuItemRealEstateNeed = MenuItemType(
      iconName: 'assets/images/ic_real_estate_need.svg',
      title: 'Nhu cầu bất động sản',
      onPress: () {
        print('onPress item');
      },
    );

    final menuItemCustomerManagement = MenuItemType(
      iconName: 'assets/images/ic_service.svg',
      title: 'Quản lý khách hàng',
      onPress: () {
        print('onPress item');
      },
    );

    final menuItemCallHotline = MenuItemType(
      iconName: 'assets/images/ic_contact_hotline.svg',
      title: 'Liên hệ hotline',
      onPress: () {
        print('onPress item');
      },
    );

    final List<MenuItemType> _listItemsNotLogin = [
      menuItemCooporation,
      menuItemTrading,
      menuItemHelpOnline,
      menuItemPopularQuestion,
      menuItemPolicy,
    ];

    final List<MenuItemType> _listItemsIsLogined = [
      menuItemUpdateProfile,
      menuItemRealEstatePosted,
      menuItemMyOfferPropzyHome,
      menuItemCooporation,
      menuItemTrading,
      menuItemHelpOnline,
      menuItemPopularQuestion,
      menuItemIntroFriend,
      menuItemPolicy,
      menuItemSettings,
      menuItemLogout,
    ];

    final List<MenuItemType> _listItemsAgent = [
      menuItemUpdateProfile,
      menuItemRealEstatePosted,
      menuItemAppointment,
      menuItemAgentInfo,
      menuItemRealEstateNeed,
      menuItemCustomerManagement,
      menuItemCallHotline,
      menuItemTrading,
      menuItemHelpOnline,
      menuItemPopularQuestion,
      menuItemIntroFriend,
      menuItemPolicy,
      menuItemSettings,
      menuItemLogout,
    ];

    if (isLogin) {
      return _listItemsIsLogined;
    }
    return _listItemsNotLogin;
  }

  @override
  Widget build(BuildContext context) {
    final List<MenuItemType> _listMenuItems = _getListMenu(context, isLogin);
    return Container(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 0),
        itemCount: _listMenuItems.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Visibility(
                visible: !this.isLogin, child: ProfileLoginButtons());
          }
          final menuItem = _listMenuItems[index - 1];
          return ProfileMenuView(
            menuItemType: menuItem,
          );
        },
        separatorBuilder: (context, index) {
          if (index == 0) {
            return Divider(
              color: Colors.white,
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Divider(
              height: 1,
              thickness: 1,
            ),
          );
        },
      ),
    );
  }
}

class ProfileLoginButtons extends StatelessWidget {
  ProfileLoginButtons({
    Key? key,
  }) : super(key: key);
  final AuthenticationBloc _bloc = GetIt.I.get<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                _bloc.add(AuthenticationLogInRequested());
                //context.read<AuthenticationBloc>().add(AuthenticationLogInRequested());
              },
              child: Text(
                'Đăng nhập',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColor.orangeDark,
                shape: StadiumBorder(),
                splashFactory: NoSplash.splashFactory,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                _bloc.add(AuthenticationSignUpRequested());
                //context.read<AuthenticationBloc>().add(AuthenticationSignUpRequested());
              },
              child: Text(
                'Đăng ký',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColor.propzyBlue,
                shape: StadiumBorder(),
                splashFactory: NoSplash.splashFactory,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItemType {
  String iconName;
  String title;
  VoidCallback? onPress;

  MenuItemType({
    required this.iconName,
    required this.title,
    this.onPress,
  });
}

class ProfileMenuView extends StatelessWidget {
  const ProfileMenuView({Key? key, required this.menuItemType})
      : super(key: key);

  final MenuItemType menuItemType;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: menuItemType.onPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 40,
        child: Row(
          children: [
            SizedBox(
              child: SvgPicture.asset(menuItemType.iconName),
              height: 18,
              width: 18,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: Text(
              menuItemType.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            )),
            SizedBox(
              width: 8,
            ),
            SizedBox(
              child: SvgPicture.asset('assets/images/vector_ic_arrow_left.svg'),
              height: 12,
              width: 18,
            ),
          ],
        ),
      ),
    );
  }
}
