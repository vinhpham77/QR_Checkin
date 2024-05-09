import 'package:dio/dio.dart';

class TicketApiClient {
  final Dio dio;

  TicketApiClient(this.dio);

  Future<void> purchase({required int ticketTypeId}) async {
    await dio.post(
      '/tickets/purchase',
      data: {
        'ticketTypeId': ticketTypeId,
      },
    );
  }
}