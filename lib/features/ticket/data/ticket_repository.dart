import 'dart:developer';

import 'package:qr_checkin/features/ticket/data/ticket_api_client.dart';

import '../../result_type.dart';

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
}