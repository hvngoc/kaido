import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propzy_home/src/domain/model/listing_model.dart';
import 'package:propzy_home/src/presentation/view/ink_well_without_ripple.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

class ProjectInfoView extends StatefulWidget {
  final Listing? listing;

  const ProjectInfoView({Key? key, required this.listing}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProjectInfoViewState();
}

class _ProjectInfoViewState extends State<ProjectInfoView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  'DỰ ÁN',
                  style: TextStyle(
                    color: AppColor.blackDefault,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 11),
              _renderProjectName(),
              SizedBox(height: 10),
              _renderAddress(),
              SizedBox(height: 10),
              _renderInvestorName(),
              SizedBox(height: 10),
              _renderProjectSize(),
              SizedBox(height: 10),
              _renderProjectBuyOrRent(),
              _renderShowDetail(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderProjectName() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Tên dự án: ',
            style: TextStyle(
              color: AppColor.secondaryText,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: widget.listing?.project?.projectName ?? "",
            style: TextStyle(
              color: AppColor.secondaryText,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  Widget _renderAddress() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Vị trí: ',
            style: TextStyle(
              color: AppColor.secondaryText,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: widget.listing?.project?.address ?? "",
            style: TextStyle(
              color: AppColor.secondaryText,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  Widget _renderInvestorName() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Chủ đầu tư: ',
            style: TextStyle(
              color: AppColor.secondaryText,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: widget.listing?.project?.investorName ?? "Đang cập nhật",
            style: TextStyle(
              color: AppColor.secondaryText,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  Widget _renderProjectSize() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Quy mô: ',
            style: TextStyle(
              color: AppColor.secondaryText,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: "${widget.listing?.project?.numberOfBlocks ?? 0} block, "
                "${widget.listing?.project?.numberOfUnits ?? 0} căn hộ",
            style: TextStyle(
              color: AppColor.secondaryText,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  Widget _renderProjectBuyOrRent() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Đang bán: ',
            style: TextStyle(
              color: AppColor.secondaryText,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: "${widget.listing?.project?.numberOfLiveListingForSale ?? 0} căn - ",
            style: TextStyle(
              color: AppColor.secondaryText,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: 'Cho thuê: ',
            style: TextStyle(
              color: AppColor.secondaryText,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: "${widget.listing?.project?.numberOfLiveListingForRent ?? 0} căn",
            style: TextStyle(
              color: AppColor.secondaryText,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderShowDetail() {
    return InkWell(
      onTap: () {
        NavigationController.navigateToKeyCondo(context,  widget.listing?.project?.id?.toString());
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: 10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Xem chi tiết",
              style: TextStyle(
                color: HexColor("1A5CAA"),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 8),
            SvgPicture.asset(
              "assets/images/ic_double_arrow_right.svg",
              width: 9,
              height: 9,
            ),
          ],
        ),
      ),
    );
  }
}
