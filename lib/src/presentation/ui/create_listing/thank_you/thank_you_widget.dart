import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/model/category_home_listing.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/outline_border_button.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/thank_you/bloc/thank_you_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/thank_you/bloc/thank_you_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/thank_you/bloc/thank_you_state.dart';
import 'package:propzy_home/src/presentation/ui/home/home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/home/home_event.dart';
import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';
import 'package:propzy_home/src/presentation/view/card_view_search_home.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class ThankYouWidget extends StatefulWidget {
  final int listingId;
  final bool showRecommend;

  final ChooserData? districtId;
  final int? priceFrom;
  final int? priceTo;
  final ChooserData? propertyTypeId;

  ThankYouWidget({
    Key? key,
    required this.listingId,
    required this.showRecommend,
    this.districtId = null,
    this.priceFrom = null,
    this.priceTo = null,
    this.propertyTypeId = null,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYouWidget> {
  final ThankYouBloc _bloc = ThankYouBloc();
  final HomeBloc _homeBloc = GetIt.I.get<HomeBloc>();

  @override
  void initState() {
    super.initState();
    if (widget.showRecommend) {
      _bloc.add(ThankYouEvent(
        districtId: widget.districtId,
        priceFrom: widget.priceFrom,
        priceTo: widget.priceTo,
        propertyTypeId: widget.propertyTypeId,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _bloc),
        BlocProvider(create: (_) => _homeBloc),
      ],
      child: Scaffold(
        appBar: PropzyAppBar(
          title: 'Đăng tin bất động sản',
          showBackButton: false,
          showDialogWarning: false,
        ),
        body: SafeArea(
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              SizedBox(height: 60),
              Image.asset(
                'assets/images/ic_thank_you_page.png',
                width: 260,
                height: 170,
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  'Hoàn tất tin đăng',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColor.secondaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Tin đăng của bạn đang được hệ thống duyệt tự động và sẽ được đăng tải sớm.',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: OutlinedBorderButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  },
                  title: 'Về trang chủ',
                  color: AppColor.secondaryText,
                ),
              ),
              SizedBox(height: 16),
              BlocBuilder<ThankYouBloc, ThankYouState>(builder: (context, state) {
                if (state is ThankYouSuccess) {
                  return ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    children: [
                      Text(
                        'ĐỀ XUẤT CHO BẠN',
                        style: TextStyle(
                          color: AppColor.blackDefault,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (c, position) {
                          return _renderItemChild(state.list?[position]);
                        },
                        itemCount: state.list?.length ?? 0,
                        separatorBuilder: (c, i) {
                          return SizedBox(height: 4);
                        },
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: OutlinedBorderButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop(true);
                            _homeBloc.add(GoToSearchEvent(
                              districtId: widget.districtId,
                              priceFrom: widget.priceFrom,
                              priceTo: widget.priceTo,
                              propertyTypeId: widget.propertyTypeId,
                            ));
                          },
                          title: 'Xem thêm',
                          color: AppColor.propzyBlue,
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderItemChild(CategoryHomeListing? home) {
    if (home == null) {
      return Container(
          alignment: Alignment.center,
          child: const LoadingView(
            width: 160,
            height: 80,
          ));
    }

    List<String>? listImages =
        (home.useDefaultPhoto == true) ? null : home.thumbnails?.map((e) => e.link!).toList();
    bool isPropzyHome = home.labelCode == "PROPZY_HOME";
    bool isPriceDown = home.priceTrend == "DOWN";
    String? labelName = isPropzyHome ? null : home.labelName;
    String? bedrooms = home.bedrooms == null ? "--" : home.bedrooms?.toString();
    String? bathrooms = home.bathrooms == null ? "--" : home.bathrooms?.toString();
    String? formattedSize = home.formattedSize == null ? "--" : home.formattedSize?.toString();
    String? directionName = home.directionName == null ? "--" : home.directionName?.toString();
    return CardViewSearchHome(
      listingId: home.id,
      isPropzyHome: isPropzyHome,
      isPriceDown: isPriceDown,
      labelName: labelName,
      tradedStatus: home.tradedStatus,
      formattedPriceVnd: home.formattedPriceVnd,
      formattedUnitPrice: home.formattedUnitPrice,
      title: home.title,
      address: home.getAddress(),
      isFavorite: true,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      formattedSize: formattedSize,
      directionName: directionName,
      projectName: home.projectName,
      projectId: home.projectId,
      listImages: listImages,
    );
  }
}
