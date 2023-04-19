import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/presentation/view/pager_with_dot.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

import 'image_thumbnail_view.dart';

class CardViewSearchHome extends StatefulWidget {
  const CardViewSearchHome({
    Key? key,
    required this.isFavorite,
    required this.listImages,
    required this.isPropzyHome,
    required this.isPriceDown,
    this.labelName,
    this.tradedStatus,
    this.formattedPriceVnd,
    this.formattedUnitPrice,
    this.address,
    this.title,
    this.bedrooms,
    this.bathrooms,
    this.formattedSize,
    this.directionName,
    this.projectName,
    this.projectId,
    required this.listingId,
  }) : super(key: key);

  final int listingId;
  final bool isFavorite;
  final bool isPropzyHome;
  final bool isPriceDown;
  final String? labelName;
  final String? tradedStatus;
  final String? formattedPriceVnd;
  final String? formattedUnitPrice;
  final String? title;
  final String? address;
  final String? bedrooms;
  final String? bathrooms;
  final String? formattedSize;
  final String? directionName;
  final String? projectName;
  final int? projectId;
  final List<String>? listImages;

  @override
  State<StatefulWidget> createState() => _CardViewSearchHomeState();
}

class _CardViewSearchHomeState extends State<CardViewSearchHome> {
  int currentPageValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget>? listThumbnail = widget.listImages
        ?.map((url) => ImageThumbnailView(
              fileUrl: url,
              errImage: 'assets/images/ic_default_image_listing.png',
            ))
        .toList();

    return Card(
      ///https://stackoverflow.com/questions/53267675/flutter-card-top-radius-is-covered-by-image
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      color: AppColor.white,
      shadowColor: AppColor.rippleDark,
      child: InkWell(
        onTap: () {
          NavigationController.navigateToListingDetail(
              context, widget.listingId);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Visibility(
                  visible: widget.listImages == null ||
                      widget.listImages!.length <= 0,
                  child: Image.asset(
                    'assets/images/ic_default_image_listing.png',
                    fit: BoxFit.cover,
                    height: 220,
                    width: double.infinity,
                  ),
                ),
                Visibility(
                    visible: widget.listImages != null &&
                        widget.listImages!.length > 0,
                    child: Container(
                      alignment: Alignment.center,
                      height: 220,
                      width: double.infinity,
                      child: PagerDotIndicator(
                        currentPageValue: currentPageValue,
                        onPageChanged: (int page) {
                          currentPageValue = page;
                          setState(() {});
                        },
                        indicatorSpacing: 3,
                        indicatorMarginBottom: 8,
                        indicatorSelectedSize: 8,
                        indicatorNormalSize: 5,
                        indicatorSelectedColor: AppColor.orangeDark,
                        indicatorNormalColor: AppColor.dividerGray,
                        listWidgets: listThumbnail ?? [],
                      ),
                    )),
                Row(
                  children: [
                    Visibility(
                      visible: widget.isPropzyHome,
                      child: Container(
                        height: 26,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          "assets/images/vector_ic_logo_propzy_home.svg",
                          height: 26,
                        ),
                        margin: const EdgeInsets.only(left: 10, top: 10),
                      ),
                    ),
                    Visibility(
                      visible: widget.labelName != null,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, top: 10),
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        alignment: Alignment.center,
                        height: 26,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          color: AppColor.black_55p,
                        ),
                        child: Text(
                          '${widget.labelName}',
                          textScaleFactor: 1,
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.tradedStatus != null,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, top: 10),
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            color: AppColor.black_55p),
                        child: Text(
                          '${widget.tradedStatus}',
                          textScaleFactor: 1,
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: widget.isPriceDown,
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 12, top: 210, right: 12),
                    padding: const EdgeInsets.only(
                      left: 4,
                      right: 6,
                      top: 2,
                      bottom: 2,
                    ),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        color: AppColor.greenBackground),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        Icon(
                          Icons.arrow_downward_rounded,
                          color: AppColor.greenTextBadge,
                          size: 16,
                        ),
                        Text(
                          'Vừa giảm giá',
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.greenTextBadge,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                top: widget.isPriceDown ? 6 : 12,
                left: 12,
                right: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${widget.formattedPriceVnd}',
                        style: TextStyle(
                            letterSpacing: 1.1,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColor.secondaryText),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: Text(
                          '${widget.formattedUnitPrice}',
                          style: TextStyle(
                              letterSpacing: 1.1,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColor.black_65p),
                        ),
                      )
                    ],
                  ),
                  InkResponse(
                    radius: 24,
                    onTap: () {},
                    child: SvgPicture.asset(
                      widget.isFavorite
                          ? 'assets/images/vector_ic_heart_active.svg'
                          : 'assets/images/vector_ic_heart_normal.svg',
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12, right: 12, top: 4),
              height: 30,
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget.title}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  letterSpacing: 1.1,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black_80p,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12, right: 12, top: 2),
              height: 26,
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget.address}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  letterSpacing: 1.1,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.secondaryText,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 4,
                bottom: widget.projectName != null ? 4 : 8,
              ),
              child: Row(
                children: [
                  Container(
                    child:
                        SvgPicture.asset("assets/images/vector_ic_bedroom.svg"),
                    padding: const EdgeInsets.only(right: 8),
                  ),
                  Text(
                    '${widget.bedrooms}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black_65p),
                  ),
                  Container(
                    child: SvgPicture.asset(
                        "assets/images/vector_ic_bathroom.svg"),
                    padding: const EdgeInsets.only(right: 8, left: 20),
                  ),
                  Text(
                    '${widget.bathrooms}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.black_65p,
                    ),
                  ),
                  Container(
                    child: SvgPicture.asset("assets/images/vector_ic_area.svg"),
                    padding: const EdgeInsets.only(right: 8, left: 20),
                  ),
                  Text(
                    '${widget.formattedSize}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black_65p),
                  ),
                  Container(
                    child: SvgPicture.asset(
                        "assets/images/vector_ic_direction.svg"),
                    padding: const EdgeInsets.only(right: 8, left: 20),
                  ),
                  Flexible(
                    child: Text(
                      '${widget.directionName}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.black_65p),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.projectName != null,
              child: InkWell(
                onTap: () {
                  NavigationController.navigateToKeyCondo(
                      context, widget.projectId?.toString());
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 26,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Text(
                        "${widget.projectName}",
                        style: TextStyle(
                          color: AppColor.blueLink,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
