class JWTs {
  String accessToken;
  String refreshToken;

  JWTs({
    required this.accessToken,
    required this.refreshToken,
  });

  factory JWTs.fromJson(Map<String, dynamic> json) {
    return JWTs(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
