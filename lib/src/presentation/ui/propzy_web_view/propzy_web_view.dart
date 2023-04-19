import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class PropzyWebView extends StatefulWidget {
  final String? url;

  PropzyWebView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PropzyWebViewState();
}

class _PropzyWebViewState extends State<PropzyWebView> {
  final InAppWebViewGroupOptions _options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  late String url;
  InAppWebViewController? controller;
  String? webTitle;
  double percent = 0;

  @override
  void initState() {
    super.initState();
    url = widget.url!;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final canGoBack = await controller?.canGoBack();
        if (canGoBack == true) {
          controller?.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
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
              text: webTitle ?? '',
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
            child: Column(
              children: [
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     BackButton(
                //       color: AppColor.blackDefault,
                //       onPressed: () async {
                //         final canGoBack = await controller?.canGoBack();
                //         if (canGoBack == true) {
                //           controller?.goBack();
                //         } else {
                //           Navigator.pop(context);
                //         }
                //       },
                //     ),
                //     SizedBox(width: 8),
                //     Expanded(
                //       child: Text(
                //         webTitle ?? '',
                //         overflow: TextOverflow.ellipsis,
                //         maxLines: 1,
                //         style: TextStyle(
                //           color: AppColor.blackDefault,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                Visibility(
                  visible: percent < 1,
                  child: LinearProgressIndicator(
                    minHeight: 2,
                    value: percent,
                    color: AppColor.systemBlue,
                    backgroundColor: AppColor.grayCC,
                  ),
                ),
                Expanded(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(url: Uri.parse(url)),
                    initialOptions: _options,
                    onWebViewCreated: (controller) {
                      this.controller = controller;
                    },
                    onProgressChanged: (context, progress) {
                      setState(() {
                        percent = progress / 100.0;
                      });
                    },
                    onLoadError: (controller, url, code, message) {},
                    onLoadStart: (controller, url) {},
                    onLoadStop: (controller, url) async {
                      final title = await controller.getTitle();
                      setState(() {
                        webTitle = title;
                      });
                    },
                    onUpdateVisitedHistory:
                        (controller, uri, androidIsReload) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
