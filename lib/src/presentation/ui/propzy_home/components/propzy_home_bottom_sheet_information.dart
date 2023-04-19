import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PropzyHomeBottomSheetInformation extends StatelessWidget {
  final String contentHtml;

  PropzyHomeBottomSheetInformation({Key? key, required this.contentHtml})
      : super(key: key);

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 14),
          Container(
            height: 5,
            width: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 14),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10, left: 20, bottom: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              // child: SingleChildScrollView(
              //   child: InteractiveViewer(
              //     panEnabled: false,
              //     child: Html(
              //       data: contentHtml,
              //     ),
              //   ),
              //   physics: AlwaysScrollableScrollPhysics(),
              // ),
              child: InAppWebView(
                // userAgent: "random",
                gestureRecognizers: gestureRecognizers,
                onWebViewCreated: (controller) {
                  controller.loadData(
                    data: contentHtml,
                    mimeType: 'text/html',
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
