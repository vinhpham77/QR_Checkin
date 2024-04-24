import 'package:dio/dio.dart';

import '../../result_type.dart';
import '../dtos/event_dto.dart';
import 'event_api_client.dart';

class EventRepository {
  final EventApiClient eventApiClient;

  EventRepository(this.eventApiClient);

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
}