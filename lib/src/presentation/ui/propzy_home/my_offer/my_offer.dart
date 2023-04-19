import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/my_offer/my_offer_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/my_offer/my_offer_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/my_offer/my_offer_state.dart';
import 'package:propzy_home/src/presentation/view/image_thumbnail_view.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/presentation/view/pager_with_dot.dart';
import 'package:propzy_home/src/util/alert_dialog.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/message_util.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class MyOfferScreen extends StatefulWidget {
  const MyOfferScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyOfferScreenState();
}

class _MyOfferScreenState extends State<MyOfferScreen> {
  final MyOfferBloc _bloc = GetIt.instance.get<MyOfferBloc>();

  int currentPageImage = 0;
  int currentPageOffer = 0;
  final int PAGE_SIZE = 20;

  List<HomeOfferModel>? listOffers = null;
  ScrollController _scrollControllerListOffers = ScrollController();
  bool isLoadingMoreListOffers = false;
  bool isLoadAllDataOffers = false;

  @override
  void initState() {
    super.initState();
    _bloc.add(GetListCategoriesOfferEvent());

    _scrollControllerListOffers.addListener(_listenerLoadMoreListOffers);
  }

  void _listenerLoadMoreListOffers() {
    if (_scrollControllerListOffers.position.extentAfter < 50 &&
        !isLoadingMoreListOffers &&
        !isLoadAllDataOffers) {
      isLoadingMoreListOffers = true;
      currentPageOffer++;
      PropzyHomeCategoryOffer categoryOffer =
          _bloc.listCategories.firstWhere((element) => element.isChecked == true);
      _bloc.add(
        GetListOffersByCategoryEvent(
          categoryOffer.id ?? 1,
          currentPageOffer,
          PAGE_SIZE,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider(create: (BuildContext context) => _bloc);
    return BlocConsumer<MyOfferBloc, MyOfferState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is LoadingGetListCategoriesState || state is LoadingGetListOffersState) {
          Util.showLoading();
        } else if (state is ErrorState) {
          Util.hideLoading();
          AppAlert.showErrorAlert(
            context,
            state.message ?? MessageUtil.errorMessageDefault,
          );
        } else if (state is SuccessGetListCategoriesState) {
          Util.hideLoading();
          if (_bloc.listCategories.isNotEmpty) {
            int indexSelected =
                _bloc.listCategories.indexWhere((element) => element.isChecked == true);
            currentPageOffer = 0;
            isLoadAllDataOffers = false;
            isLoadingMoreListOffers = false;
            if (indexSelected != -1) {
              _bloc.add(
                GetListOffersByCategoryEvent(
                  _bloc.listCategories[indexSelected].id!,
                  currentPageOffer,
                  PAGE_SIZE,
                ),
              );
            } else {
              _bloc.add(
                GetListOffersByCategoryEvent(
                  _bloc.listCategories[0].id!,
                  currentPageOffer,
                  PAGE_SIZE,
                ),
              );
            }
          }
          setState(() {});
        } else if (state is SuccessGetListOffersState) {
          Util.hideLoading();
          if (isLoadingMoreListOffers) {
            listOffers?.addAll(state.listOffers);
          } else {
            listOffers = state.listOffers;
          }

          isLoadingMoreListOffers = false;
          isLoadAllDataOffers = state.lastPage ?? false;

          setState(() {
            listOffers = listOffers;
          });
        } else if (state is SuccessSelectItemCategoryState) {
          _bloc.add(GetListCategoriesOfferEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _renderHeaderView(),
                _renderListCategory(),
                Divider(height: 0.8, color: HexColor("a9a9a9")),
                Expanded(
                  child: _renderListOffer(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _renderHeaderView() {
    return Container(
      color: Color.fromRGBO(255, 255, 255, 0.94),
      height: kToolbarHeight,
      padding: EdgeInsets.only(left: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _renderBackButton(),
          Expanded(
            child: Text(
              "Danh sách đề nghị bán",
              style: TextStyle(
                color: AppColor.blackDefault,
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              NavigationController.navigateToIBuyPropertyType(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/ic_cart_orange.svg",
                    width: 23,
                    height: 23,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Bán cho Propzy",
                    style: TextStyle(
                      color: AppColor.orangeDark,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderBackButton() {
    return Material(
      child: InkResponse(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: 40,
          height: 40,
          child: Icon(Icons.arrow_back),
        ),
      ),
    );
  }

  Widget _renderListCategory() {
    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 12,
        bottom: 8,
      ),
      height: 67,
      color: Colors.white,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: _renderItemCategory,
        scrollDirection: Axis.horizontal,
        itemCount: _bloc.listCategories.length,
      ),
    );
  }

  Widget _renderItemCategory(BuildContext context, int index) {
    PropzyHomeCategoryOffer categoryOffer = _bloc.listCategories[index];
    return InkWell(
      onTap: () {
        _bloc.add(SelectItemCategoryEvent(index));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: EdgeInsets.only(right: 5),
        height: 35,
        decoration: BoxDecoration(
          borderRadius: categoryOffer.isChecked == true ? BorderRadius.circular(20) : null,
          color:
              categoryOffer.isChecked == true ? Color.fromRGBO(0, 0, 0, 0.06) : Colors.transparent,
        ),
        child: Center(
          child: Text(
            "${categoryOffer.name} (${categoryOffer.numberOffer ?? 0})",
            style: TextStyle(
              color: categoryOffer.isChecked == true ? AppColor.blackDefault : HexColor("636366"),
              fontSize: 14,
              fontWeight: categoryOffer.isChecked == true ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderListOffer() {
    if (listOffers == null) {
      return Container(
        color: Colors.white,
        width: double.infinity,
      );
    } else {
      if (listOffers?.isEmpty == true) {
        return Container(
          color: Colors.white,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/ic_do_not_have_offer.png",
                width: 240,
                height: 240,
              ),
              SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Bạn chưa có đề nghị bán nào!",
                  style: TextStyle(
                    color: HexColor("6A6D74"),
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ListView.builder(
            controller: _scrollControllerListOffers,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              bool showMore = index == (listOffers?.length ?? 1) - 1 && !isLoadAllDataOffers;
              if (showMore) {
                return Container(
                  alignment: Alignment.center,
                  child: const LoadingView(
                    width: 160,
                    height: 80,
                  ),
                );
              }
              return _renderItemOffer(context, index);
            },
            itemCount: listOffers?.length,
          ),
        );
      }
    }
  }

  Widget _renderItemOffer(BuildContext context, int index) {
    HomeOfferModel offerModel = listOffers![index];
    return Container(
      margin: EdgeInsets.only(top: index == 0 ? 0 : 24),
      child: InkWell(
        onTap: () {
          NavigationController.navigateToDetailOffer(context, offerModel.id ?? 0);
        },
        child: Card(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          color: AppColor.white,
          shadowColor: AppColor.rippleDark,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: [
                  _renderListImageSlider(offerModel),
                  _renderStatusOffer(offerModel),
                ],
              ),
              _renderDetailInfo(offerModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderListImageSlider(HomeOfferModel offerModel) {
    List<Widget>? listThumbnail = offerModel.files
        // ?.skipWhile((value) => value.typeFile == 2)
        ?.map(
      (file) {
        if (file.typeFile == Constants.MEDIA_FILE_TYPE_VIDEO) {
          return ImageThumbnailView(
            fileUrl: "assets/images/ic_default_image_listing.png",
            onClick: () {
              NavigationController.navigateToDetailOffer(context, offerModel.id ?? 0);
            },
          );
        } else {
          return ImageThumbnailView(
            fileUrl: file.url,
            onClick: () {
              NavigationController.navigateToDetailOffer(context, offerModel.id ?? 0);
            },
          );
        }
      },
    ).toList();
    return Container(
      alignment: Alignment.center,
      height: 220,
      width: double.infinity,
      child: listThumbnail == null || listThumbnail.length == 0
          ? Image.asset(
              'assets/images/ic_default_image_listing.png',
              fit: BoxFit.cover,
              height: 220,
              width: double.infinity,
            )
          : SizedBox.expand(
              child: PagerDotIndicator(
                currentPageValue: currentPageImage,
                onPageChanged: (int page) {
                  currentPageImage = page;
                  setState(() {});
                },
                indicatorSpacing: 3,
                indicatorMarginBottom: 8,
                indicatorSelectedSize: 8,
                indicatorNormalSize: 5,
                indicatorSelectedColor: AppColor.orangeDark,
                indicatorNormalColor: AppColor.dividerGray,
                listWidgets: listThumbnail,
              ),
            ),
    );
  }

  Widget _renderStatusOffer(HomeOfferModel offerModel) {
    if (PropzyHomeCategoryAndStatusOffer.NOT_YET_DONE.statusId == offerModel.status?.id) {
      double percentNotYetDone = 100 - (offerModel.totalPercent ?? 0);
      return Row(
        children: [
          Container(
            height: 28,
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top: 16, left: 16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(201, 52, 0, 0.92),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LinearPercentIndicator(
                  width: 50,
                  lineHeight: 5,
                  percent: (offerModel.totalPercent ?? 0) / 100,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.white,
                  backgroundColor: HexColor("AEAEB2"),
                  barRadius: Radius.circular(3),
                ),
                Text(
                  "${percentNotYetDone.toStringAsFixed(0)}% chưa hoàn thành",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          // Spacer(),
        ],
      );
    } else if (PropzyHomeCategoryAndStatusOffer.BOUGHT.statusId == offerModel.status?.id ||
        PropzyHomeCategoryAndStatusOffer.SOLD.statusId == offerModel.status?.id) {
      return Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.only(top: 12, left: 12),
        child: Image.asset(
          'assets/images/ic_offer_sold_propzy_home.png',
          height: 50,
          width: 50,
        ),
      );
    } else if (PropzyHomeCategoryAndStatusOffer.CANCELLED.statusId == offerModel.status?.id) {
      return Container(
        padding: EdgeInsets.only(
          left: 12,
        ),
        child: Image.asset(
          'assets/images/ic_offer_cancelled_propzy_home.png',
          width: 75,
          height: 75,
        ),
      );
    } else {
      // temp hide status
      return Container();
      return Row(
        children: [
          Container(
              height: 28,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(top: 16, left: 16),
              decoration: BoxDecoration(
                color: Color.fromRGBO(60, 60, 67, 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  "${offerModel.status?.process?.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              )),
        ],
      );
    }
  }

  Widget _renderDetailInfo(HomeOfferModel offerModel) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            _renderRow1(offerModel),
            SizedBox(height: 8),
            _renderRow2(offerModel),
            SizedBox(height: 8),
            _renderRow3(offerModel),
          ],
        ),
      ),
    );
  }

  Widget _renderRow1(HomeOfferModel offerModel) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${offerModel.address}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColor.blackDefault,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(width: 10),
        InkWell(
          onTap: () {
            NavigationController.navigateToDetailOffer(context, offerModel.id ?? 0);
          },
          child: Container(
            child: Text(
              "Chi tiết",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.systemBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderRow2(HomeOfferModel offerModel) {
    if ((offerModel.offeredPrice ?? 0) > 0) {
      return Container(
        width: double.infinity,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Giá đề nghị chính thức: ",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.blackDefault,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: "${offerModel.offeredPriceFormat}",
                style: TextStyle(
                  fontSize: 16,
                  color: HexColor("ef7733"),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Giá đề nghị sơ bộ: ",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.blackDefault,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: ((offerModel.suggestedPrice ?? 0.0) > 0.0) &&
                        offerModel.suggestedPriceFormat != null
                    ? "${offerModel.suggestedPriceFormat}"
                    : "chưa thể định giá",
                style: TextStyle(
                  fontSize: 16,
                  color: ((offerModel.suggestedPrice ?? 0.0) > 0.0) &&
                          offerModel.suggestedPriceFormat != null
                      ? HexColor("ef7733")
                      : HexColor("898989"),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _renderRow3(HomeOfferModel offerModel) {
    String area = "";
    if (PROPERTY_TYPES.CHUNG_CU.type == offerModel.propertyType?.id) {
      if (offerModel.builtUpArea == null) {
        area = "--";
      } else {
        String? s = offerModel.builtUpArea?.toStringAsFixed(2);
        if (s?.contains(".00") == true) {
          area = "${offerModel.builtUpArea?.toStringAsFixed(0)}m²";
        } else {
          area = "${s}m²";
        }
      }
    } else {
      if (offerModel.floorSize == null) {
        area = "--";
      } else {
        String? s = offerModel.floorSize?.toStringAsFixed(2);
        if (s?.contains(".00") == true) {
          area = "${offerModel.floorSize?.toStringAsFixed(0)}m²";
        } else {
          area = "${s}m²";
        }
      }
    }

    return Row(
      children: [
        _renderItemInfo(
          "assets/images/ic_bathroom_propzy_home.svg",
          offerModel.bathroom == null ? "--" : "${offerModel.bathroom} phòng tắm",
        ),
        SizedBox(width: 10),
        _renderItemInfo(
          "assets/images/ic_bedroom_propzy_home.svg",
          offerModel.bedroom == null ? "--" : "${offerModel.bedroom} phòng ngủ",
        ),
        SizedBox(width: 10),
        _renderItemInfo(
          "assets/images/ic_area_propzy_home.svg",
          area,
        ),
      ],
    );
  }

  Widget _renderItemInfo(String imagePath, String value) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            imagePath,
            width: 20,
            height: 20,
          ),
          SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColor.blackDefault,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }
}
