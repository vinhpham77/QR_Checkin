import 'package:qr_checkin/utils/data_utils.dart';

class TicketUserDto {
  int ticketId;
  String username;
  String? fullName;
  bool? sex;
  String email;
  String? avatar;
  String ticketType;
  DateTime? createdAt;
  DateTime? checkInAt;

  TicketUserDto({
    required this.ticketId,
    required this.username,
    required this.fullName,
    required this.sex,
    required this.email,
    required this.avatar,
    required this.ticketType,
    required this.createdAt,
    required this.checkInAt,
  });

  factory TicketUserDto.fromJson(Map<String, dynamic> json) {
    return TicketUserDto(
        ticketId: json['ticketId'],
        username: json['username'],
        fullName: json['fullName'],
        sex: json['sex'],
        email: json['email'],
        avatar: json['avatar'],
        ticketType: json['ticketType'],
        createdAt: tryParseDateTime(json['createdAt']),
        checkInAt: tryParseDateTime(json['checkInAt']),
    );
  }
}