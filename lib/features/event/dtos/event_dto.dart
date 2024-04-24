import '../../category/dtos/category_dto.dart';

class EventDto {
  int id;
  String name;
  String? backgroundUrl;
  String? description;
  int? slots;
  DateTime startAt;
  DateTime endAt;
  String location;
  double latitude;
  double longitude;
  double radius;
  bool isRequired;
  bool isApproved;
  List<CategoryDto> categories;
  String checkinQrCode;
  String? checkoutQrCode;
  DateTime createdAt;
  String createdBy;
  DateTime updatedAt;
  String updatedBy;
  DateTime? deletedAt;
  String? deletedBy;

  EventDto({
    required this.id,
    this.backgroundUrl,
    required this.name,
    this.description,
    this.slots,
    required this.startAt,
    required this.endAt,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.radius = 20,
    this.isRequired = false,
    this.isApproved = false,
    required this.checkinQrCode,
    this.checkoutQrCode,
    this.categories = const [],
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.deletedAt,
    this.deletedBy,
  });

  factory EventDto.fromJson(Map<String, dynamic> json) {
    return EventDto(
      id: json['id'],
      name: json['name'],
      backgroundUrl: json['backgroundUrl'],
      description: json['description'],
      slots: json['slots'],
      startAt: DateTime.parse(json['startAt']),
      endAt: DateTime.parse(json['endAt']),
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
      isRequired: json['isRequired'],
      isApproved: json['isApproved'],
      categories: (json['categories'] as List).map((e) => CategoryDto.fromJson(e)).toList(),
      checkinQrCode: json['checkinQrCode'],
      checkoutQrCode: json['checkoutQrCode'],
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'],
      updatedAt: DateTime.parse(json['updatedAt']),
      updatedBy: json['updatedBy'],
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      deletedBy: json['deletedBy'],
    );
  }

  factory EventDto.empty() {
    return EventDto(
      id: 0,
      name: '',
      backgroundUrl: null,
      description: '',
      location: '',
      startAt: DateTime.now(),
      endAt: DateTime.now(),
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
      'startAt': startAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'location': location,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'radius': radius,
      'isRequired': isRequired,
      'isApproved': isApproved,
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
    bool? isRequired,
    bool? isApproved,
    List<CategoryDto>? categories,
    String? checkinQrCode,
    String? checkoutQrCode,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    DateTime? deletedAt,
    String? deletedBy,
  }) {
    return EventDto(
      id: id ?? this.id,
      name: name ?? this.name,
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      description: description ?? this.description,
      slots: slots ?? this.slots,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      isRequired: isRequired ?? this.isRequired,
      isApproved: isApproved ?? this.isApproved,
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