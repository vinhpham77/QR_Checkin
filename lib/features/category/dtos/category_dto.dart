import 'package:qr_checkin/utils/data_utils.dart';

class CategoryDto {
  int id;
  String name;
  String? description;
  DateTime createdAt;
  String createdBy;
  DateTime updatedAt;
  String updatedBy;
  DateTime? deletedAt;
  String? deletedBy;

  CategoryDto({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.deletedAt,
    this.deletedBy,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      createdBy: json['createdBy'],
      updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      updatedBy: json['updatedBy'],
      deletedAt: tryParseDateTime(json['deletedAt']),
      deletedBy: json['deletedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'createdBy': createdBy,
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'updatedBy': updatedBy,
      'deletedAt': deletedAt?.toUtc().toIso8601String(),
      'deletedBy': deletedBy,
    };
  }
}