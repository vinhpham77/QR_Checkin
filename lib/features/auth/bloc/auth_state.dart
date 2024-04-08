part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoginInitial extends AuthState {
  final String username;
  final String password;

  AuthLoginInitial({required this.username, required this.password});
}

class AuthLoginInProgress extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthLoginFailure extends AuthState {
  final String message;

  AuthLoginFailure(this.message);
}

class AuthRegisterInitial extends AuthState {}

class AuthRegisterInProgress extends AuthState {}

class AuthRegisterSuccess extends AuthState {}

class AuthRegisterFailure extends AuthState {
  final String message;

  AuthRegisterFailure(this.message);
}

class AuthAuthenticateSuccess extends AuthState {
  final String token;

  AuthAuthenticateSuccess(this.token);
}

class AuthAuthenticateUnauthenticated extends AuthState {}

class AuthAuthenticateFailure extends AuthState {
  final String message;

  AuthAuthenticateFailure(this.message);
}

class AuthLogoutSuccess extends AuthState {}

class AuthLogoutFailure extends AuthState {
  final String message;

  AuthLogoutFailure(this.message);
}
