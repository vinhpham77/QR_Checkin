part of 'event_bloc.dart';

@immutable
sealed class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

final class EventCreatePrefilled extends EventEvent {
  final EventDto event;

  const EventCreatePrefilled({required this.event});

  @override
  List<Object?> get props => [event];
}

final class EventCreateStarted extends EventEvent {
  final EventDto event;

  const EventCreateStarted({required this.event});

  @override
  List<Object?> get props => [event];
}