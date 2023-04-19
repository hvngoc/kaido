import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/properties_detail/home/step_4/information_step_4.dart';
import 'package:propzy_home/src/util/constants.dart';

class ApartmentStep2 extends HomeInformationStep4 {
  @override
  State<StatefulWidget> createState() => Step2State();
}

class Step2State extends Step4State {
  @override
  String titleHeader = "Thông tin chi tiết về căn hộ của bạn";
  @override
  String titleAction = "Chính xác và tiếp tục";
  @override
  String titleBathroom = "Phòng tắm";
  @override
  String titleKitchen = "Phòng bếp";
  @override
  String pageCode = PropzyHomeScreenDirect.APARTMENT_DETAIL.pageCode;
}
