class RegisterDto {
  final String username;
  final String password;
  final String email;
  final String idNo;

  RegisterDto({
    required this.username,
    required this.password,
    required this.email,
    required this.idNo,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'email': email,
        'idNo': idNo,
      };
}
