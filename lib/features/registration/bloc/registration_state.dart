part of 'registration_bloc.dart';

@immutable
sealed class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

final class RegistrationInitial extends RegistrationState {
}

final class RegistrationCheckInSuccess extends RegistrationState {
}

final class RegistrationCheckInFailure extends RegistrationState {
  final String message;

  const RegistrationCheckInFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class RegistrationDetailFetching extends RegistrationState {
}

final class RegistrationDetailFetchSuccess extends RegistrationState {
  final ItemCounterDto<RegistrationDetailDto> registrationDetails;

  const RegistrationDetailFetchSuccess({required this.registrationDetails});

  @override
  List<Object> get props => [registrationDetails];
}

final class RegistrationDetailFetchFailure extends RegistrationState {
  final String message;

  const RegistrationDetailFetchFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class AttendanceFetching extends RegistrationState {
}

final class AttendanceFetchSuccess extends RegistrationState {
  final ItemCounterDto<AttendanceUserDto> attendanceUsers;

  const AttendanceFetchSuccess({required this.attendanceUsers});

  @override
  List<Object> get props => [attendanceUsers];
}

final class AttendanceFetchFailure extends RegistrationState {
  final String message;

  const AttendanceFetchFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class AcceptedRegistrationFetching extends RegistrationState {
}

final class AcceptedRegistrationFetchSuccess extends RegistrationState {
  final ItemCounterDto<RegistrationUserDto> registrationUsers;

  const AcceptedRegistrationFetchSuccess({required this.registrationUsers});

  @override
  List<Object> get props => [registrationUsers];
}

final class AcceptedRegistrationFetchFailure extends RegistrationState {
  final String message;

  const AcceptedRegistrationFetchFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class PendingRegistrationFetching extends RegistrationState {
}

final class PendingRegistrationFetchSuccess extends RegistrationState {
  final ItemCounterDto<RegistrationUserDto> registrationUsers;

  const PendingRegistrationFetchSuccess({required this.registrationUsers});

  @override
  List<Object> get props => [registrationUsers];
}

final class PendingRegistrationFetchFailure extends RegistrationState {
  final String message;

  const PendingRegistrationFetchFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class AcceptedRegistrationSuccess extends RegistrationState {
  final int registrationId;

  const AcceptedRegistrationSuccess({required this.registrationId});

  @override
  List<Object> get props => [registrationId];
}

final class AcceptedRegistrationFailure extends RegistrationState {
  final String message;

  const AcceptedRegistrationFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class RejectRegistrationSuccess extends RegistrationState {
  final int registrationId;

  const RejectRegistrationSuccess({required this.registrationId});

  @override
  List<Object> get props => [registrationId];
}

final class RejectRegistrationFailure extends RegistrationState {
  final String message;

  const RejectRegistrationFailure(this.message);

  @override
  List<Object> get props => [message];
}