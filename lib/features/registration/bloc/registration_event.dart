part of 'registration_bloc.dart';

@immutable
sealed class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

final class RegistrationEventInitial extends RegistrationEvent {
}

final class RegistrationTypeFetch extends RegistrationEvent {
  final int eventId;

  const RegistrationTypeFetch(this.eventId);

  @override
  List<Object> get props => [eventId];
}

final class RegistrationCheckIn extends RegistrationEvent {
  final String code;
  final int eventId;

  const RegistrationCheckIn({required this.code, required this.eventId});

  @override
  List<Object> get props => [code, eventId];
}

final class RegistrationDetailFetch extends RegistrationEvent {
  final int page;
  final int size;

  const RegistrationDetailFetch({this.page = 1, this.size = 10});

  @override
  List<Object> get props => [page, size];
}

final class AttendanceFetch extends RegistrationEvent {
  final int eventId;
  final int page;
  final int size;

  const AttendanceFetch({
    required this.eventId,
    this.page = 1,
    this.size = 10,
  });

  @override
  List<Object> get props => [eventId, page, size];
}

final class AcceptedRegistrationFetch extends RegistrationEvent {
  final int eventId;
  final int page;
  final int size;

  const AcceptedRegistrationFetch({
    required this.eventId,
    this.page = 1,
    this.size = 10,
  });

  @override
  List<Object> get props => [eventId, page, size];
}

final class PendingRegistrationFetch extends RegistrationEvent {
  final int eventId;
  final int page;
  final int size;

  const PendingRegistrationFetch({
    required this.eventId,
    this.page = 1,
    this.size = 10,
  });

  @override
  List<Object> get props => [eventId, page, size];
}

final class AcceptRegistration extends RegistrationEvent {
  final int registrationId;

  const AcceptRegistration(this.registrationId);

  @override
  List<Object> get props => [registrationId];
}

final class RejectRegistration extends RegistrationEvent {
  final int registrationId;

  const RejectRegistration(this.registrationId);

  @override
  List<Object> get props => [registrationId];
}