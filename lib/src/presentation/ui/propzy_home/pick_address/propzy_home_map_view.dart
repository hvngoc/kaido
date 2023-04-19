import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:propzy_home/src/presentation/di/locator.dart';
import 'package:propzy_home/src/presentation/view/ink_well_without_ripple.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/message_util.dart';

enum LoadPropzyMapState {
  LOADING,
  SUCCESS,
  ERROR,
}

class PropzyHomeMapView extends StatelessWidget {
  final LoadPropzyMapState? state;
  final String? session;
  final Function? onClickRetry;
  final Function(String lat, String lng)? onLocationChange;
  final Function(bool isLoadMapDone)? onLoadMapDone;
  final Function(InAppWebViewController controller)? getController;
  final int? propertyTypeId;
  String? lat;
  String? lng;

  PropzyHomeMapView({
    Key? key,
    this.state,
    this.session,
    this.onClickRetry,
    this.onLocationChange,
    this.propertyTypeId,
    this.onLoadMapDone,
    this.getController,
  }) : super(key: key);

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: _renderContent(),
      ),
    );
  }

  Widget _renderContent() {
    if (state == LoadPropzyMapState.LOADING) {
      return _renderLoadingView();
    } else if (state == LoadPropzyMapState.SUCCESS) {
      if (session?.isEmpty == true) return _renderErrorView();
      return _renderMapView();
    } else if (state == LoadPropzyMapState.ERROR) {
      return _renderErrorView();
    } else {
      return Container();
    }
  }

  Widget _renderLoadingView() {
    return Center(
      child: LoadingView(
        width: 160,
        height: 160,
      ),
    );
  }

  Widget _renderErrorView() {
    return Container(
      width: double.infinity,
      color: HexColor("666666"),
      child: InkWellWithoutRipple(
        onTap: () {
          onClickRetry?.call();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              MessageUtil.errorMessageDefault,
              style: TextStyle(
                color: HexColor("eaeaea"),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Nhấn để thử lại",
              style: TextStyle(
                color: HexColor("eaeaea"),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderMapView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(getUrl())),
      initialOptions: options,
      onWebViewCreated: (controller) {
        getController?.call(controller);
      },
      onLoadError: (controller, url, code, message) {
        print(message);
      },
      onLoadStart: (controller, url) {
        onLoadMapDone?.call(false);
      },
      onLoadStop: (controller, url) {
        onLoadMapDone?.call(true);
      },
      onUpdateVisitedHistory: (controller, uri, androidIsReload) {
        String url = uri.toString();
        List<String> splits = url.split("latlng=");
        if (splits.length > 1) {
          String latLngStrings = splits[1];
          if (latLngStrings.contains("&typemap")) {
            String typeMap = getTypeMap();
            latLngStrings = latLngStrings.replaceAll("&typemap=$typeMap", "");
          }

          if (latLngStrings.contains(",")) {
            onLocationChange?.call(latLngStrings.split(",")[0], latLngStrings.split(",")[1]);
          }
        }
      },
    );
  }

  String getTypeMap() {
    return propertyTypeId == PROPERTY_TYPES.CHUNG_CU.type
        ? "tat,te"
        : "ranhthua,te";
  }

  String getUrl() {
    String url = "${getPropzyMapUrl()}${session}&typemap=${getTypeMap()}";
    if (lat != null && lng != null) {
      url += "&latlng=$lat,$lng";
    }
    return url;
  }
}
