import 'package:bloc/bloc.dart';

import '../../result_type.dart';
import '../data/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginStarted>(_onLoginStarted);
    on<AuthRegisterInitiated>(_onRegisterInitiated);
    on<AuthRegisterStarted>(_onRegisterStarted);
    on<AuthLoginPrefilled>(_onLoginPrefilled);
    on<AuthAuthenticateStarted>(_onAuthenticateStarted);
    on<AuthLogoutStarted>(_onAuthLogoutStarted);
  }

  final AuthRepository authRepository;

  void _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthAuthenticateUnauthenticated());
  }

  void _onLoginStarted(AuthLoginStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoginInProgress());
    final result = await authRepository.login(
        username: event.username, password: event.password);
    return (switch (result) {
      Success() => emit(AuthLoginSuccess()),
      Failure() => emit(AuthLoginFailure(result.message)),
    });
  }

  void _onLoginPrefilled(
      AuthLoginPrefilled event, Emitter<AuthState> emit) async {
    emit(AuthLoginInitial(username: event.username, password: event.password));
  }

  void _onRegisterInitiated(
      AuthRegisterInitiated event, Emitter<AuthState> emit) async {
    emit(AuthRegisterInitial());
  }

  void _onRegisterStarted(
      AuthRegisterStarted event, Emitter<AuthState> emit) async {
    emit(AuthRegisterInProgress());
    final result = await authRepository.register(
        username: event.username, password: event.password, email: event.email);
    return (switch (result) {
      Success() => emit(AuthRegisterSuccess()),
      Failure() => emit(AuthRegisterFailure(result.message)),
    });
  }

  void _onAuthenticateStarted(
      AuthAuthenticateStarted event, Emitter<AuthState> emit) async {
    final result = await authRepository.getToken();

    if (result is Success) {

    } else {
      emit(AuthAuthenticateUnauthenticated());
    }
    return (switch (result) {
      Success(data: final token) when token != null =>
        emit(AuthAuthenticateSuccess(token)),
      Success() => emit(AuthAuthenticateUnauthenticated()),
      Failure() => emit(AuthAuthenticateFailure(result.message)),
    });
  }

  void _onAuthLogoutStarted(
      AuthLogoutStarted event, Emitter<AuthState> emit) async {
    final result = await authRepository.logout();
    return (switch (result) {
      Success() => emit(AuthLogoutSuccess()),
      Failure() => emit(AuthLogoutFailure(result.message)),
    });
  }
}
