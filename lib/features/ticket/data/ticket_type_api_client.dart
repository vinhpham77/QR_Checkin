import 'package:dio/dio.dart';
import 'package:qr_checkin/features/ticket/dtos/ticket_type_dto.dart';

class TicketTypeApiClient {
  final Dio dio;

  TicketTypeApiClient(this.dio);

  Future<List<TicketTypeDto>> getByEventId(int eventId) async {
    final response = await dio.get('/ticket-types/$eventId');
    return (response.data as List)
        .map((json) => TicketTypeDto.fromJson(json))
        .toList();
  }
}