import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/loading_process_request/bloc/loading_process_bloc.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

class LoadingProcessRequest extends StatefulWidget {
  const LoadingProcessRequest({
    Key? key,
    required this.offerId,
  }) : super(key: key);

  final int offerId;

  @override
  State<LoadingProcessRequest> createState() => _LoadingProcessRequestState();
}

class _LoadingProcessRequestState extends State<LoadingProcessRequest> {
  late Timer _timer;
  int _counter = 1;

  @override
  void initState() {
    super.initState();
    final _bloc = context.read<LoadingProcessBloc>();
    _bloc.add(GetOfferPriceEvent(offerId: widget.offerId));
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_counter > 4) {
        _timer.cancel();
        if (_bloc.state is GetOfferStatusSuccess) {
          handleNavigation((_bloc.state as GetOfferStatusSuccess).status);
        }
      } else {
        setState(() {
          _counter += 1;
        });
      }
    });
  }

  void handleNavigation(String status) {
    if (status == Constants.OFFER_PRICE_STATUS_PRICING_SUCCESS || status == Constants.OFFER_PRICE_STATUS_PRICING_FAIL || status == Constants.OFFER_PRICE_STATUS_INVALID_EXPECTED_PRICE) {
      NavigationController.navigateToPurchasePrice(context, widget.offerId);
    } else if (status == Constants.OFFER_PRICE_STATUS_INVALID) {
      NavigationController.navigateToInvalidRequest(context);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoadingProcessBloc, LoadingProcessState>(
      listener: (context, state) {
        if (state is GetOfferStatusSuccess) {
          if (_counter > 4) {
            handleNavigation(state.status);
          }
        }
      },
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: 24, right: 24, top: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: 192,
                    height: 192,
                    child: Lottie.asset('assets/images/ae_house.json'),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Vui lòng đợi trong giây lát để hệ thống công nghệ Propzy kiểm tra dữ liệu và tính toán kết quả...',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.propzyHomeDes,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 60),
                  Container(
                    padding: EdgeInsets.only(left: 50),
                    child: Column(
                      children: [
                        StepInfoItem(
                            title: 'Xác thực địa chỉ',
                            isSelected: _counter >= 1),
                        StepInfoItem(
                            title: 'Xác thực thông tin BĐS',
                            isSelected: _counter >= 2),
                        StepInfoItem(
                            title: 'Phân tích và định giá',
                            isSelected: _counter >= 3),
                        StepInfoItem(
                            title: 'Định giá sơ bộ đã sẵn sàng!',
                            isSelected: _counter >= 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StepInfoItem extends StatelessWidget {
  const StepInfoItem({
    Key? key,
    required this.title,
    this.isSelected = false,
  }) : super(key: key);

  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/ic_circle_checkbox.svg',
            color: isSelected ? AppColor.orangeDark : AppColor.gray400,
          ),
          SizedBox(width: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
