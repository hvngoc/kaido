import 'package:google_maps_flutter/google_maps_flutter.dart';

final double PROPZY_LATITUDE = 10.763959260536817;
final double PROPZY_LONGITUDE = 106.6562858064106;
final LatLng PROPZY_POSITION = LatLng(
  PROPZY_LATITUDE,
  PROPZY_LONGITUDE,
);

enum SSOActionType {
  login,
  loginSMS,
  signUp,
}

class Constants {
  static final String PROPZY_CS_EMAIL = 'cskh@propzy.com';

  static final int CATEGORY_FILTER_STATUS_SOLD_OR_RENT = 7;
  static final int CATEGORY_FILTER_STATUS_LIVE = 3;
  static final int CATEGORY_FILTER_STATUS_ALL = 0;
  static final int CATEGORY_FILTER_STATUS_SOON = 43;
  static final String CATEGORY_NAME_SOON = 'Sắp mở bán';
  static final int CATEGORY_FILTER_STATUS_COMPLETE = 44;
  static final String CATEGORY_NAME_COMPLETE = 'Đã hoàn thành';

  static final int PROPERTY_TYPE_ID_OFFICE = 4;
  static final int PROPERTY_TYPE_ID_SPACE = 7;
  static final int PROPERTY_TYPE_ID_APARTMENT = 8;
  static final int PROPERTY_TYPE_ID_VILLA = 9;
  static final int PROPERTY_TYPE_ID_HOUSE = 11;
  static final int PROPERTY_TYPE_ID_GROUND = 13;
  static final int PROPERTY_TYPE_ID_GROUND_PROJECT = 14;
  static final int PROPERTY_TYPE_ID_APARTMENT_RENTAL = 1;
  static final int PROPERTY_TYPE_ID_HOUSE_RENTAL = 2;
  static final int PROPERTY_TYPE_ID_OTHER = 99999;

  static final int FACADE_TYPE_ID_FOR_FACADE = 1;
  static final int FACADE_TYPE_ID_FOR_ALLEY = 2;

  static final String OFFER_PRICE_STATUS_PRICING_FAIL = 'PRICING_FAIL';
  static final String OFFER_PRICE_STATUS_PRICING_SUCCESS = 'PRICING_SUCCESS';
  static final String OFFER_PRICE_STATUS_INVALID = 'INVALID';
  static final String OFFER_PRICE_STATUS_INVALID_EXPECTED_PRICE = 'INVALID_EXPECTED_PRICE';

  static final int DISTANCE_100 = 100;
  static final int DISTANCE_200 = 200;
  static final int DISTANCE_500 = 500;

  static final int MEDIA_FILE_TYPE_IMAGE = 1;
  static final int MEDIA_FILE_TYPE_VIDEO = 2;

  static final int MEDIA_SOURCE_TYPE_MEDIA = 1;
  static final int MEDIA_SOURCE_TYPE_LEGAL = 2;

  static final int MAX_NUM_VIDEOS_MEDIA = 5;
  static final int MAX_NUM_IMAGES_MEDIA = 20;
  static final int MAX_NUM_IMAGES_LEGAL = 6;
  static final int MIN_NUM_IMAGES_MEDIA = 4;
  static final int DURATION_SECONDS_DISPLAY_ERROR_MEDIA = 7;

  static final String cameraPermissionMessage =
      'Cho phép “Propzy” truy cập máy ảnh của bạn để sử dụng tính năng này';
  static final String albumPermissionMessage =
      'Cho phép “Propzy” truy cập thư viện ảnh của bạn để sử dụng tính năng này';
  
  static final int CREATE_LISTING_SOURCE_ID_FOR_PROPZY_APP = 194;
  static final int CREATE_LISTING_SOURCE_ID_FOR_PORTAL = 1;

  static final List<String> LIST_DATE_OF_WEEK_STRING = [
    'Thứ hai',
    'Thứ ba',
    'Thứ tư',
    'Thứ năm',
    'Thứ sáu',
    'Thứ bảy',
    'Chủ nhật',
  ];

  static final List<Map<String, String>> list_item_info_property = [
    {
      "iconName": 'assets/images/ic_iBuyer_bed.svg',
      "title": "Phòng ngủ",
      "keyName": "bedroom",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_bath.svg',
      "title": "Phòng tắm",
      "keyName": "bathroom",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_living_room.svg',
      "title": "Phòng khách",
      "keyName": "livingRoom",
      "description": "1",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_kitchen_room.svg',
      "title": "Nhà bếp",
      "keyName": "kitchen",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_stairs_1.svg',
      "title": "Số tầng",
      "keyName": "numberFloor",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_direction.svg',
      "title": "Hướng",
      "keyName": "direction",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_length.svg',
      "title": "Chiều dài",
      "keyName": "length",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_width.svg',
      "title": "Chiều rộng",
      "keyName": "width",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_fit_square.svg',
      "title": "Diện tích đất",
      "keyName": "lotSize",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_fit_square.svg',
      "title": "Diện tích sử dụng",
      "keyName": "floorSize",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_position_1.svg',
      "title": "Vị trí",
      "keyName": "facadeRoad",
      "description": "",
      "more": "Độ rộng hẻm nhỏ nhất: 3m\n Khoảng cách đến đường chính: <=100m\n Tiếp giáp: 1 hẻm"
    },
    {
      "iconName": 'assets/images/ic_iBuyer_type_house.svg',
      "title": "Loại nhà",
      "keyName": "houseTextures",
      "description": "",
      "more": "Tầng lửng\n Tầng thượng\n Áp mái\n Tầng hầm\n Gác xếp\n Ban công"
    },
    {
      "iconName": 'assets/images/ic_iBuyer_paper.svg',
      "title": "Giấy tờ chủ quyền",
      "keyName": "certificateLand",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_calendar_small.svg',
      "title": "Năm xây dựng",
      "keyName": "yearBuilt",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_clock.svg',
      "title": "Thời gian mong muốn bán",
      "keyName": "expectedTime",
      "description": "",
      "more": ""
    }
  ];

  static final List<Map<String, String>> list_item_info_property_apartment = [
    {
      "iconName": 'assets/images/ic_iBuyer_bed.svg',
      "title": "Phòng ngủ",
      "keyName": "bedroom",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_bath.svg',
      "title": "Phòng tắm",
      "keyName": "bathroom",
      "description": "",
      "more": ""
    },
    {
      "iconName": "assets/images/ic_iBuyer_living_room.svg",
      "title": "Phòng khách",
      "keyName": "livingRoom",
      "description": "1",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_kitchen_room.svg',
      "title": "Nhà bếp",
      "keyName": "kitchen",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_stairs.svg',
      "title": "Tầng thứ",
      "keyName": "floorOrdinalNumber",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_direction.svg',
      "title": "Hướng cửa chính",
      "keyName": "mainDoorDirection",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_direction.svg',
      "title": "Hướng cửa sổ",
      "keyName": "windowDirection",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_fit_square.svg',
      "title": "Diện tích tim tường",
      "keyName": "carpetArea",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_fit_square.svg',
      "title": "Diện tích thông thủy",
      "keyName": "builtUpArea",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_paper.svg',
      "title": "Giấy tờ chủ quyền",
      "keyName": "certificateLand",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_calendar_small.svg',
      "title": "Năm xây dựng",
      "keyName": "yearBuilt",
      "description": "",
      "more": ""
    },
    {
      "iconName": 'assets/images/ic_iBuyer_clock.svg',
      "title": "Thời gian mong muốn bán",
      "keyName": "expectedTime",
      "description": "",
      "more": ""
    }
  ];
}

class PROPERTY_TYPES {
  final int type;

  PROPERTY_TYPES(this.type);

  static final PROPERTY_TYPES CHUNG_CU = PROPERTY_TYPES(8);
  static final PROPERTY_TYPES BIET_THU = PROPERTY_TYPES(9);
  static final PROPERTY_TYPES NHA_RIENG = PROPERTY_TYPES(11);
  static final PROPERTY_TYPES DAT_NEN = PROPERTY_TYPES(13);
  static final PROPERTY_TYPES DAT_NEN_DU_AN = PROPERTY_TYPES(14);
  static final PROPERTY_TYPES STUDIO = PROPERTY_TYPES(15);

  static final PROPERTY_TYPES PEN_HOUSE = PROPERTY_TYPES(16);
  static final PROPERTY_TYPES DUPLEX = PROPERTY_TYPES(17);
  static final PROPERTY_TYPES SHOP_HOUSE = PROPERTY_TYPES(18);
  static final PROPERTY_TYPES OFFICETEL = PROPERTY_TYPES(20);
  static final PROPERTY_TYPES BIET_THU_DU_AN = PROPERTY_TYPES(21);

  static final PROPERTY_TYPES NHA_LIEN_KE = PROPERTY_TYPES(22);
  static final PROPERTY_TYPES NHA_KHO = PROPERTY_TYPES(23);
  static final PROPERTY_TYPES DAT_NONG_NGHIEP = PROPERTY_TYPES(24);
  static final PROPERTY_TYPES SHOP_HOUSE_CHAN_DE = PROPERTY_TYPES(40);
  static final PROPERTY_TYPES KHAC = PROPERTY_TYPES(99999);
}

class PROPZY_HOME_POPUP_INFORMATION {
  final String code;
  final String assetFileName;

  PROPZY_HOME_POPUP_INFORMATION(
    this.code,
    this.assetFileName,
  );

  static final PROPZY_HOME_POPUP_INFORMATION PROPZY_CARE = PROPZY_HOME_POPUP_INFORMATION(
    "PROPZY_CARE",
    "propzy_care.html",
  );
  static final PROPZY_HOME_POPUP_INFORMATION PROPZY_PROTECT_OWNER = PROPZY_HOME_POPUP_INFORMATION(
    "PROPZY_PROTECT",
    "propzy_protect_owner.html",
  );
  static final PROPZY_HOME_POPUP_INFORMATION PROPERTY_TYPES_OF_HOME = PROPZY_HOME_POPUP_INFORMATION(
    "PROPERTY_TYPES_OF_HOME",
    "property_types_of_home.html",
  );
  static final PROPZY_HOME_POPUP_INFORMATION PRELIMINARY_PRICE = PROPZY_HOME_POPUP_INFORMATION(
    "PRELIMINARY_PRICE",
    "preliminary_price.html",
  );
  static final PROPZY_HOME_POPUP_INFORMATION PRELIMINARY_PURCHASE_PRICE_FROM_PROPZY =
      PROPZY_HOME_POPUP_INFORMATION(
    "PRELIMINARY_PURCHASE_PRICE_FROM_PROPZY",
    "preliminary_purchase_price_from_propzy.html",
  );
  static final PROPZY_HOME_POPUP_INFORMATION PACKAGE_VIP_AND_NORMAL = PROPZY_HOME_POPUP_INFORMATION(
    "PROPZY_PROGRAM",
    "package_vip_and_normal.html",
  );
}

class PropzyHomeScreenDirect {
  final String pageCode;
  final String title;

  PropzyHomeScreenDirect(this.pageCode, this.title);

  static final PropzyHomeScreenDirect MAP_SEARCH_LOCATION = PropzyHomeScreenDirect(
    "MAP_SEARCH_LOCATION",
    "Seach địa chỉ (chưa nhập key word)",
  );

  static final PropzyHomeScreenDirect MAP_SEARCH_LOCATION_RESULT = PropzyHomeScreenDirect(
    "MAP_SEARCH_LOCATION_RESULT",
    "Seach địa chỉ (Đã nhập key word)",
  );

  static final PropzyHomeScreenDirect MAP_LOCATION_CORRECT = PropzyHomeScreenDirect(
    "MAP_LOCATION_CORRECT",
    "Địa chỉ nhà của quý khách đã chính xác?",
  );

  static final PropzyHomeScreenDirect PROCESS_OVERVIEW = PropzyHomeScreenDirect(
    "PROCESS_OVERVIEW",
    "Tổng quan tiến trình",
  );

  static final PropzyHomeScreenDirect OWNER_TYPE = PropzyHomeScreenDirect(
    "OWNER_TYPE",
    "Bạn sở hữu hay đại diện cho căn nhà này?",
  );

  static final PropzyHomeScreenDirect CONTACT_INFO = PropzyHomeScreenDirect(
    "CONTACT_INFO",
    "Thông tin liên hệ của bạn",
  );

  static final PropzyHomeScreenDirect PHONE_OTP = PropzyHomeScreenDirect(
    "PHONE_OTP",
    "Xác thực số điện thoại",
  );

  static final PropzyHomeScreenDirect HOUSE_TEXTURE = PropzyHomeScreenDirect(
    "HOUSE_TEXTURE",
    "Kết cấu phòng trong căn nhà của quý khách",
  );

  static final PropzyHomeScreenDirect HOUSE_POSITION = PropzyHomeScreenDirect(
    "HOUSE_POSITION",
    "Vị trí căn nhà của quý khách",
  );

  static final PropzyHomeScreenDirect HOUSE_SIZE = PropzyHomeScreenDirect(
    "HOUSE_SIZE",
    "Diện tích & hướng căn nhà của bạn",
  );

  static final PropzyHomeScreenDirect NUMBER_OF_ROOMS = PropzyHomeScreenDirect(
    "NUMBER_OF_ROOMS",
    "Số lượng phòng trong căn nhà của bạn",
  );

  static final PropzyHomeScreenDirect CERTIFICATE_LAND = PropzyHomeScreenDirect(
    "CERTIFICATE_LAND",
    "Giấy tờ chủ quyền căn nhà của quý khách",
  );

  static final PropzyHomeScreenDirect YEAR_BUILT = PropzyHomeScreenDirect(
    "YEAR_BUILT",
    "Năm xây dựng căn nhà của quý khách",
  );

  static final PropzyHomeScreenDirect EXPECTED_TIME = PropzyHomeScreenDirect(
    "EXPECTED_TIME",
    "Thời gian mong muốn bán nhà",
  );

  static final PropzyHomeScreenDirect EXPECTED_PRICE = PropzyHomeScreenDirect(
    "EXPECTED_PRICE",
    "Mức giá bạn mong muốn bán",
  );

  static final PropzyHomeScreenDirect PLAN_TO_BUY = PropzyHomeScreenDirect(
    "PLAN_TO_BUY",
    "Dự định mua nhà của bạn trong 1 năm tới",
  );

  static final PropzyHomeScreenDirect PLAN_INFO = PropzyHomeScreenDirect(
    "PLAN_INFO",
    "Thông tin BĐS quý khách đang quan tâm",
  );

  static final PropzyHomeScreenDirect UPLOAD_IMG = PropzyHomeScreenDirect(
    "UPLOAD_IMG",
    "Chia sẻ hình ảnh nhà cùng Propzy",
  );

  static final PropzyHomeScreenDirect CERTIFICATE_IMG = PropzyHomeScreenDirect(
    "CERTIFICATE_IMG",
    "Ảnh giấy tờ pháp lý, chủ quyền căn nhà",
  );

  static final PropzyHomeScreenDirect WAIT_AVM = PropzyHomeScreenDirect(
    "WAIT_AVM",
    "Chạy tính toán giá sơ bộ",
  );

  static final PropzyHomeScreenDirect SUGGESTED_PRICE = PropzyHomeScreenDirect(
    "SUGGESTED_PRICE",
    "Giá đề nghị sơ bộ",
  );

  static final PropzyHomeScreenDirect APARTMENT_SIZE = PropzyHomeScreenDirect(
    "APARTMENT_SIZE",
    "Diện tích & hướng của căn hộ",
  );

  static final PropzyHomeScreenDirect APARTMENT_DETAIL = PropzyHomeScreenDirect(
    "APARTMENT_DETAIL",
    "Thông tin chi tiết về căn hộ của bạn",
  );
}

class PropzyHomeCategoryAndStatusOffer {
  final int categoryId;
  final int statusId;
  final String statusName;

  PropzyHomeCategoryAndStatusOffer(
    this.categoryId,
    this.statusId,
    this.statusName,
  );

  static final PropzyHomeCategoryAndStatusOffer NOT_YET_DONE = PropzyHomeCategoryAndStatusOffer(
    1,
    1,
    "Chưa hoàn thành",
  );
  static final PropzyHomeCategoryAndStatusOffer NOT_YET_APPRAISED =
      PropzyHomeCategoryAndStatusOffer(
    2,
    2,
    "Chưa thẩm định",
  );
  static final PropzyHomeCategoryAndStatusOffer APPRAISED = PropzyHomeCategoryAndStatusOffer(
    2,
    3,
    "Đã thẩm định",
  );
  static final PropzyHomeCategoryAndStatusOffer SENT_PRELIMINARY_PRICE =
      PropzyHomeCategoryAndStatusOffer(
    2,
    4,
    "Đã gửi giá đề nghị",
  );
  static final PropzyHomeCategoryAndStatusOffer APPROVED_PRELIMINARY_PRICE =
      PropzyHomeCategoryAndStatusOffer(
    2,
    5,
    "Đồng ý giá đề nghị",
  );
  static final PropzyHomeCategoryAndStatusOffer BOUGHT = PropzyHomeCategoryAndStatusOffer(
    2,
    6,
    "Đã mua",
  );
  static final PropzyHomeCategoryAndStatusOffer IN_FIXING = PropzyHomeCategoryAndStatusOffer(
    2,
    7,
    "Đang sửa chữa",
  );
  static final PropzyHomeCategoryAndStatusOffer READY_FOR_SALE = PropzyHomeCategoryAndStatusOffer(
    2,
    8,
    "Sẵn sàng bán",
  );
  static final PropzyHomeCategoryAndStatusOffer SOLD = PropzyHomeCategoryAndStatusOffer(
    3,
    9,
    "Đã bán",
  );
  static final PropzyHomeCategoryAndStatusOffer CANCELLED = PropzyHomeCategoryAndStatusOffer(
    4,
    10,
    "Đã hủy",
  );
}
