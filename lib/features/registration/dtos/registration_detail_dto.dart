import '../../../utils/data_utils.dart';

class RegistrationDetailDto {
  int id;
  DateTime? createdAt;
  DateTime? checkInAt;
  DateTime? checkOutAt;
  int eventId;
  String eventName;
  String eventLocation;
  DateTime? acceptedAt;
  String eventCreator;
  bool checkOutRequired;

  RegistrationDetailDto({
    required this.id,
    required this.eventCreator,
    required this.createdAt,
    required this.checkInAt,
    required this.eventId,
    required this.acceptedAt,
    required this.eventName,
    required this.eventLocation,
    required this.checkOutRequired,
  });

  factory RegistrationDetailDto.fromJson(Map<String, dynamic> json) {
    return RegistrationDetailDto(
      id: json['id'],
      eventCreator: json['eventCreator'],
      createdAt: tryParseDateTime(json['createdAt']),
      checkInAt: tryParseDateTime(json['checkInAt']),
      eventId: json['eventId'],
      eventName: json['eventName'],
      eventLocation: json['eventLocation'],
      acceptedAt: tryParseDateTime(json['acceptedAt']),
      checkOutRequired: json['checkOutRequired'],
    );
  }
}