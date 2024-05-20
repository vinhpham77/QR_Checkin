import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../item_counter.dart';
import '../../result_type.dart';
import '../data/ticket_repository.dart';
import '../data/ticket_type_repository.dart';
import '../dtos/ticket_detail_dto.dart';
import '../dtos/ticket_type_dto.dart';
import '../dtos/ticket_user_dto.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository;
  final TicketTypeRepository ticketTypeRepository;

  TicketBloc({required this.ticketRepository, required this.ticketTypeRepository}) : super(TicketInitial()) {
    on<TicketEventInitial>((event, emit) => emit(TicketInitial()));
    on<TicketTypeFetch>(_onTicketTypeFetch);
    on<TicketPurchase>(_onTicketPurchase);
    on<TicketCheckIn>(_onTicketCheckIn);
    on<TicketDetailFetch>(_onTicketDetailFetch);
    on<TicketBuyerFetch>(_onTicketBuyerFetch);
    on<TicketCheckInFetch>(_onTicketCheckInFetch);
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

  Future<void> _onTicketCheckIn(TicketCheckIn event, Emitter<TicketState> emit) async {
    final result = await ticketRepository.checkIn(code: event.code, eventId: event.eventId);
    return (switch (result) {
      Success() => emit(TicketCheckInSuccess()),
      Failure() => emit(TicketCheckInFailure(result.message)),
    });
  }

  Future<void> _onTicketDetailFetch(TicketDetailFetch event, Emitter<TicketState> emit) async {
    emit(TicketDetailFetching());
    final result = await ticketRepository.getTicketDetails(page: event.page, size: event.size);
    return (switch (result) {
      Success() => emit(TicketDetailFetchSuccess(ticketDetails: result.data)),
      Failure() => emit(TicketDetailFetchFailure(result.message)),
    });
  }

  Future<void> _onTicketBuyerFetch(TicketBuyerFetch event, Emitter<TicketState> emit) async {
    emit(TicketBuyerFetching());
    final result = await ticketRepository.getTicketBuyers(eventId: event.eventId, page: event.page, size: event.size);
    return (switch (result) {
      Success() => emit(TicketBuyerFetchSuccess(ticketBuyers: result.data)),
      Failure() => emit(TicketBuyerFetchFailure(result.message)),
    });
  }

  Future<void> _onTicketCheckInFetch(TicketCheckInFetch event, Emitter<TicketState> emit) async {
    emit(TicketCheckInFetching());
    final result = await ticketRepository.getTicketCheckIns(eventId: event.eventId, page: event.page, size: event.size);
    return (switch (result) {
      Success() => emit(TicketCheckInFetchSuccess(ticketCheckIns: result.data)),
      Failure() => emit(TicketCheckInFetchFailure(result.message)),
    });
  }
}