import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_checkin/features/item_counter.dart';
import 'package:qr_checkin/features/qr_event.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<ItemCounterDto<EventDto>> getEvents({
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

      return ItemCounterDto.fromJson(
          response.data, (data) => EventDto.fromJson(data));
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

  Future<String> createQrCode(
      {required int eventId, required bool isCheckIn}) async {
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

  Future<EventDto> checkRegistration(int eventId) async {
    try {
      var response = await dio.get('/registrations/$eventId/check');
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

  Future<bool> checkIn(QrEvent qrEvent, Uint8List qrImage,
      bool isCaptureRequired, File? portraitFile, LatLng location) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File qrImgFile = File('$tempPath/qr_code.png');
      await qrImgFile.writeAsBytes(qrImage);

      var formData = FormData();

      formData.files.add(MapEntry(
          'qrImage', MultipartFile.fromFileSync(qrImgFile.path)));
      if (isCaptureRequired && portraitFile != null) {
        formData.files.add(MapEntry('portraitImage',
            MultipartFile.fromFileSync(portraitFile.path)));
      }
      formData.fields.add(MapEntry('code', qrEvent.code));

      dio.options.headers['latitude'] = location.latitude;
      dio.options.headers['longitude'] = location.longitude;

      await dio.post('/attendances/${qrEvent.eventId}/check-in',
          data: formData);

      // Xóa tệp sau khi sử dụng
      await qrImgFile.delete();
      await portraitFile?.delete();

      return qrEvent.isCheckin;
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

  Future<bool> checkOut(QrEvent qrEvent, Uint8List qrImage,
      bool isCaptureRequired, File? portraitFile, LatLng location) {
    throw UnimplementedError();
  }
}
