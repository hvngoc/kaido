import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable(createToJson: true, checked: true)
class UserInfo {
  String? accessToken;
  int? agentId;
  int? socialUid;
  bool? contractSigned;
  int? userTypeId;
  String? userTypeName;
  int? employmentType; //Hình thức -> 1: công ty; 2: tự do
  String? birthDay;
  String? name;
  String? email;
  String? idNo;
  String? address;
  int? issuedDate;
  String? issuedPlace;
  String? ablotMe;
  String? experience;
  List<District>? districts;
  String? phone;
  String? gender;
  Course? course;
  ProfileStatus? profileStatus;
  Company? company;
  bool? notYetActivePhone;
  ReqCooperation? reqCooperation;
  List<AgentBankInfos>? agentBankInfos;
  bool? wantToBeAgent;
  bool? isFirstLogin;
  String? statusMessage;
  String? photo;

  UserInfo({
    this.accessToken,
    this.agentId,
    this.socialUid,
    this.contractSigned,
    this.userTypeId,
    this.userTypeName,
    this.employmentType,
    this.birthDay,
    this.name,
    this.email,
    this.idNo,
    this.address,
    this.issuedDate,
    this.issuedPlace,
    this.ablotMe,
    this.experience,
    this.districts,
    this.phone,
    this.gender,
    this.course,
    this.profileStatus,
    this.company,
    this.notYetActivePhone,
    this.reqCooperation,
    this.agentBankInfos,
    this.wantToBeAgent,
    this.isFirstLogin,
    this.statusMessage,
    this.photo,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@JsonSerializable(createToJson: true, checked: true)
class District {
  int? districtId;
  int? countryId;
  int? regionId;
  int? cityId;
  int? orders;
  String? districtName;
  String? districtShortName;
  String? districtNameEn;
  String? districtNameEnLower;
  String? districtNameLower;
  String? districtShortNameLower;
  bool? isSelected;
  String? districtSlug;

  District(
      this.districtId,
      this.countryId,
      this.regionId,
      this.cityId,
      this.orders,
      this.districtName,
      this.districtShortName,
      this.districtNameEn,
      this.districtNameEnLower,
      this.districtNameLower,
      this.districtShortNameLower,
      this.isSelected,
      this.districtSlug);

  factory District.fromJson(Map<String, dynamic> json) => _$DistrictFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictToJson(this);
}

@JsonSerializable(createToJson: true, checked: true)
class Course {
  bool? isChecked;
  int? courseId;
  int? tcId;
  int? districtId;
  int? reasonId;
  int? numberOfAttend;
  int? totalTime;
  int? courseName;
  String? formatNumberOfEnrollment;
  String? formatNumberOfAttend;
  String? address;
  String? districtName;
  int? startedDate;
  int? statusId;
  int? trainingStatusId;
  double? latitude;
  double? longitude;

  Course(
      {this.isChecked,
      this.courseId,
      this.tcId,
      this.districtId,
      this.reasonId,
      this.numberOfAttend,
      this.totalTime,
      this.courseName,
      this.formatNumberOfEnrollment,
      this.formatNumberOfAttend,
      this.address,
      this.districtName,
      this.startedDate,
      this.statusId,
      this.trainingStatusId,
      this.latitude,
      this.longitude});

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}

@JsonSerializable(createToJson: true, checked: true)
class ProfileStatus {
  int? profileStatus;
  String? profileStatusName;

  ProfileStatus({this.profileStatus, this.profileStatusName});

  factory ProfileStatus.fromJson(Map<String, dynamic> json) => _$ProfileStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileStatusToJson(this);
}

@JsonSerializable(createToJson: true, checked: true)
class Company {
  String? name;
  String? address;
  String? phone;
  String? email;

  Company({this.name, this.address, this.phone, this.email});

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}

@JsonSerializable(createToJson: true, checked: true)
class ReqCooperation {
  int? requestType;
  int? statusId;

  ReqCooperation({this.requestType, this.statusId});

  factory ReqCooperation.fromJson(Map<String, dynamic> json) => _$ReqCooperationFromJson(json);

  Map<String, dynamic> toJson() => _$ReqCooperationToJson(this);
}

@JsonSerializable(createToJson: true, checked: true)
class AgentBankInfos {
  int? bankId;
  int? branchId;
  String? accountNumber;

  AgentBankInfos({this.bankId, this.branchId, this.accountNumber});

  factory AgentBankInfos.fromJson(Map<String, dynamic> json) => _$AgentBankInfosFromJson(json);

  Map<String, dynamic> toJson() => _$AgentBankInfosToJson(this);
}
