import 'dart:developer';

import 'package:dio/dio.dart';

import '../dtos/event_dto.dart';

class EventApiClient {
  final Dio dio;

  EventApiClient(this.dio);

  Future<EventDto> get(int id) async {
    try {
      final response = await dio.get('/events/$id');
      return EventDto.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response!.data['message']) {
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
      if (e.response!.data['message']) {
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
      if (e.response!.data['message']) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}