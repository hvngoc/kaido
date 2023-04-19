import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/view/orange_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebviewScreen extends StatelessWidget {
  const CustomWebviewScreen({
    Key? key,
    required this.url,
    this.title = '',
  }) : super(key: key);

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrangeAppBar(title: title),
      body: WebView(
        initialUrl: url,
      ),
    );
  }
}
