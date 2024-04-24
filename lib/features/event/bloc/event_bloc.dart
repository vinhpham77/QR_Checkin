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
    on<EventCreatePrefilled>(_prefillEvent);
    on<EventCreateStarted>(_createEvent);
  }

  void _prefillEvent(EventCreatePrefilled event, Emitter<EventState> emit) {
    emit(EventCreateInitial(event: event.event));
  }

  void _createEvent(EventCreateStarted event, Emitter<EventState> emit) async {
    emit(EventCreating());
    Result result = await eventRepository.createEvent(event.event);
    return (switch (result) {
      Success() => emit(EventCreated(event: result.data)),
      Failure() => emit(EventCreateFailure(message: result.message)),
    });
  }
}
