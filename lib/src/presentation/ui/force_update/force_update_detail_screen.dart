import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:launch_review/launch_review.dart';
import 'package:propzy_home/src/data/model/force_update_info.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class ForceUpdateDetailScreen extends StatefulWidget {
  final ForceUpdateInfo? forceUpdateInfo;

  const ForceUpdateDetailScreen({Key? key, required this.forceUpdateInfo}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForceUpdateDetailScreenState();
}

class _ForceUpdateDetailScreenState extends State<ForceUpdateDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              _renderHeaderView(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      Text(
                        'Việc sử dụng dữ liệu di động để tải có thể phát sinh phí. Bạn nên sử dụng Wi-Fi',
                        style: TextStyle(
                          color: HexColor('FF9500'),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 24),
                      _renderBoxWhatNew(),
                      SizedBox(height: 24),
                      _renderDescriptionUpdateContent(),
                    ],
                  ),
                ),
              ),
              _renderFooterView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderHeaderView() {
    return Container(
      height: 48,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 48,
              height: 48,
              child: Center(
                child: SvgPicture.asset("assets/images/ic_arrow_left_black.svg"),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Cập nhật phần mềm',
                style: TextStyle(
                  color: AppColor.blackDefault,
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderBoxWhatNew() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Color.fromRGBO(116, 116, 128, 0.08),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Có gì mới ?',
                    style: TextStyle(
                      color: HexColor('#155AA9'),
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tìm hiểm xem bản cập nhật này bao gồm những gì ',
                    style: TextStyle(
                      color: HexColor('#6A6D74'),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: Container(
              child: Image.asset(
                "assets/images/ic_rocket_1.png",
                width: 140,
                height: 120,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderDescriptionUpdateContent() {
    return Container(
      child: Html(
        data: widget.forceUpdateInfo?.moreContent ?? "",
      ),
    );
  }

  Widget _renderFooterView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              LaunchReview.launch(androidAppId: "vn.propzy.sam", iOSAppId: "1437366845");
            },
            child: Ink(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColor.orangeDark,
              ),
              child: Center(
                child: Text(
                  'Cập nhật',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          widget.forceUpdateInfo?.required == true
              ? Container()
              : Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Ink(
                        height: 48,
                        child: Center(
                          child: Text(
                            'Để sau',
                            style: TextStyle(
                              color: HexColor('#007AFF'),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
        ],
      ),
    );
  }
}
