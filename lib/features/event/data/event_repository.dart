import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:qr_checkin/features/qr_event.dart';

import '../../item_counter.dart';
import '../../result_type.dart';
import '../dtos/event_dto.dart';
import 'event_api_client.dart';

class EventRepository {
  final EventApiClient eventApiClient;

  EventRepository(this.eventApiClient);

  Future<Result<EventDto>> get(int id) async {
    try {
      final event = await eventApiClient.get(id);
      return Success(event);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<EventDto>> createEvent(EventDto event) async {
    try {
      final createdEvent = await eventApiClient.createEvent(event);
      return Success(createdEvent);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<EventDto>> updateEvent(int eventId, EventDto event) async {
    try {
      final updatedEvent = await eventApiClient.updateEvent(eventId, event);
      return Success(updatedEvent);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<ItemCounterDto<EventDto>>> getEvents({
    int page = 1,
    int limit = 10,
    String? keyword,
    required List<String> fields,
    int? categoryId,
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
        categoryId: categoryId,
        sortField: sortField,
        isAsc: isAsc,
        latitude: latitude,
        longitude: longitude,
      );
      return Success(events);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<void>> registerEvent(int eventId) async {
    try {
      await eventApiClient.registerEvent(eventId);
      return Success(null);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<String>> createQrCode(
      {required int eventId, required bool isCheckIn}) async {
    try {
      final code = await eventApiClient.createQrCode(
          eventId: eventId, isCheckIn: isCheckIn);
      return Success(code);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<EventDto>> checkRegistration(int eventId) async {
    try {
      final eventDto = await eventApiClient.checkRegistration(eventId);
      return Success(eventDto);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<bool>> check({required QrEvent qrEvent, required Uint8List qrImage, required bool isCaptureRequired, File? portraitFile, required LatLng location}) async {
    try {
      await (qrEvent.isCheckin ? eventApiClient.checkIn(qrEvent, qrImage, isCaptureRequired, portraitFile, location) : eventApiClient.checkOut(qrEvent, qrImage, isCaptureRequired, portraitFile, location));
      return Success(qrEvent.isCheckin);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }
}
