import 'package:dio/dio.dart';

import '../../result_type.dart';
import '../dtos/event_dto.dart';
import '../dtos/item_counter.dart';
import 'event_api_client.dart';

class EventRepository {
  final EventApiClient eventApiClient;

  EventRepository(this.eventApiClient);

  Future<Result<EventDto>> get(int id) async {
    try {
      final event = await eventApiClient.get(id);
      return Success(event);
    } on DioException catch (e) {
      return Failure.fromException(e);
    } catch (e) {
      return Failure.fromException(e);
    }
  }

  Future<Result<EventDto>> createEvent(EventDto event) async {
    try {
      final createdEvent = await eventApiClient.createEvent(event);
      return Success(createdEvent);
    } on DioException catch (e) {
      return Failure.fromException(e);
    } catch (e) {
      return Failure.fromException(e);
    }
  }

  Future<Result<EventDto>> updateEvent(int eventId, EventDto event) async {
    try {
      final updatedEvent = await eventApiClient.updateEvent(eventId, event);
      return Success(updatedEvent);
    } on DioException catch (e) {
      return Failure.fromException(e);
    } catch (e) {
      return Failure.fromException(e);
    }
  }

  Future<Result<ItemCounterDTO<EventDto>>> getEvents({
    int page = 1,
    int limit = 10,
    String? keyword,
    required List<String> fields,
    String? category,
    String? sortField,
    bool? isAsc,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final events = await eventApiClient.getEvents(
        page: page,
        limit: limit,
        keyword: keyword,
        fields: fields,
        category: category,
        sortField: sortField,
        isAsc: isAsc,
        latitude: latitude,
        longitude: longitude,
      );
      return Success(events);
    } on DioException catch (e) {
      return Failure.fromException(e);
    } catch (e) {
      return Failure.fromException(e);
    }
  }
}