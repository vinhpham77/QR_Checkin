import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../result_type.dart';
import '../data/ticket_repository.dart';
import '../data/ticket_type_repository.dart';
import '../dtos/ticket_type_dto.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository;
  final TicketTypeRepository ticketTypeRepository;

  TicketBloc(this.ticketRepository, this.ticketTypeRepository) : super(TicketInitial()) {
    on<TicketEventInitial>((event, emit) => emit(TicketInitial()));
    on<TicketTypeFetch>(_onTicketTypeFetch);
    on<TicketPurchase>(_onTicketPurchase);
  }

  Future<void> _onTicketTypeFetch(TicketTypeFetch event, Emitter<TicketState> emit) async {
    emit(TicketTypeFetching());
    final result = await ticketTypeRepository.getByEventId(event.eventId);
    return (switch (result) {
      Success() => emit(TicketTypeFetchSuccess(ticketTypes: result.data)),
      Failure() => emit(TicketTypeFetchFailure(result.message)),
    });
  }

  Future<void> _onTicketPurchase(TicketPurchase event, Emitter<TicketState> emit) async {
    emit(TicketPurchasing());
    final result = await ticketRepository.purchase(ticketTypeId: event.ticketTypeId);
    return (switch (result) {
      Success() => emit(TicketPurchaseSuccess()),
      Failure() => emit(TicketPurchaseFailure(result.message)),
    });
  }
}