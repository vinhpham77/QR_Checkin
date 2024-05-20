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

final class TicketBuyerFetching extends TicketState {
}

final class TicketBuyerFetchSuccess extends TicketState {
  final ItemCounterDto<TicketUserDto> ticketBuyers;

  const TicketBuyerFetchSuccess({required this.ticketBuyers});

  @override
  List<Object> get props => [ticketBuyers];
}

final class TicketBuyerFetchFailure extends TicketState {
  final String message;

  const TicketBuyerFetchFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class TicketCheckInFetching extends TicketState {
}

final class TicketCheckInFetchSuccess extends TicketState {
  final ItemCounterDto<TicketUserDto> ticketCheckIns;

  const TicketCheckInFetchSuccess({required this.ticketCheckIns});

  @override
  List<Object> get props => [ticketCheckIns];
}

final class TicketCheckInFetchFailure extends TicketState {
  final String message;

  const TicketCheckInFetchFailure(this.message);

  @override
  List<Object> get props => [message];
}