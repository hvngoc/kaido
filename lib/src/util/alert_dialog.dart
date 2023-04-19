import 'package:flutter/material.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AppAlert {
  // region Make Singleton Class
  static final AppAlert _singleton = AppAlert._internal();
  factory AppAlert() {
    return _singleton;
  }

  late AlertStyle alertStyle;
  late Alert _rflutterAlert;

  Widget _fadeAlertAnimation(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  AppAlert._internal() {
    // Reusable alert style
    alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(
        fontSize: 16,
      ),
      //First to chars "55" represents transparency of color
      overlayColor: Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.center,
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
  // endregion

  static void showSuccessAlert(
    BuildContext context,
    String message, {
    VoidCallback? okAction,
    VoidCallback? cancelAction,
  }) {
    AppAlert().showSuccess(
      context,
      message,
      btnOkAction: okAction,
      btnCancelAction: cancelAction,
    );
  }

  static void showWarningAlert(
    BuildContext context,
    String message, {
    VoidCallback? okAction,
    VoidCallback? cancelAction,
  }) {
    AppAlert().showWarning(
      context,
      message,
      btnOkAction: okAction,
      btnCancelAction: cancelAction,
    );
  }

  static void showErrorAlert(
    BuildContext context,
    String message, {
    VoidCallback? okAction,
    VoidCallback? cancelAction,
  }) {
    AppAlert().showError(
      context,
      message,
      btnOkAction: okAction,
      btnCancelAction: cancelAction,
    );
  }

  static void showInfoAlert(
    BuildContext context,
    String message, {
    VoidCallback? okAction,
    VoidCallback? cancelAction,
  }) {
    AppAlert().showInfo(
      context,
      message,
      btnOkAction: okAction,
      btnCancelAction: cancelAction,
    );
  }

  void show(
    BuildContext context,
    String desc, {
    String? title,
    String? okTitle,
    String? cancelTitle,
    VoidCallback? btnOkAction,
    VoidCallback? btnCancelAction,
    AlertType? type,
    Widget? image,
  }) {
    List<DialogButton>? buttons = [];
    if (btnOkAction != null) {
      buttons.add(_makeOk(title: okTitle, btnOkAction: btnOkAction));
    }
    if (btnCancelAction != null) {
      buttons.add(_makeCancel(title: cancelTitle, btnCancelAction: btnCancelAction));
    }
    _rflutterAlert = Alert(
      context: context,
      type: type,
      title: title,
      desc: desc,
      buttons: buttons,
      style: alertStyle,
      alertAnimation: _fadeAlertAnimation,
      image: image,
    );
    _rflutterAlert.show();
    // Alert(
    //   context: context,
    //   type: type,
    //   title: title,
    //   desc: desc,
    //   buttons: buttons,
    //   style: alertStyle,
    //   alertAnimation: _fadeAlertAnimation,
    //   image: image,
    // ).show();
  }

  void showWarning(
    BuildContext context,
    String desc, {
    VoidCallback? btnOkAction,
    VoidCallback? btnCancelAction,
  }) {
    show(
      context,
      desc,
      btnOkAction: btnOkAction,
      btnCancelAction: btnCancelAction,
      //type: AlertType.warning,
      image: Image.asset(
        'assets/images/ic_alert_warning.png',
        width: 30,
        height: 30,
      ),
    );
  }

  void showError(
    BuildContext context,
    String desc, {
    VoidCallback? btnOkAction,
    VoidCallback? btnCancelAction,
  }) {
    show(
      context,
      desc,
      btnOkAction: btnOkAction,
      btnCancelAction: btnCancelAction,
      //type: AlertType.error,
      image: Image.asset(
        'assets/images/ic_alert_error.png',
        width: 30,
        height: 30,
      ),
    );
  }

  void showSuccess(
    BuildContext context,
    String desc, {
    VoidCallback? btnOkAction,
    VoidCallback? btnCancelAction,
  }) {
    show(
      context,
      desc,
      btnOkAction: btnOkAction,
      btnCancelAction: btnCancelAction,
      //type: AlertType.success,
      image: Image.asset(
        'assets/images/ic_alert_success.png',
        width: 30,
        height: 30,
      ),
    );
  }

  void showInfo(
    BuildContext context,
    String desc, {
    VoidCallback? btnOkAction,
    VoidCallback? btnCancelAction,
  }) {
    show(
      context,
      desc,
      btnOkAction: btnOkAction,
      btnCancelAction: btnCancelAction,
      type: AlertType.info,
    );
  }

  DialogButton _makeOk({
    String? title,
    VoidCallback? btnOkAction,
  }) {
    return DialogButton(
      child: Text(
        title ?? 'Đồng ý',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onPressed: () {
        btnOkAction?.call();
        _rflutterAlert.dismiss();
      },
      color: AppColor.orangeDark,
      radius: BorderRadius.circular(
        5.0,
      ),
    );
  }

  DialogButton _makeCancel({
    String? title,
    VoidCallback? btnCancelAction,
  }) {
    return DialogButton(
      child: Text(
        title ?? 'Bỏ qua',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onPressed: () {
        btnCancelAction?.call();
        _rflutterAlert.dismiss();
      },
      color: Colors.black26,
      radius: BorderRadius.circular(
        5.0,
      ),
    );
  }
}
