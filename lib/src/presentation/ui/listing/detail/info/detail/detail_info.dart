import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/domain/model/property_type_model.dart';
import 'package:propzy_home/src/domain/request/CategoryType.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class DetailInfoView extends StatefulWidget {
  final Listing? listing;

  const DetailInfoView({Key? key, required this.listing}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailInfoViewState();
}

class _DetailInfoViewState extends State<DetailInfoView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 4,
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  'THÔNG TIN CHI TIẾT',
                  style: TextStyle(
                    color: AppColor.blackDefault,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 11,
              ),
              _renderRowInfo(
                title: "Mã tin",
                value: "${widget.listing?.listingId ?? "N/A"}",
                isFirstInfo: true,
                visible: true,
              ),
              _renderRowInfo(
                title: "Đơn giá đất",
                value: "${widget.listing?.formatUnitLand ?? "N/A"}",
                tooltip: true,
                visible: widget.listing?.listingTypeId == CategoryType.BUY.type &&
                    PropertyType.HOME.category.toString() ==
                        widget.listing?.propertyType?.category &&
                    (widget.listing?.unitLand ?? 0) < (widget.listing?.unitPrice ?? 0),
              ),
              _renderRowInfo(
                  title: PropertyType.PROJECT.category.toString() ==
                          widget.listing?.propertyType?.category
                      ? "Đơn giá"
                      : "Giá gộp",
                  value: "${widget.listing?.formatUnitPrice ?? "N/A"}",
                  visible: widget.listing?.listingTypeId == CategoryType.BUY.type),
              _renderRowInfo(
                title: "Thanh toán chỉ từ",
                value: "${widget.listing?.formatUnitPrice ?? "N/A"}",
                url: "aaa",
                visible: false && widget.listing?.listingTypeId == CategoryType.BUY.type,
              ),
              _renderRowInfo(
                title: "Phòng ngủ",
                value: "${widget.listing?.formatBedrooms ?? "N/A"}",
                visible: true,
              ),
              _renderRowInfo(
                title: "Phòng tắm",
                value: "${widget.listing?.formatBathrooms ?? "N/A"}",
                visible: true,
              ),
              _renderRowInfo(
                title: "Hướng",
                value: "${widget.listing?.directionName ?? "N/A"}",
                visible: true,
              ),
              _renderRowInfo(
                title: "Chiều dài",
                value: "${widget.listing?.formatSizeLength ?? "N/A"}",
                visible: true,
              ),
              _renderRowInfo(
                title: "Chiều rộng",
                value: "${widget.listing?.formatSizeWidth ?? "N/A"}",
                visible: true,
              ),
              _renderRowInfo(
                title: "Diện tích đất",
                value: "${widget.listing?.formatLotSize ?? "N/A"}",
                visible: true,
              ),
              _renderRowInfo(
                title: "Diện tích sử dụng",
                value: "${widget.listing?.formatFloorSize ?? "N/A"}",
                visible: true,
              ),
              _renderRowInfo(
                title: "Độ rộng hẻm",
                value: "${widget.listing?.formatAlleyWidth ?? "N/A"}",
                visible: true,
              ),
              _renderRowInfo(
                title: "Độ rộng mặt tiền đường",
                value: "${widget.listing?.formatRoadFrontageWidth ?? "N/A"}",
                visible: true,
              ),
              _renderRowInfo(
                title: "Kết cấu nhà",
                value: "${widget.listing?.formatStructure ?? "N/A"}",
                visible: true,
              ),
              _renderRowInfo(
                title: "Hiện trạng nhà",
                value: "${widget.listing?.statusQuoName ?? "N/A"}",
                visible: true,
              ),
              _renderRowInfo(
                title: "Giấy tờ",
                value: "${widget.listing?.useRightTypeName ?? "N/A"}",
                visible: true,
              ),
              _renderRowInfo(
                title: "Năm xây dựng",
                value: "${widget.listing?.yearBuilt ?? "N/A"}",
                visible: true,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          height: 1,
          color: HexColor('D7D7D7'),
        ),
      ],
    );
  }

  Widget _renderRowInfo({
    required String title,
    required String value,
    required bool visible,
    bool? tooltip = false,
    String? url,
    bool? isFirstInfo = false,
  }) {
    return Visibility(
      visible: visible && value != "N/A" && value != "--",
      child: Column(
        children: [
          isFirstInfo == true
              ? SizedBox(
                  height: 12,
                )
              : Column(
                  children: [
                    Divider(
                      height: 1,
                      color: Color.fromRGBO(215, 215, 215, 0.8),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: HexColor("4A4A4A"),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  tooltip == true
                      ? InkWell(
                          radius: 24,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: _renderContentBottomSheet,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                            );
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            padding: EdgeInsets.all(5),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/images/ic_info_tool_tip.svg",
                                width: 15,
                                height: 15,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              url == null
                  ? Flexible(
                      child: Text(
                        value,
                        style: TextStyle(
                          color: HexColor("4A4A4A"),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      style: TextStyle(
                        color: HexColor("1A5CAA"),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationColor: HexColor("1A5CAA"),
                        decorationThickness: 1,
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget _renderContentBottomSheet(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Đơn giá đất:",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColor.blackDefault,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Là đơn giá không bao gồm giá trị công trình. "
                      "Đơn giá này được xác định dựa trên các thuật toán tự động và hệ thống dữ liệu thị trường của Propzy. "
                      "Đơn giá này chỉ mang tính chất tham khảo và không phải kết quả định giá chính thức. "
                      "Để có kết quả định giá chính xác vui lòng liên hệ hotline",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColor.blackDefault,
                  ),
                ),
                TextSpan(
                  text: " *4663",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: HexColor('007AFF'),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _makePhoneCall();
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall() async {
    // final Uri launchUri = Uri(
    //   scheme: 'tel',
    //   path: "*4663",
    // );
    // await launchUrl(launchUri);
    await FlutterPhoneDirectCaller.callNumber("*4663");
  }
}
