import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../item_counter.dart';
import '../../result_type.dart';
import '../data/registration_repository.dart';
import '../dtos/attendance_user_dto.dart';
import '../dtos/registration_detail_dto.dart';
import '../dtos/registration_user_dto.dart';

part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegistrationRepository registrationRepository;

  RegistrationBloc({required this.registrationRepository})
      : super(RegistrationInitial()) {
    on<RegistrationEventInitial>((event, emit) => emit(RegistrationInitial()));
    on<RegistrationDetailFetch>(_onTicketDetailFetch);
    on<AttendanceFetch>(_onAttendanceFetch);
    on<AcceptedRegistrationFetch>(_onAcceptedRegistrationFetch);
    on<PendingRegistrationFetch>(_onPendingRegistrationFetch);
    on<AcceptRegistration>(_onAcceptRegistration);
    on<RejectRegistration>(_onRejectRegistration);
  }

  Future<void> _onTicketDetailFetch(
      RegistrationDetailFetch event, Emitter<RegistrationState> emit) async {
    emit(RegistrationDetailFetching());
    final result = await registrationRepository.getTicketDetails(
        page: event.page, size: event.size);
    return (switch (result) {
      Success() =>
        emit(RegistrationDetailFetchSuccess(registrationDetails: result.data)),
      Failure() => emit(RegistrationDetailFetchFailure(result.message)),
    });
  }

  Future<void> _onAttendanceFetch(
      AttendanceFetch event, Emitter<RegistrationState> emit) async {
    emit(AttendanceFetching());
    final result = await registrationRepository.getAttendances(
        eventId: event.eventId, page: event.page, size: event.size);
    return (switch (result) {
      Success() => emit(AttendanceFetchSuccess(attendanceUsers: result.data)),
      Failure() => emit(AttendanceFetchFailure(result.message)),
    });
  }

  Future<void> _onAcceptedRegistrationFetch(
      AcceptedRegistrationFetch event, Emitter<RegistrationState> emit) async {
    emit(AcceptedRegistrationFetching());
    final result = await registrationRepository.getAcceptedRegistrations(
        eventId: event.eventId, page: event.page, size: event.size);
    return (switch (result) {
      Success() => emit(AcceptedRegistrationFetchSuccess(registrationUsers: result.data)),
      Failure() => emit(AcceptedRegistrationFetchFailure(result.message)),
    });
  }

  Future<void> _onPendingRegistrationFetch(
      PendingRegistrationFetch event, Emitter<RegistrationState> emit) async {
    emit(PendingRegistrationFetching());
    final result = await registrationRepository.getPendingRegistrations(
        eventId: event.eventId, page: event.page, size: event.size);
    return (switch (result) {
      Success() => emit(PendingRegistrationFetchSuccess(registrationUsers: result.data)),
      Failure() => emit(PendingRegistrationFetchFailure(result.message)),
    });
  }

  Future<void> _onAcceptRegistration(
      AcceptRegistration event, Emitter<RegistrationState> emit) async {
    final result = await registrationRepository.acceptRegistration(
        registrationId: event.registrationId);
    return (switch (result) {
      Success() => emit(AcceptedRegistrationSuccess(registrationId: event.registrationId)),
      Failure() => emit(AcceptedRegistrationFailure(result.message)),
    });
  }

  Future<void> _onRejectRegistration(
      RejectRegistration event, Emitter<RegistrationState> emit) async {
    final result = await registrationRepository.rejectRegistration(
        registrationId: event.registrationId);
    return (switch (result) {
      Success() => emit(RejectRegistrationSuccess(registrationId: event.registrationId)),
      Failure() => emit(RejectRegistrationFailure(result.message)),
    });
  }
}
