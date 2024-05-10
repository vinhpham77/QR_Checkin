import 'package:dio/dio.dart';
import 'package:qr_checkin/features/event/dtos/item_counter.dart';

import '../dtos/event_dto.dart';

class EventApiClient {
  final Dio dio;

  EventApiClient(this.dio);

  Future<EventDto> get(int id) async {
    try {
      final response = await dio.get('/events/$id');
      return EventDto.fromJson(response.data);
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

  Future<ItemCounterDTO<EventDto>> getEvents({
    int page = 1,
    int limit = 10,
    String? keyword,
    required List<String> fields,
    int? categoryId,
    String? sortField,
    bool? isAsc,
    required double longitude,
    required double latitude,
  }) async {
    try {
      dio.options.headers['latitude'] = latitude;
      dio.options.headers['longitude'] = longitude;

      final response = await dio.get('/events', queryParameters: {
        'page': page,
        'limit': limit,
        'keyword': keyword,
        'isAsc': isAsc,
        'fields': fields,
        'categoryId': categoryId,
        'sortField': sortField,
      });

      return ItemCounterDTO.fromJson(response.data, (data) => EventDto.fromJson(data));
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

  Future<EventDto> createEvent(EventDto event) async {
    try {
      // TODO: save images
      final response = await dio.post('/events', data: event.toJson());
      return EventDto.fromJson(response.data);
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

  Future<EventDto> updateEvent(int eventId, EventDto event) async {
    try {
      final response = await dio.put('/events/$eventId', data: event.toJson());
      return EventDto.fromJson(response.data);
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

  Future<void> registerEvent(int eventId) async {
    try {
      await dio.post('/registrations/register', data: {
        'eventId': eventId,
      });
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

  Future<String> createQrCode({required int eventId, required bool isCheckIn}) async {
    try {
      final response = await dio.post('/events/generate-qr', data: {
        'eventId': eventId,
        'isCheckIn': isCheckIn,
      });
      return response.data;
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