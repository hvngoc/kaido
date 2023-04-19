import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:propzy_home/src/config/core.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'src/config/app_config.dart';
import 'app.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: AppColor.orangeDark, // status bar color
  ));

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  Core.init(Environment.RELEASE);
  Widget app = await initializeApp();
  runApp(app);
}
