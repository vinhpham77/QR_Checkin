import 'package:qr_checkin/features/ticket/dtos/ticket_type_dto.dart';
import 'package:qr_checkin/utils/data_utils.dart';

import '../../category/dtos/category_dto.dart';

class EventDto {
  int id;
  String name;
  String? backgroundUrl;
  String? description;
  int? slots;
  double distance;
  List<TicketTypeDto> ticketTypes;
  DateTime startAt;
  DateTime endAt;
  String location;
  double latitude;
  double longitude;
  double radius;
  bool isTicketSeller;
  bool regisRequired;
  bool approvalRequired;
  bool captureRequired;
  List<CategoryDto> categories;
  String checkinQrCode;
  String? checkoutQrCode;
  DateTime createdAt;
  String createdBy;
  DateTime updatedAt;
  String updatedBy;
  DateTime? deletedAt;
  String? deletedBy;
  bool isRegistered;

  EventDto({
    required this.id,
    this.backgroundUrl,
    required this.name,
    this.description,
    this.slots,
    this.ticketTypes = const [],
    required this.isTicketSeller,
    required this.startAt,
    required this.endAt,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.radius = 20,
    this.distance = 0,
    this.regisRequired = false,
    this.approvalRequired = false,
    this.captureRequired = false,
    required this.checkinQrCode,
    this.checkoutQrCode,
    this.categories = const [],
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.deletedAt,
    this.deletedBy,
    this.isRegistered = false,
  });

  factory EventDto.fromJson(Map<String, dynamic> json) {
    return EventDto(
      id: json['id'],
      name: json['name'],
      backgroundUrl: json['backgroundUrl'],
      description: json['description'],
      slots: json['slots'],
      ticketTypes: json['ticketTypes'] != null
          ? (json['ticketTypes'] as List)
              .map((e) => TicketTypeDto.fromJson(e))
              .toList()
          : [],
      startAt: DateTime.parse(json['startAt']).toLocal(),
      endAt: DateTime.parse(json['endAt']).toLocal(),
      location: json['location'],
      latitude: json['latitude'],
      isTicketSeller: json['isTicketSeller'],
      longitude: json['longitude'],
      radius: json['radius'],
      regisRequired: json['regisRequired'],
      approvalRequired: json['approvalRequired'],
      captureRequired: json['captureRequired'],
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((e) => CategoryDto.fromJson(e))
              .toList()
          : [],
      checkinQrCode: json['checkinQrCode'] ?? '',
      checkoutQrCode: json['checkoutQrCode'],
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      createdBy: json['createdBy'],
      updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      updatedBy: json['updatedBy'],
      deletedAt: tryParseDateTime(json['deletedAt']),
      deletedBy: json['deletedBy'],
      isRegistered: json['isRegistered'] ?? false,
    );
  }

  factory EventDto.empty() {
    return EventDto(
      id: 0,
      name: '',
      backgroundUrl: null,
      description: '',
      location: '',
      isTicketSeller: false,
      startAt: DateTime.now(),
      endAt: DateTime.now().add(
        const Duration(hours: 2),
      ),
      latitude: 0,
      longitude: 0,
      checkinQrCode: '',
      createdAt: DateTime.now(),
      createdBy: '',
      updatedAt: DateTime.now(),
      updatedBy: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'backgroundUrl': backgroundUrl,
      'description': description,
      'slots': slots,
      'startAt': startAt.toUtc().toIso8601String(),
      'endAt': endAt.toUtc().toIso8601String(),
      'location': location,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'radius': radius,
      'ticketTypes': ticketTypes.map((e) => e.toJson()).toList(),
      'isTicketSeller': isTicketSeller,
      'regisRequired': regisRequired,
      'approvalRequired': approvalRequired,
      'captureRequired': captureRequired,
      'categories': categories.map((e) => e.toJson()).toList(),
      'checkoutQrCode': checkoutQrCode,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'updatedAt': updatedAt.toIso8601String(),
      'updatedBy': updatedBy,
      'deletedAt': deletedAt?.toIso8601String(),
      'deletedBy': deletedBy,
    };
  }

  EventDto copyWith({
    int? id,
    String? name,
    String? description,
    String? backgroundUrl,
    int? slots,
    DateTime? startAt,
    DateTime? endAt,
    String? location,
    double? latitude,
    double? longitude,
    double? radius,
    bool? isTicketSeller,
    double? distance,
    bool? regisRequired,
    bool? approvalRequired,
    bool? captureRequired,
    List<CategoryDto>? categories,
    String? checkinQrCode,
    String? checkoutQrCode,
    DateTime? createdAt,
    List<TicketTypeDto>? ticketTypes,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    DateTime? deletedAt,
    String? deletedBy,
    bool? isRegistered,
  }) {
    return EventDto(
      id: id ?? this.id,
      isRegistered: isRegistered ?? this.isRegistered,
      name: name ?? this.name,
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      description: description ?? this.description,
      slots: slots ?? this.slots,
      startAt: startAt ?? this.startAt,
      distance: distance ?? this.distance,
      endAt: endAt ?? this.endAt,
      ticketTypes: ticketTypes ?? this.ticketTypes,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      isTicketSeller: isTicketSeller ?? this.isTicketSeller,
      regisRequired: regisRequired ?? this.regisRequired,
      approvalRequired: approvalRequired ?? this.approvalRequired,
      captureRequired: captureRequired ?? this.captureRequired,
      categories: categories ?? this.categories,
      checkinQrCode: checkinQrCode ?? this.checkinQrCode,
      checkoutQrCode: checkoutQrCode ?? this.checkoutQrCode,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }
}
