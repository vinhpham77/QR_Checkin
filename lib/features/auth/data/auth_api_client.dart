import 'package:dio/dio.dart';
import 'package:qr_checkin/config/http_client.dart';

import '../dtos/login_dto.dart';
import '../dtos/login_success_dto.dart';
import '../dtos/register_dto.dart';

class AuthApiClient {
  final Dio dio;

  AuthApiClient(this.dio);

  Future<LoginSuccessDto> login(LoginDto loginDto) async {
    try {
      await setDeviceInfo(dio);

      final response = await dio.post(
        '/auth/login',
        data: loginDto.toJson(),
      );

      return LoginSuccessDto.fromJson(response.data);
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
      setDeviceInfo(dio);

      await dio.post(
        '/auth/register',
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
      setDeviceInfo(dio);

      await dio.post(
        '/auth/logout?apply=all',
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
}
