part of 'auth_bloc.dart';

class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthLoginStarted extends AuthEvent {
  final String username;
  final String password;

  AuthLoginStarted({
    required this.username,
    required this.password,
  });
}

class AuthLoginPrefilled extends AuthEvent {
  final String username;
  final String password;

  AuthLoginPrefilled({
    required this.username,
    required this.password,
  });
}

class AuthRegisterInitiated extends AuthEvent {}

class AuthRegisterStarted extends AuthEvent {
  final String username;
  final String password;
  final String email;

  AuthRegisterStarted({
    required this.username,
    required this.password,
    required this.email,
  });
}

class AuthAuthenticateStarted extends AuthEvent {}

class AuthLogoutStarted extends AuthEvent {}
