part of 'ticket_bloc.dart';

@immutable
sealed class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object> get props => [];
}

final class TicketInitial extends TicketState {
}

final class TicketTypeFetching extends TicketState {
}

final class TicketTypeFetchSuccess extends TicketState {
  final List<TicketTypeDto> ticketTypes;

  const TicketTypeFetchSuccess({required this.ticketTypes});

  @override
  List<Object> get props => [ticketTypes];
}

final class TicketTypeFetchFailure extends TicketState {
  final String message;

  const TicketTypeFetchFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class TicketPurchasing extends TicketState {
}

final class TicketPurchaseSuccess extends TicketState {
}

final class TicketPurchaseFailure extends TicketState {
  final String message;

  const TicketPurchaseFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class TicketCheckInSuccess extends TicketState {
}

final class TicketCheckInFailure extends TicketState {
  final String message;

  const TicketCheckInFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class TicketDetailFetching extends TicketState {
}

final class TicketDetailFetchSuccess extends TicketState {
  final ItemCounterDto<TicketDetailDto> ticketDetails;

  const TicketDetailFetchSuccess({required this.ticketDetails});

  @override
  List<Object> get props => [ticketDetails];
}

final class TicketDetailFetchFailure extends TicketState {
  final String message;

  const TicketDetailFetchFailure(this.message);

  @override
  List<Object> get props => [message];
}