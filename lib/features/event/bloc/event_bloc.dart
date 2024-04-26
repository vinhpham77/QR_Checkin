import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../result_type.dart';
import '../data/event_repository.dart';
import '../dtos/event_dto.dart';

part 'event_state.dart';

part 'event_event.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventRepository eventRepository;

  EventBloc(this.eventRepository) : super(EventInitial()) {
    on<EventPrefilled>(_prefillEvent);
    on<EventCreate>(_createEvent);
    on<EventFetchOne>(_fetchOneEvent);
    on<EventUpdate>(_updateEvent);
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
}
