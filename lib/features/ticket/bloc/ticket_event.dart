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