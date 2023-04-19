import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propzy_home/src/domain/model/listing_status_quos.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/bold_section_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/field_text_drop_no_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/header_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/legal_documents/bloc/legal_docs_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/legal_documents/bloc/legal_docs_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/legal_documents/bloc/legal_docs_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/continue_button.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_choice.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/field_text_price.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/presentation/view/sort_item_view.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/debounce_timer.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

class LegalDocsWidget extends StatefulWidget {
  final int listingId;

  const LegalDocsWidget({Key? key, required this.listingId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LegalState();
}

class _LegalState extends State<LegalDocsWidget> {
  final int ID_RENT = 163;

  final LegalDocsBloc _bloc = LegalDocsBloc();
  final CreateListingBloc _createListingBloc = CreateListingBloc();

  int? certificateLandId = null;

  StatusQuos? statusQuos;
  int? priceForStatusQuo;
  int? priceInit = null;

  final TimerDebounce _timerDebounce = TimerDebounce(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _bloc.add(LoadQuoEvent());
    _createListingBloc.add(GetDraftListingDetailEvent(widget.listingId));
  }

  @override
  void dispose() {
    _timerDebounce.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _bloc),
        BlocProvider(create: (_) => _createListingBloc),
      ],
      child: MultiBlocListener(
          listeners: [
            BlocListener<CreateListingBloc, BaseCreateListingState>(
              bloc: _createListingBloc,
              listener: (context, state) {
                if (state is GetDraftListingDetailSuccessState) {
                  priceForStatusQuo = _createListingBloc
                      .draftListing?.priceForStatusQuo
                      ?.toInt();
                  certificateLandId =
                      _createListingBloc.draftListing?.useRightType?.id;
                  final quo = _createListingBloc.draftListing?.statusQuo;
                  if (quo != null) {
                    statusQuos = StatusQuos(
                        id: quo.id, content: quo.name, name: quo.name);
                  }
                  setState(() {});
                  _timerDebounce.run(() {
                    priceInit = priceForStatusQuo;
                    setState(() {});
                  });
                }
              },
            ),
            BlocListener<LegalDocsBloc, BaseLegalDocsState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is LegalDocsStateSuccess) {
                  if (state.navigateScreen) {
                    NavigationController.navigateToExpectedPriceCreateListing(
                      context,
                      listingId: widget.listingId,
                    );
                  }
                }
              },
            )
          ],
          child: Scaffold(
            appBar: PropzyAppBar(
              title: 'Đăng tin bất động sản',
            ),
            body: SafeArea(
              child: Column(
                children: [
                  CreateListingProgressBarView(
                    currentStep: 2,
                    currentScreenInStep:
                        _createListingBloc.isPrivateHouseOrVillaDraft() ? 5 : 4,
                    totalScreensInStep:
                        _createListingBloc.isPrivateHouseOrVillaDraft() ? 8 : 7,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Pháp lý bất động sản của bạn',
                      style: TextStyle(
                        color: AppColor.secondaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Thông tin này giúp Propzy đưa ra tư vấn pháp lý hữu ích để bán nhà nhanh chóng và hiệu quả',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColor.secondaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: [
                        BoldSectionTitle(
                          text: 'Giấy tờ pháp lý',
                          displayStar: false,
                        ),
                        SizedBox(height: 10),
                        BlocBuilder<LegalDocsBloc, BaseLegalDocsState>(
                            builder: (context, state) {
                          if (state is LegalDocsStateSuccess) {
                            return ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 10),
                              physics: ClampingScrollPhysics(),
                              itemBuilder: _renderItemChild,
                              itemCount: _bloc.listData?.length ?? 0,
                              separatorBuilder: (c, i) {
                                return SizedBox(height: 10);
                              },
                            );
                          }
                          return Center(
                            child: LoadingView(
                              width: 160,
                              height: 80,
                            ),
                          );
                        }),
                        SizedBox(height: 16),
                        BoldSectionTitle(
                          text: 'Hiện trạng nhà',
                          displayStar: false,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: FieldTextDropNoTitle(
                            hint: 'Chọn hiện trạng nhà',
                            title: statusQuos?.name,
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              showModalBottomSheet(
                                  context: context, builder: showPickerQuos);
                            },
                          ),
                        ),
                        _renderInputPrice(),
                      ],
                    ),
                  ),
                  PropzyHomeContinueButton(
                    isEnable: isValid(),
                    onClick: () {
                      _bloc.add(UpdateLegalDocsEvent(
                        id: widget.listingId,
                        priceForStatusQuo: priceForStatusQuo,
                        statusQuoId: statusQuos?.id,
                        useRightTypeId: certificateLandId,
                      ));
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _renderInputPrice() {
    if (statusQuos?.id == ID_RENT) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            FieldTextPrice(
              titleHeader: 'Giá thuê/tháng',
              hint: 'Nhập giá thuê',
              unit: 'VNĐ',
              initValue: priceInit?.toString(),
              lastValue: priceForStatusQuo?.toString(),
              allowZero: false,
              onChange: (e) {
                priceForStatusQuo = e;
                setState(() {});
              },
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _renderItemChild(context, position) {
    final item = _bloc.listData?[position];
    if (item == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: FieldTextChoice(
        isChecked: certificateLandId == item.id,
        title: item.name ?? '',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColor.blackDefault,
        ),
        onTap: () {
          certificateLandId = item.id;
          setState(() {});
        },
      ),
    );
  }

  Widget showPickerQuos(BuildContext context) {
    return _showListQuosDialog(context, 'Hiện trạng nhà', (e) {
      statusQuos = e;
      if (statusQuos?.id != ID_RENT) {
        priceForStatusQuo = null;
      }
      setState(() {});
    });
  }

  Widget _showListQuosDialog(
    BuildContext context,
    String title,
    Function(StatusQuos) callback,
  ) {
    List<Widget>? view = _bloc.listStatus
        ?.map((e) => SortItemChildView(
            text: e.name ?? '',
            isChecked: e.id == statusQuos?.id,
            onClick: () {
              callback(e);
              Navigator.pop(context);
            }))
        .toList();
    if (view == null) {
      return Container();
    }
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  color: AppColor.blackDefault,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) => view[index],
                itemCount: view.length,
                padding: EdgeInsets.only(left: 20, right: 20),
                separatorBuilder: (c, i) {
                  return Divider(
                    color: AppColor.dividerGray,
                    height: 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValid() {
    if (statusQuos == null) {
      return false;
    }
    if (statusQuos?.id == ID_RENT && priceForStatusQuo == null) {
      return false;
    }
    return certificateLandId != null;
  }
}
