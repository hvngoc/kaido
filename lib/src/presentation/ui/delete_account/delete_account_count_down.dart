import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/domain/model/delete_account_info.dart';
import 'package:propzy_home/src/presentation/ui/delete_account/bloc/delete_account_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/presentation/view/orange_appbar.dart';
import 'package:propzy_home/src/util/alert_dialog.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:dart_date/dart_date.dart';
import 'package:propzy_home/src/util/util.dart';

class DeleteAccountCountDownScreen extends StatefulWidget {
  DeleteAccountCountDownScreen({
    Key? key,
    required this.info,
  }) : super(key: key);
  final DeleteAccountInfo info;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DeleteAccountCountDownScreenState(info: info);
  }
}

class DeleteAccountCountDownScreenState
    extends State<DeleteAccountCountDownScreen> with WidgetsBindingObserver {
  DeleteAccountCountDownScreenState({required this.info});

  Timer? countdownTimer;
  Duration myDuration = Duration(days: 2);
  DeleteAccountInfo info;
  DeleteAccountBloc _bloc = DeleteAccountBloc();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print('App State: $state');
    // app go to foreground
    if (state == AppLifecycleState.resumed) {
      _bloc.add(GetDeleteAccountInfoEvent());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    resetTimer();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    countdownTimer?.cancel();
  }

  // Step 3
  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    setState(() => countdownTimer?.cancel());
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    setState(
      () => myDuration = Duration(
        seconds: info.remainTime ?? 172800, //(48h)
      ),
    );
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (countdownTimer != null && seconds <= 0) {
        countdownTimer?.cancel();
        // get info when timer count down to 0 seconds
        _bloc.add(GetDeleteAccountInfoEvent());
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: OrangeAppBar(
        title: 'Tài khoản đang chờ xóa',
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(
            20,
          ),
          child: SingleChildScrollView(
            child: BlocListener(
              bloc: _bloc,
              listener: (context, state) {
                // TODO: implement listener
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
                    Navigator.of(context, rootNavigator: true).pop();
                  } else if (state.deleteAccountStatus ==
                      DeleteAccountStatus.countDown) {
                    setState(() {
                      info = state.info;
                      resetTimer();
                      startTimer();
                    });
                  }
                }
                if (state is CancelDeleteSuccessState) {
                  AppAlert.showSuccessAlert(
                    context,
                    'Hủy xóa tài khoản thành công',
                    okAction: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  );
                }
                if (state is DeleteAccountErrorState) {
                  AppAlert.showErrorAlert(
                    context,
                    state.errorMessage,
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Bạn đã yêu cầu xóa tài khoản vào lúc ${info.reqDeleteAt?.format('HH:mm - dd/MM/yyyy')}. Bạn có 48 giờ để hủy xoá tài khoản. Propzy sẽ không thể hồi phục tài khoản của bạn sau khi xóa thành công.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.secondaryText,
                    ),
                  ),
                  SizedBox(
                    height: 36,
                  ),
                  Text(
                    'Thời gian còn lại:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColor.gray4A,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _buildCountDown(),
                  SizedBox(
                    height: 30,
                  ),
                  OrangeButton(
                    title: 'Hủy xóa tài khoản',
                    onPressed: () {
                      _bloc.add(CancelDeleteAccountEvent());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountDown() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(myDuration.inHours);
    final minutes = twoDigits(myDuration.inMinutes.remainder(60));
    final seconds = twoDigits(myDuration.inSeconds.remainder(60));

    return Container(
      color: AppColor.yellowBgDelete,
      child: DottedBorder(
        padding: EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 17,
        ),
        dashPattern: [
          6,
          2,
        ],
        radius: Radius.circular(4),
        color: AppColor.dashLineDelete,
        child: Row(
          children: [
            _buildCountDownItem(
              unit: 'Giờ',
              value: hours,
            ),
            SizedBox(
              width: 16,
            ),
            _buildCountDownItem(
              unit: 'Phút',
              value: minutes,
            ),
            SizedBox(
              width: 16,
            ),
            _buildCountDownItem(
              unit: 'Giây',
              value: seconds,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountDownItem({
    required String unit,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
            height: 1,
            color: HexColor('#DBDBDB'),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.gray89,
            ),
          ),
        ],
      ),
    );
  }
}
