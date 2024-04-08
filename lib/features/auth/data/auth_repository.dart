import 'dart:developer';

import '../../result_type.dart';
import '../dtos/login_dto.dart';
import '../dtos/register_dto.dart';
import 'auth_api_client.dart';
import 'auth_local_data_source.dart';
import 'constants.dart';

class AuthRepository {
  final AuthApiClient authApiClient;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepository({
    required this.authApiClient,
    required this.authLocalDataSource,
  });

  Future<Result<void>> login({
    required String username,
    required String password,
  }) async {
    try {
      final loginSuccessDto = await authApiClient.login(
        LoginDto(username: username, password: password),
      );

      await Future.wait([
        authLocalDataSource.saveToken(
            AuthDataConstants.accessToken, loginSuccessDto.accessToken),
        authLocalDataSource.saveToken(
            AuthDataConstants.refreshToken, loginSuccessDto.refreshToken),
      ]);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }

    return Success(null);
  }

  Future<Result<void>> register(
      {required String username,
      required String password,
      required String email}) async {
    try {
      await authApiClient.register(
        RegisterDto(username: username, password: password, email: email),
      );
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
    return Success(null);
  }

  Future<Result<String?>> getToken() async {
    try {
      final token = await authLocalDataSource.getToken(AuthDataConstants.accessToken);

      return Success(token);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }
  // TODO: Implement logout
  Future<Result<void>> logout() async {
    try {
      final token = await authLocalDataSource.getToken(AuthDataConstants.refreshToken);

      if (token != null) {
        await authApiClient.logout(token);
      }

      await authLocalDataSource.deleteToken(AuthDataConstants.accessToken);
      await authLocalDataSource.deleteToken(AuthDataConstants.refreshToken);
      return Success(null);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }
}
