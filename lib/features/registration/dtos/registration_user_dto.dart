import '../../../utils/data_utils.dart';

class RegistrationUserDto {
  int registrationId;
  String username;
  String? avatar;
  String? fullName;
  bool? sex;
  String email;
  DateTime? createdAt;
  DateTime? acceptedAt;

  RegistrationUserDto({
    required this.registrationId,
    required this.username,
    required this.avatar,
    required this.fullName,
    required this.sex,
    required this.email,
    required this.createdAt,
    required this.acceptedAt,
  });

  factory RegistrationUserDto.fromJson(Map<String, dynamic> json) {
    return RegistrationUserDto(
      registrationId: json['registrationId'],
      username: json['username'],
      avatar: json['avatar'],
      fullName: json['fullName'],
      sex: json['sex'],
      email: json['email'],
      createdAt: tryParseDateTime(json['createdAt']),
      acceptedAt: tryParseDateTime(json['acceptedAt']),
    );
  }
}