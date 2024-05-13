import '../../../utils/data_utils.dart';

class TicketDetailDto {
  int id;
  String ticketTypeName;
  String qrCode;
  String username;
  DateTime? createdAt;
  DateTime? checkInAt;
  double price;
  int eventId;
  String eventName;
  String location;

  TicketDetailDto({
    required this.id,
    required this.ticketTypeName,
    required this.qrCode,
    required this.username,
    required this.createdAt,
    required this.checkInAt,
    required this.price,
    required this.eventId,
    required this.eventName,
    required this.location,
  });

  factory TicketDetailDto.fromJson(Map<String, dynamic> json) {
    return TicketDetailDto(
      id: json['id'],
      ticketTypeName: json['ticketTypeName'],
      qrCode: json['qrCode'],
      username: json['username'],
      createdAt: tryParseDateTime(json['createdAt']),
      checkInAt: tryParseDateTime(json['checkInAt']),
      price: json['price'],
      eventId: json['eventId'],
      eventName: json['eventName'],
      location: json['location'],
    );
  }
}