import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this.sf);

  final SharedPreferences sf;

  Future<void> saveToken(String key, String token) async {
    await sf.setString(key, token);
  }

  Future<String?> getToken(String key) async {
    return sf.getString(key);
  }

  Future<void> deleteToken(String key) async {
    await sf.remove(key);
  }
}
