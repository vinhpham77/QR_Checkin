import 'dart:developer';

import 'package:qr_checkin/features/ticket/data/ticket_type_api_client.dart';
import 'package:qr_checkin/features/ticket/dtos/ticket_type_dto.dart';

import '../../result_type.dart';

class TicketTypeRepository {
  final TicketTypeApiClient ticketTypeApiClient;

  TicketTypeRepository(this.ticketTypeApiClient);

  Future<Result<List<TicketTypeDto>>> getByEventId(int eventId) async {
    try {
      final ticketTypes = await ticketTypeApiClient.getByEventId(eventId);
      return Success(ticketTypes);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }
}