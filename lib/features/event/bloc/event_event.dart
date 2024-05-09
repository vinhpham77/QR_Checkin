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

final class EventFetch extends EventEvent {
  final int page;
  final int limit;
  final String? keyword;
  final List<String> fields;
  final int? categoryId;
  final String? sortField;
  final bool? isAsc;
  final double longitude;
  final double latitude;
  final String key;

  const EventFetch({
    this.page = 1,
    this.limit = 8,
    this.keyword,
    required this.fields,
    required this.categoryId,
    this.sortField,
    this.isAsc,
    required this.longitude,
    required this.latitude,
    required this.key,
  });

  @override
  List<Object?> get props => [page, limit, keyword, fields, categoryId, sortField, isAsc, longitude, latitude, key];
}

final class EventRegister extends EventEvent {
  final int eventId;

  const EventRegister({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

final class EventCreateQrCode extends EventEvent {
  final int eventId;
  final bool isCheckIn;

  const EventCreateQrCode({required this.eventId, required this.isCheckIn});

  @override
  List<Object?> get props => [eventId, isCheckIn];
}