import 'dart:developer';

import 'package:dio/dio.dart';

import '../dtos/event_dto.dart';

class EventApiClient {
  final Dio dio;

  EventApiClient(this.dio);

  Future<EventDto> createEvent(EventDto event) async {
    try {
      final response = await dio.post('/events', data: event.toJson());
      return EventDto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }
}