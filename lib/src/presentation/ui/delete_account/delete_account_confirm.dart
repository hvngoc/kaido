import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/user_info.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/presentation/view/image_thumbnail_view.dart';
import 'package:propzy_home/src/presentation/view/orange_appbar.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

class DeleteAccountConfirmScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DeleteAccountConfirmScreenState();
  }
}

class DeleteAccountConfirmScreenState
    extends State<DeleteAccountConfirmScreen> {
  final PrefHelper prefHelper = GetIt.I.get<PrefHelper>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: OrangeAppBar(
        title: 'Xóa tài khoản',
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(
                20,
              ),
              child: FutureBuilder<UserInfo?>(
                future: _getProfile(),
                builder: (context, snapshot) {
                  return Column(
                    children: [
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
                          color: AppColor.dashLineDelete,
                          radius: Radius.circular(4),
                          child: Center(
                            child: Text(
                              'Khi xóa tài khoản, bạn không thể lấy lại các BĐS đã lưu và BĐS đã ký gửi trên nền tảng của Propzy. Tất cả dữ liệu tài khoản của bạn sẽ bị xoá.',
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
                        height: 40,
                      ),
                      SizedBox(
                        width: 72,
                        height: 72,
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
                        height: 7,
                      ),
                      Text(
                        snapshot.data?.name ?? 'Họ và tên',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Chúng tôi rất lấy làm tiếc khi bạn muốn rời Propzy, nhưng lưu ý rằng không thể khôi phục dữ liệu sau khi xoá tài khoản.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.secondaryText,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GreyButton(
                          title: 'Hủy',
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Expanded(
                        child: OrangeButton(
                          title: 'Xóa tài khoản',
                          onPressed: () {
                            NavigationController.navigateToDeleteAccountInput(
                                context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
