part of 'ticket_bloc.dart';

@immutable
sealed class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object> get props => [];
}

final class TicketEventInitial extends TicketEvent {
}

final class TicketTypeFetch extends TicketEvent {
  final int eventId;

  const TicketTypeFetch(this.eventId);

  @override
  List<Object> get props => [eventId];
}

final class TicketPurchase extends TicketEvent {
  final int ticketTypeId;

  const TicketPurchase({required this.ticketTypeId});

  @override
  List<Object> get props => [ticketTypeId];
}

final class TicketCheckIn extends TicketEvent {
  final String code;
  final int eventId;

  const TicketCheckIn({required this.code, required this.eventId});

  @override
  List<Object> get props => [code, eventId];
}

final class TicketDetailFetch extends TicketEvent {
  final int page;
  final int size;

  const TicketDetailFetch({this.page = 1, this.size = 10});

  @override
  List<Object> get props => [page, size];
}

final class TicketBuyerFetch extends TicketEvent {
  final int eventId;
  final int page;
  final int size;

  const TicketBuyerFetch(
      {required this.eventId, this.page = 1, this.size = 10});

  @override
  List<Object> get props => [eventId, page, size];
}

final class TicketCheckInFetch extends TicketEvent {
  final int eventId;
  final int page;
  final int size;

  const TicketCheckInFetch(
      {required this.eventId, this.page = 1, this.size = 10});

  @override
  List<Object> get props => [eventId, page, size];
}