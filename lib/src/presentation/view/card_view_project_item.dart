import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

import 'image_thumbnail_view.dart';
import 'pager_with_dot.dart';

class CardViewProjectItem extends StatefulWidget {
  const CardViewProjectItem({
    Key? key,
    required this.id,
    required this.listImages,
    required this.projectName,
    required this.priceFrom,
    required this.address,
    required this.investor,
    required this.selling,
    required this.isSelling,
    required this.renting,
    required this.isRenting,
  }) : super(key: key);

  final int id;
  final List<String>? listImages;
  final String projectName;
  final String priceFrom;
  final String address;
  final String investor;
  final String selling;
  final bool isSelling;
  final String renting;
  final bool isRenting;

  @override
  State<CardViewProjectItem> createState() => _CardViewProjectItemState();
}

class _CardViewProjectItemState extends State<CardViewProjectItem> {
  int currentPageValue = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget>? listThumbnail = widget.listImages
        ?.map((url) => ImageThumbnailView(
              fileUrl: url,
              errImage: 'assets/images/ic_default_image_listing.png',
            ))
        .toList();

    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      color: AppColor.white,
      shadowColor: AppColor.rippleDark,
      child: InkWell(
        onTap: () {
          NavigationController.navigateToKeyCondo(
              context, widget.id.toString());
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.projectName,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      letterSpacing: 1.1,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColor.secondaryText,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                    width: double.infinity,
                  ),
                  Text(
                    widget.priceFrom,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      letterSpacing: 1.1,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.secondaryText,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                    width: double.infinity,
                  ),
                  Text(
                    widget.address,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      letterSpacing: 1.1,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.secondaryText,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                    width: double.infinity,
                  ),
                  Text(
                    widget.investor,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      letterSpacing: 1.1,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.secondaryText,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                    width: double.infinity,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: widget.isSelling,
                        child: Expanded(
                          child: Text(
                            widget.selling,
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
                      ),
                      Visibility(
                        visible: widget.isRenting,
                        child: Expanded(
                          child: Text(
                            widget.renting,
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
