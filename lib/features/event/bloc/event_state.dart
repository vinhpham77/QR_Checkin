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