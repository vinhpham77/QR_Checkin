import 'dart:developer';

import 'package:qr_checkin/features/ticket/data/ticket_api_client.dart';
import 'package:qr_checkin/features/ticket/dtos/ticket_user_dto.dart';

import '../../item_counter.dart';
import '../../result_type.dart';
import '../dtos/ticket_detail_dto.dart';

class TicketRepository {
  final TicketApiClient ticketApiClient;

  TicketRepository(this.ticketApiClient);

  Future<Result<void>> purchase({required ticketTypeId}) async {
    try {
      await ticketApiClient.purchase(ticketTypeId: ticketTypeId);
      return Success(null);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<void>> checkIn({required code, required eventId}) async {
    try {
      await ticketApiClient.checkIn(code: code, eventId: eventId);
      return Success(null);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<ItemCounterDto<TicketDetailDto>>> getTicketDetails(
      {int page = 1, int size = 10}) async {
    try {
      final ticketDetails =
          await ticketApiClient.getTicketDetails(page: page, size: size);
      return Success(ticketDetails);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<ItemCounterDto<TicketUserDto>>> getTicketBuyers(
      {required int eventId, int page = 1, int size = 10}) async {
    try {
      final ticketDetails = await ticketApiClient.getTicketBuyers(
          eventId: eventId, page: page, size: size);
      return Success(ticketDetails);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<ItemCounterDto<TicketUserDto>>> getTicketCheckIns(
      {required int eventId, int page = 1, int size = 10}) async {
    try {
      final ticketDetails = await ticketApiClient.getTicketCheckIns(
          eventId: eventId, page: page, size: size);
      return Success(ticketDetails);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }
}
