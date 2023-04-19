import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get_it/get_it.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/presentation/ui/profile/bloc/authentication_bloc.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/util/checkbox_custom.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  static CheckboxFilter checkboxFilterAll(bool? isSelected) {
    return CheckboxFilter(
      value: isSelected,
      assetName: 'assets/images/filter_check_all.svg',
      selectedAssetName: 'assets/images/filter_check_all_selected.svg',
    );
  }

  static CheckboxFilter checkboxFilter(bool? isSelected) {
    return CheckboxFilter(
      value: isSelected,
    );
  }

  static Future<void> showMyDialog({
    required BuildContext context,
    String? title,
    required String message,
    String? textActionCancel,
    Function? actionCancel,
    String? textActionOk,
    Function? actionOk,
  }) async {
    List<Widget> listAction = <Widget>[];
    if (actionOk != null && textActionOk != null) {
      listAction.add(TextButton(
        child: Text(textActionCancel ?? "Cancel"),
        onPressed: () {
          actionCancel?.call();
          Navigator.of(context, rootNavigator: true).pop();
        },
      ));

      listAction.add(TextButton(
        child: Text(textActionOk.toString()),
        onPressed: () {
          actionOk.call();
          Navigator.of(context, rootNavigator: true).pop();
        },
      ));
    } else {
      listAction.add(TextButton(
        child: Text(textActionCancel ?? "Ok"),
        onPressed: () {
          actionCancel?.call();
          Navigator.of(context, rootNavigator: true).pop();
        },
      ));
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title.toString()) : null,
          content: Text(message),
          actions: listAction,
        );
      },
    );
  }

  static bool isPhoneNumber(String? text) {
    if (text == null) {
      return false;
    }
    return RegExp(r'^([0]{1})([0-9]{9})$').hasMatch(text);
  }

  static bool isEmailAddress(String? text) {
    if (text == null) {
      return false;
    }
    return EmailValidator.validate(text);
  }

  static bool isDecimalNumber(double? text) {
    return text != null && text != 0;
  }

  static bool isUrl(String? url) {
    if (url == null) return false;
    if (url.toString().isEmpty == true) return false;
    return url.toString().startsWith("http") ||
        url.toString().startsWith("https");
  }

  static double roundDouble(double value) {
    double mod = 100;
    return ((value * mod).floorToDouble() / mod);
  }

  static String formatPriceInSuggest(double price) {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    if (price >= 1000000000) {
      final numBillion = price / 1000000000;
      final formatStr = roundDouble(numBillion)
          .toString()
          .replaceAll(regex, '')
          .replaceAll('.', ',');
      return '${formatStr} tỷ';
    } else {
      final numMillion = price / 1000000;
      return '${numMillion.toInt()} triệu';
    }
  }

  static void showLoading() {
    SmartDialog.show(
      backDismiss: false,
      clickMaskDismiss: false,
      builder: (context) {
        return LoadingView(
          width: 200,
          height: 200,
        );
      },
    );
  }

  static void hideLoading() {
    SmartDialog.dismiss();
  }

  static Future<void> clearAppCache() async {
    final PrefHelper prefHelper = GetIt.I.get<PrefHelper>();
    await prefHelper.removeAccessToken();
    await prefHelper.removeRefreshToken();
    await prefHelper.removeUserInfo();

    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  static Future<String> versionApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (kReleaseMode) {
      return packageInfo.version;
    }
    return '${packageInfo.version} (${packageInfo.buildNumber})';
  }

  static void launchUrlString(String url,
      {LaunchMode mode = LaunchMode.platformDefault}) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(
      _url,
      mode: mode,
    )) throw 'Could not launch $_url';
  }

  static void signOut() {
    final _authenticationBloc = GetIt.I.get<AuthenticationBloc>();
    _authenticationBloc.add(AuthenticationLogoutRequested());
  }

  static void showOpenSettings(BuildContext context, String message) {
    Util.showMyDialog(
      context: context,
      title: "Thông báo",
      message: message,
      textActionCancel: "Hủy",
      actionCancel: () {},
      textActionOk: "Ok",
      actionOk: () {
        openAppSettings();
      },
    );
  }

  static Widget makeDismissable({required BuildContext context, required Widget child}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(onTap: () {}, child: child),
      );

  static void showCustomBottomSheet(
      BuildContext context, Widget builder(BuildContext context)) async {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return makeDismissable(
          context: context,
          child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (_, controller) => builder(context),
          ),
        );
      },
    );
  }

  static Future<String?> getDeviceUUID() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      final uuid = iosInfo.identifierForVendor;
      return uuid;
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      final uuid = androidInfo.androidId;
      return uuid;
    }
    return null;
  }

  static Future<String?> getDeviceModelInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      final model = iosInfo.utsname.machine;  //iPhone10,4
      return model;
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      final manufacturer = androidInfo.manufacturer;
      final model = androidInfo.model;
      if (manufacturer == null && model == null) {
        return null;
      }
      final modelInfo = '${manufacturer ?? ''} ${model ?? ''}'; //Google sdk_gphone64_arm64
      return modelInfo;
    }
    return null;
  }

  static Future<String?> getDeviceOSInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      final systemName = iosInfo.systemName;
      final systemVersion = iosInfo.systemVersion;
      if (systemName == null && systemVersion == null) {
        return null;
      }
      final osInfo = '${systemName ?? ''} ${systemVersion ?? ''}';  //iOS 15.6
      return osInfo;
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      final release = androidInfo.version.release;
      final sdkInt = androidInfo.version.sdkInt;
      if (release == null && sdkInt == null) {
        return null;
      }
      final osInfo = 'Android ${release ?? ''} (SDK ${sdkInt ?? ''})';  //Android 12 (SDK 32)
      return osInfo;
    }
    return null;
  }

  static Future<String?> getWifiIP() async {
    final info = NetworkInfo();
    var wifiIP = await info.getWifiIP();
    return wifiIP;
  }
}
