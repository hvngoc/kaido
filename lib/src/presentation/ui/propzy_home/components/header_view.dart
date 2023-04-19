import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/progress_view/bloc/propzy_home_progress_view_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_event.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class PropzyHomeHeaderView extends StatelessWidget {
  final Function? onClickBack;
  final Function? onClickHome;
  final bool? isHideHomeBtn;
  final bool? isLoadOfferDetail;
  final PropzyHomeBloc _propzyHomeBloc = GetIt.I.get<PropzyHomeBloc>();
  final PropzyHomeProgressViewBloc _propzyHomeProgressViewBloc =
      GetIt.I.get<PropzyHomeProgressViewBloc>();

  PropzyHomeHeaderView({
    Key? key,
    this.onClickBack,
    this.onClickHome,
    this.isHideHomeBtn,
    this.isLoadOfferDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: () {
              if (onClickBack == null) {
                if (_propzyHomeBloc.draftOffer?.id != null) {
                  _propzyHomeProgressViewBloc.add(GetCompletionPercentageEvent(
                    _propzyHomeBloc.draftOffer!.id!,
                  ));

                  if (isLoadOfferDetail == true) {
                    _propzyHomeBloc.add(GetOfferDetailEvent());
                  }
                }
                Navigator.pop(context, true);
              } else {
                onClickBack?.call();
              }
            },
            child: Container(
              // height: double.infinity,
              margin: EdgeInsets.symmetric(
                vertical: 10,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/ic_arrow_left_black.svg',
                    color: AppColor.blackDefault,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Quay lại',
                    style: TextStyle(
                      color: AppColor.blackDefault,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Container(
            child: isHideHomeBtn == true
                ? Container()
                : InkWell(
                    onTap: () {
                      if (onClickHome != null) {
                        onClickHome?.call();
                      } else {
                        showAlertDialog(context);
                      }
                    },
                    child: Container(
                      // height: double.infinity,
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/ic_home_propzy_home.svg',
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          8.0,
        ),
      ), //this right here
      child: Container(
        padding: EdgeInsets.all(
          12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  },
                  child: SvgPicture.asset(
                    'assets/images/ic_close.svg',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Bạn có muốn quay về trang trước đó?',
                    style: TextStyle(
                      color: AppColor.blackDefault,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: 40,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.grayD5,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      child: Row(
                        children: [
                          Text(
                            'Không, Cảm ơn',
                            style: TextStyle(
                              color: AppColor.blackDefault,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: 40,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.propzyOrange,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        // close popup
                        Navigator.of(context, rootNavigator: true).pop();
                        // back to root
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Row(
                        children: [
                          Text(
                            'Có',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
}
