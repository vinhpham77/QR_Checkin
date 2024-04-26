import 'package:dio/dio.dart';
import 'package:qr_checkin/config/http_client.dart';

import '../dtos/jwts.dart';
import '../dtos/login_dto.dart';
import '../dtos/register_dto.dart';

class AuthApiClient {
  final Dio dio;

  AuthApiClient(this.dio);

  Future<JWTs> login(LoginDto loginDto) async {
    try {
      dio.options.headers['device-id'] = await getDeviceId();
      dio.options.headers['device-name'] = await getDeviceName();

      var interceptors = [...dio.interceptors];
      dio.interceptors.clear();
      final response = await dio.post(
        '${servicePaths['auth']}/login',
        data: loginDto.toJson(),
      );
      dio.interceptors.addAll(interceptors);

      return JWTs.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> register(RegisterDto registerDto) async {
    try {
      await dio.post(
        '${servicePaths['auth']}/register',
        data: registerDto.toJson(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await dio.post(
        '${servicePaths['auth']}/logout',
        data: refreshToken,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<JWTs> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        '${servicePaths['auth']}/refresh-token',
        data: refreshToken,
      );

      return JWTs.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
