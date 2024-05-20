import '../../../utils/data_utils.dart';

class AttendanceUserDto {
  int attendanceId;
  String username;
  String? fullName;
  bool? sex;
  String email;
  String? avatar;
  bool isCheckOutRequired;
  bool isCaptureRequired;
  DateTime? checkInAt;
  DateTime? checkOutAt;
  String? checkInImg;
  String? checkOutImg;
  String? qrCheckInImg;
  String? qrCheckOutImg;

  AttendanceUserDto({
    required this.attendanceId,
    required this.username,
    required this.fullName,
    required this.sex,
    required this.email,
    required this.avatar,
    required this.isCheckOutRequired,
    required this.isCaptureRequired,
    required this.checkInAt,
    required this.checkOutAt,
    required this.checkInImg,
    required this.checkOutImg,
    required this.qrCheckInImg,
    required this.qrCheckOutImg,
  });

  factory AttendanceUserDto.fromJson(Map<String, dynamic> json) {
    return AttendanceUserDto(
      attendanceId: json['attendanceId'],
      username: json['username'],
      fullName: json['fullName'],
      sex: json['sex'],
      email: json['email'],
      avatar: json['avatar'],
      isCheckOutRequired: json['isCheckOutRequired'],
      isCaptureRequired: json['isCaptureRequired'],
      checkInAt: tryParseDateTime(json['checkInAt']),
      checkOutAt: tryParseDateTime(json['checkOutAt']),
      checkInImg: json['checkInImg'],
      checkOutImg: json['checkOutImg'],
      qrCheckInImg: json['qrCheckInImg'],
      qrCheckOutImg: json['qrCheckOutImg'],
    );
  }
}