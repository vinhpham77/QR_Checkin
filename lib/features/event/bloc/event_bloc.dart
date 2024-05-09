import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../result_type.dart';
import '../data/event_repository.dart';
import '../dtos/event_dto.dart';
import '../dtos/item_counter.dart';

part 'event_state.dart';

part 'event_event.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventRepository eventRepository;

  EventBloc(this.eventRepository) : super(EventInitial()) {
    on<EventPrefilled>(_prefillEvent);
    on<EventCreate>(_createEvent);
    on<EventFetchOne>(_fetchOneEvent);
    on<EventUpdate>(_updateEvent);
    on<EventFetch>(_fetchEvents);
    on<EventRegister>(_registerEvent);
    on<EventCreateQrCode>(_createQrCode);
  }

  void _prefillEvent(EventPrefilled event, Emitter<EventState> emit) {
    emit(EventCreateInitial(event: event.event));
  }

  void _fetchOneEvent(EventFetchOne event, Emitter<EventState> emit) async {
    emit(EventFetchOneLoading());
    Result result = await eventRepository.get(event.id);
    return (switch (result) {
      Success() => emit(EventFetchOneSuccess(event: result.data)),
      Failure() => emit(EventFetchOneFailure(message: result.message)),
    });
  }

  void _createEvent(EventCreate event, Emitter<EventState> emit) async {
    emit(EventCreating());
    Result result = await eventRepository.createEvent(event.event);
    return (switch (result) {
      Success() => emit(EventCreated(event: result.data)),
      Failure() => emit(EventCreateFailure(message: result.message)),
    });
  }

  void _updateEvent(EventUpdate event, Emitter<EventState> emit) async {
    emit(EventCreating());
    Result result = await eventRepository.updateEvent(event.eventId, event.event);
    return (switch (result) {
      Success() => emit(EventCreated(event: result.data)),
      Failure() => emit(EventCreateFailure(message: result.message)),
    });
  }

  void _fetchEvents(EventFetch event, Emitter<EventState> emit) async {
    emit(EventFetching(key: event.key));
    Result result = await eventRepository.getEvents(
      page: event.page,
      limit: event.limit,
      keyword: event.keyword,
      fields: event.fields,
      categoryId: event.categoryId,
      sortField: event.sortField,
      isAsc: event.isAsc,
      longitude: event.longitude,
      latitude: event.latitude,
    );
    return (switch (result) {
      Success() => emit(EventFetchSuccess(events: result.data, key: event.key)),
      Failure() => emit(EventFetchFailure(message: result.message, key: event.key)),
    });
  }

  Future<void> _registerEvent(EventRegister event, Emitter<EventState> emit) async {
    emit(EventRegistering());
    Result result = await eventRepository.registerEvent(event.eventId);
    return (switch (result) {
      Success() => emit(EventRegisterSuccess()),
      Failure() => emit(EventRegisterFailure(message: result.message)),
    });
  }

  void _createQrCode(EventCreateQrCode event, Emitter<EventState> emit) async {
    emit(EventQrCodeGenerating());
    Result result = await eventRepository.createQrCode(eventId: event.eventId, isCheckIn: event.isCheckIn);
    return (switch (result) {
      Success() => emit(EventQrCodeGenerated(code: result.data)),
      Failure() => emit(EventQrCodeGenerateFailure(message: result.message)),
    });
  }
}
