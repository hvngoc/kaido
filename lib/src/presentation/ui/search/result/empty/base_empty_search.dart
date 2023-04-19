import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/contact_form_widget.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_bloc.dart';
import 'package:propzy_home/src/presentation/ui/search/result/bloc/result_event.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/number_to_vietnamese.dart';

abstract class EmptySearchView extends StatelessWidget {
  final BaseResultBloc parentBloc;

  const EmptySearchView({Key? key, required this.parentBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 40,
          ),
          alignment: Alignment.center,
          child: Lottie.asset(
            'assets/json/empty_searching.json',
            width: 140,
            height: 140,
            repeat: true,
            frameRate: FrameRate.max,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
          ),
          width: double.infinity,
          child: Text(
            'Không tìm thấy bất động sản nào',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: AppColor.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 8,
            left: 56,
            right: 56,
            bottom: 16,
          ),
          width: double.infinity,
          child: Text(
            'Thu nhỏ bản đồ hoặc thay đổi bộ lọc để thấy nhiều bất động sản hơn',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColor.gray4A,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Visibility(
          visible: parentBloc.categoryRequest.isFiltering(),
          child: Container(
            margin: EdgeInsets.only(
              top: 14,
              left: 6,
              right: 6,
            ),
            child: TextButton(
              onPressed: () {
                parentBloc.add(ResetFilterEvent());
              },
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => AppColor.rippleDark),
              ),
              child: Text(
                'Xoá tất cả bộ lọc',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColor.blueLink,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: parentBloc.categoryRequest.isFiltering(),
          child: Container(
            margin: EdgeInsets.only(
              top: 6,
              left: 12,
              right: 12,
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: buildFilterTag(),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 26,
            left: 10,
            right: 10,
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactFormSearchView()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(
                2,
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Để lại thông tin của bạn',
                      style: TextStyle(
                        color: AppColor.blueLink,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          ', chúng tôi sẽ liên hệ khi có bất động sản phù hợp.',
                      style: TextStyle(
                        color: AppColor.gray4A,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> buildFilterTag() {
    List<Widget> result = [];
    final propertyTypeIds =
        parentBloc.categoryRequest.propertyTypeIds?.map((e) => e).toList();
    propertyTypeIds
        ?.removeWhere((e) => e?.name == null || e?.isChecked == false);
    if (propertyTypeIds != null) {
      final text = propertyTypeIds.map((e) => e?.name).join(", ");
      final widget =
          renderItemSearchSelectedView(text, ResetPropertyTypeEvent());
      result.add(widget);
    }
    final amenity = buildAmenityView();
    if (amenity != null) {
      result.add(amenity);
    }
    final status = buildStatusView();
    if (status != null) {
      result.add(status);
    }
    final directionIds =
        parentBloc.categoryRequest.directionIds?.map((e) => e).toList();
    directionIds?.removeWhere((e) => e?.name == null || e?.isChecked == false);
    if (directionIds != null) {
      final text = directionIds.map((e) => e?.name).join(", ");
      final widget = renderItemSearchSelectedView(text, ResetDirectionEvent());
      result.add(widget);
    }

    final bedroom = parentBloc.categoryRequest.bedrooms?.description;
    if (bedroom != null) {
      final widget = renderItemSearchSelectedView(
          '$bedroom phòng ngủ', ResetBedroomsEvent());
      result.add(widget);
    }
    final bathroom = parentBloc.categoryRequest.bathrooms?.description;
    if (bathroom != null) {
      final widget = renderItemSearchSelectedView(
          '$bathroom phòng tắm', ResetBathroomsEvent());
      result.add(widget);
    }
    final content = parentBloc.categoryRequest.contentId?.description;
    if (content != null) {
      final widget = renderItemSearchSelectedView(content, ResetContentEvent());
      result.add(widget);
    }
    final propertyPosition =
        parentBloc.categoryRequest.propertyPosition?.description;
    if (propertyPosition != null) {
      final widget = renderItemSearchSelectedView(
          propertyPosition, ResetPropertyPositionEvent());
      result.add(widget);
    }

    String? year = null;
    final minYear = parentBloc.categoryRequest.minYear;
    final maxYear = parentBloc.categoryRequest.maxYear;
    if (minYear != null && maxYear != null) {
      if (minYear == maxYear) {
        year = '$minYear';
      } else {
        year = '$minYear - $maxYear';
      }
    } else if (minYear == null && maxYear != null) {
      year = 'Trước $maxYear';
    } else if (minYear != null && maxYear == null) {
      year = 'Sau $minYear';
    }
    if (year != null) {
      final widget = renderItemSearchSelectedView(year, ResetYearEvent());
      result.add(widget);
    }

    String? price = null;
    final minPrice = parentBloc.categoryRequest.minPrice;
    final maxPrice = parentBloc.categoryRequest.maxPrice;
    if (minPrice != null && maxPrice != null) {
      if (minPrice == maxPrice) {
        price = NumberToVietnamese.toPrice(minPrice);
      } else {
        price =
            '${NumberToVietnamese.toPrice(minPrice)} - ${NumberToVietnamese.toPrice(maxPrice)}';
      }
    } else if (minPrice == null && maxPrice != null) {
      price = 'Dưới ${NumberToVietnamese.toPrice(maxPrice)}';
    } else if (minPrice != null && maxPrice == null) {
      price = 'Trên ${NumberToVietnamese.toPrice(minPrice)}';
    }
    if (price != null) {
      final widget = renderItemSearchSelectedView(price, ResetPriceEvent());
      result.add(widget);
    }

    String? size = null;
    final minSize =
        NumberToVietnamese.formatNumber(parentBloc.categoryRequest.minSize);
    final maxSize =
        NumberToVietnamese.formatNumber(parentBloc.categoryRequest.maxSize);
    if (minSize != null && maxSize != null) {
      if (minSize == maxSize) {
        size = '${minSize}m²';
      } else {
        size = '$minSize - ${maxSize}m²';
      }
    } else if (minSize == null && maxSize != null) {
      size = 'Dưới ${maxSize}m²';
    } else if (minSize != null && maxSize == null) {
      size = 'Trên ${minSize}m²';
    }
    if (size != null) {
      final widget = renderItemSearchSelectedView(size, ResetSizeEvent());
      result.add(widget);
    }

    return result;
  }

  Widget? buildAmenityView();

  Widget? buildStatusView();

  Widget renderItemSearchSelectedView(String _name, CategoryEvent event) {
    return Material(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
      color: AppColor.grayD8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_name.length > 20 ? '${_name.substring(0, 20)}...' : _name),
            SizedBox(width: 2),
            InkResponse(
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => AppColor.rippleLight),
              radius: 20,
              child:
                  SvgPicture.asset("assets/images/ic_remove_item_search.svg"),
              onTap: () {
                parentBloc.add(event);
              },
            ),
          ],
        ),
      ),
    );
  }
}
