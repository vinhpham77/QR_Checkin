part of 'event_bloc.dart';

@immutable
sealed class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

final class EventInitial extends EventState {}

final class EventCreateInitial extends EventState {
  final EventDto event;

  const EventCreateInitial({required this.event});

  @override
  List<Object?> get props => [event];
}

final class EventCreating extends EventState {}

final class EventCreated extends EventState {
  final EventDto event;

  const EventCreated({required this.event});

  @override
  List<Object?> get props => [event];
}

final class EventCreateFailure extends EventState {
  final String message;

  const EventCreateFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

final class EventFetchOneLoading extends EventState {}

final class EventFetchOneSuccess extends EventState {
  final EventDto event;

  const EventFetchOneSuccess({required this.event});

  @override
  List<Object?> get props => [event];
}

final class EventFetchOneFailure extends EventState {
  final String message;

  const EventFetchOneFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

final class EventUpdating extends EventState {}

final class EventUpdateSuccess extends EventState {
  final EventDto event;

  const EventUpdateSuccess({required this.event});

  @override
  List<Object?> get props => [event];
}

final class EventUpdateFailure extends EventState {
  final String message;

  const EventUpdateFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

final class EventFetchSuccess extends EventState {
  final ItemCounterDTO<EventDto> events;
  final String key;

  const EventFetchSuccess({required this.events, required this.key});

  @override
  List<Object?> get props => [events, key];
}

final class EventFetching extends EventState {
  final String key;

  const EventFetching({required this.key});

  @override
  List<Object?> get props => [key];
}

final class EventFetchFailure extends EventState {
  final String message;
  final String key;

  const EventFetchFailure({required this.message, required this.key});

  @override
  List<Object?> get props => [message, key];
}