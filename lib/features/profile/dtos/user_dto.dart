class UserDto {
  String username;
  String email;
  String? fullName;
  String role;
  String status;
  String? avatarUrl;
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
    required this.avatarUrl,
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
      avatarUrl: json['avatarUrl'],
      birthdate:
          json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  factory UserDto.empty() {
    return UserDto(
      username: '',
      email: '',
      fullName: '',
      role: '',
      status: '',
      avatarUrl: '',
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
      'birthDate': birthdate?.toIso8601String(),
      'avatarUrl': avatarUrl,
      'sex': sex,
    };
  }
}
