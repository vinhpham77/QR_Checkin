import 'package:qr_checkin/utils/data_utils.dart';

class UserDto {
  String username;
  String email;
  String? fullName;
  String role;
  String status;
  String? avatar;
  bool? sex;
  DateTime? birthdate;
  DateTime createdAt;
  DateTime? updatedAt;

  UserDto({
    required this.username,
    required this.email,
    this.fullName,
    required this.role,
    required this.status,
    required this.avatar,
    this.birthdate,
    required this.createdAt,
    this.updatedAt,
    this.sex,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      username: json['username'],
      email: json['email'],
      fullName: json['fullName'],
      role: json['role'],
      sex: json['sex'],
      status: json['status'],
      avatar: json['avatar'],
      birthdate: tryParseDateTime(json['birthdate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: tryParseDateTime(json['updatedAt']),
    );
  }

  factory UserDto.empty() {
    return UserDto(
      username: '',
      email: '',
      fullName: '',
      role: '',
      status: '',
      avatar: '',
      birthdate: null,
      createdAt: DateTime.now(),
      updatedAt: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'fullName': fullName,
      'role': role,
      'birthDate': birthdate?.toUtc().toIso8601String(),
      'avatar': avatar,
      'sex': sex,
    };
  }
}
