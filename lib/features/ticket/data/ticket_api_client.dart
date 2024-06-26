import 'package:dio/dio.dart';
import 'package:qr_checkin/features/ticket/dtos/ticket_detail_dto.dart';
import 'package:qr_checkin/features/ticket/dtos/ticket_user_dto.dart';

import '../../item_counter.dart';

class TicketApiClient {
  final Dio dio;

  TicketApiClient(this.dio);

  Future<void> purchase({required int ticketTypeId}) async {
    try {
      await dio.post(
        '/tickets/purchase',
        data: {
          'ticketTypeId': ticketTypeId,
        },
      );
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> checkIn({required String code, required int eventId}) async {
    try {
      await dio.put(
        '/tickets/check-in',
        data: {
          'code': code,
          'eventId': eventId,
        },
      );
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ItemCounterDto<TicketDetailDto>> getTicketDetails(
      {page = 1, size = 10}) async {
    try {
      final response = await dio.get(
        '/tickets',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return ItemCounterDto.fromJson(
        response.data,
        (json) => TicketDetailDto.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ItemCounterDto<TicketUserDto>> getTicketBuyers(
      {required int eventId, page = 1, size = 10}) async {
    try {
      final response = await dio.get(
        '/tickets/$eventId/buyers',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return ItemCounterDto.fromJson(
        response.data,
        (json) => TicketUserDto.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ItemCounterDto<TicketUserDto>> getTicketCheckIns(
      {required int eventId, page = 1, size = 10}) async {
    try {
      final response = await dio.get(
        '/tickets/$eventId/check-ins',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return ItemCounterDto.fromJson(
        response.data,
        (json) => TicketUserDto.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
