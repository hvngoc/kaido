import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/domain/request/listing_title_description_request.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/bold_section_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/create_listing_progress_bar_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/field_text_input_no_title.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/components/title_description_info_view.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_event.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/create_listing_state.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/title_description/bloc/title_description_bloc.dart';
import 'package:propzy_home/src/presentation/ui/create_listing/title_description/widget/text_editor_widget.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/presentation/view/propzy_app_bar.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';
import 'package:propzy_home/src/util/util.dart';

class TitleDescriptionWidget extends StatefulWidget {
  const TitleDescriptionWidget({
    Key? key,
    required this.listingId,
  }) : super(key: key);

  final int listingId;

  @override
  State<TitleDescriptionWidget> createState() => _TitleDescriptionWidgetState();
}

class _TitleDescriptionWidgetState extends State<TitleDescriptionWidget>
    implements TextEditorListener {
  final TitleDescriptionBloc _bloc = TitleDescriptionBloc();
  final CreateListingBloc _createListingBloc = GetIt.instance.get<CreateListingBloc>();
  final String currentStep = "TITLE_AND_DESCRIPTION_STEP";

  TextEditingController _titleController = TextEditingController();

  String _title = '';
  String contentHtml = '';

  @override
  void initState() {
    super.initState();
    _createListingBloc.add(GetDraftListingDetailEvent(widget.listingId));
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  void onSave(String content) {
    setState(() {
      contentHtml = content;
    });
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
                _title = _createListingBloc.draftListing?.title ?? '';
                contentHtml = _createListingBloc.draftListing?.description ?? '';
                _titleController.text = _title;
                setState(() {});
              }
            },
          ),
          BlocListener<TitleDescriptionBloc, TitleDescriptionState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is UpdateTitleDescriptionStepSuccess) {
                NavigationController.navigateToChooseMediaCreateListing(context, widget.listingId);
              } else if (state is UpdateTitleDescriptionStepFail) {}
            },
          ),
        ],
        child: Scaffold(
          appBar: PropzyAppBar(
            title: 'Đăng tin bất động sản',
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      CreateListingProgressBarView(
                        currentStep: 2,
                        currentScreenInStep:
                            _createListingBloc.isPrivateHouseOrVillaDraft() ? 8 : 7,
                        totalScreensInStep: _createListingBloc.isPrivateHouseOrVillaDraft() ? 8 : 7,
                      ),
                      TitleDescriptionInfoView(
                        title: 'Thông tin bài đăng',
                        description:
                            'Thông tin bài đăng đầy đủ, ngắn gọn và rõ ràng giúp thu hút nhiều khách hàng hơn',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BoldSectionTitle(text: 'Tiêu đề'),
                            Text(
                              '${_title.length}/70',
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: FieldTextInputNoTitle(
                          textEditingController: _titleController,
                          unit: '',
                          hint: '',
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(70),
                          ],
                          onChanged: (e) {
                            setState(() {
                              _title = e;
                            });
                          },
                        ),
                      ),
                      _renderTitleNote(),
                      BoldSectionTitle(text: 'Mô tả'),
                      _buildDescription(),
                      _renderDescriptionNote(),
                    ],
                  ),
                ),
                _renderBottomButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: GestureDetector(
        onTap: () {
          var textEditorWidget = TextEditorWidget(
            title: "Html editor",
            content: contentHtml,
            listener: this,
          );
          Navigator.push(context, MaterialPageRoute(builder: (context) => textEditorWidget));
        },
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColor.grayC6),
          ),
          child: ListView(
            children: [
              Visibility(
                visible: checkEmptyHtmlString(contentHtml),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Nhập mô tả chung về bất động sản của bạn',
                    style: TextStyle(
                      color: HexColor('4A4A4A'),
                    ),
                  ),
                ),
              ),
              Html(
                data: contentHtml,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderBottomButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: OrangeButton(
        title: 'Tiếp tục',
        isEnabled: _title.isNotEmpty && !checkEmptyHtmlString(contentHtml),
        onPressed: () {
          final request = ListingTitleDescriptionRequest(
            id: widget.listingId,
            currentStep: currentStep,
            title: _title,
            description: contentHtml,
          );
          _bloc.add(UpdateTitleDescriptionStepEvent(request));
        },
      ),
    );
  }

  Widget _renderTitleNote() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      child: Text(
        'Ví dụ: NHÀ MỚI XÂY, Đ. PHAN HUY ÍCH, HẺM XE HƠI, 2 MẶT TIỀN , 1 TRỆT, 2 LẦU',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: AppColor.secondaryText,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _renderDescriptionNote() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      child: Text.rich(
        TextSpan(
          text:
              'Ví dụ: \n• Sổ hồng chính chủ, hoàn công đầy đủ \n• Mặt tiền rộng 6m, đường nội khu rộng 12m \n• Có giềng trời, sân vườn,...  ',
          children: [
            TextSpan(
              text: 'Xem thêm',
              style: TextStyle(
                color: HexColor("0072EF"),
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Util.showCustomBottomSheet(context, _contentPopup);
                },
            ),
          ],
        ),
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: AppColor.secondaryText,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _contentPopup(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(
            'Bí quyết để có tin đăng hấp dẫn',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text.rich(
            TextSpan(
              text: '''
- Nội dung cần đầy đủ, chính xác và rõ ràng
- Nhấn mạnh được những điểm khác biệt giữa BĐS của bạn so với các BĐS khác về vị trí, pháp lý, phong thủy, tiện ích xung quanh, kết cấu nhà, khu dân cư
- Đừng quên nhắc đến những chi tiết xu hướng, tiềm năng tương lai mà thị trường đang quan tâm
''',
              children: [
                TextSpan(
                  text: '\nTham khảo:\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '''
• Sổ hồng chính chủ, hoàn công đầy đủ
• Có giềng trời, mặt tiền rộng 6m, đường nội khu rộng 12m
• Diện tích đất vuông vắn
• Tiện ích đầy đủ : bệnh viện Gia Lâm, trường học các cấp, chợ Cửu Việt trong bán kính 1km
• Chỉ 5 phút di chuyển đến tuyến Metro
• Khu dân cư văn minh, dân trí cao
• Thuận tiện cho việc định cư lâu dài, xây trọ sinh viên, doanh thu 2tr5-4tr/phòng/tháng
• Nhà mới xây, full nội thất
                '''),
              ],
            ),
            style: TextStyle(
              fontSize: 16,
              color: HexColor('#6A6D74'),
            ),
          ),
          OrangeButton(
            title: 'Đã hiểu',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  bool checkEmptyHtmlString(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '').isEmpty;
  }
}
