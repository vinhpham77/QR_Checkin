part of 'event_bloc.dart';

@immutable
sealed class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

final class EventPrefilled extends EventEvent {
  final EventDto event;

  const EventPrefilled({required this.event});

  @override
  List<Object?> get props => [event];
}

final class EventCreate extends EventEvent {
  final EventDto event;

  const EventCreate({required this.event});

  @override
  List<Object?> get props => [event];
}

final class EventFetchOne extends EventEvent {
  final int id;

  const EventFetchOne({required this.id});

  @override
  List<Object?> get props => [id];
}

final class EventUpdate extends EventEvent {
  final int eventId;
  final EventDto event;

  const EventUpdate({required this.eventId, required this.event});

  @override
  List<Object?> get props => [eventId, event];
}