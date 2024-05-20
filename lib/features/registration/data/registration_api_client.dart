import 'package:dio/dio.dart';
import 'package:qr_checkin/features/registration/dtos/attendance_user_dto.dart';
import 'package:qr_checkin/features/registration/dtos/registration_detail_dto.dart';
import 'package:qr_checkin/features/registration/dtos/registration_user_dto.dart';

import '../../item_counter.dart';

class RegistrationApiClient {
  final Dio dio;

  RegistrationApiClient(this.dio);

  Future<ItemCounterDto<RegistrationDetailDto>> getTicketDetails({
    page = 1,
    size = 10,
  }) async {
    try {
      final response = await dio.get(
        '/registrations',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return ItemCounterDto.fromJson(
        response.data,
        (json) => RegistrationDetailDto.fromJson(json),
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

  Future<ItemCounterDto<AttendanceUserDto>> getAttendances({
    required int eventId,
    page = 1,
    size = 10,
  }) async {
    try {
      final response = await dio.get(
        '/attendances/$eventId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return ItemCounterDto.fromJson(
        response.data,
        (json) => AttendanceUserDto.fromJson(json),
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

  Future<ItemCounterDto<RegistrationUserDto>> getAcceptedRegistrations({
    required int eventId,
    page = 1,
    size = 10,
  }) async {
    try {
      final response = await dio.get(
        '/registrations/$eventId/accepted',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return ItemCounterDto.fromJson(
        response.data,
            (json) => RegistrationUserDto.fromJson(json),
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

  Future<ItemCounterDto<RegistrationUserDto>> getPendingRegistrations({
    required int eventId,
    page = 1,
    size = 10,
  }) async {
    try {
      final response = await dio.get(
        '/registrations/$eventId/pending',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return ItemCounterDto.fromJson(
        response.data,
            (json) => RegistrationUserDto.fromJson(json),
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

  Future<void> acceptRegistration(int registrationId) async {
    try {
      await dio.put('/registrations/$registrationId/accept');
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

  Future<void> rejectRegistration(int registrationId) async {
    try {
      await dio.delete('/registrations/$registrationId/reject');
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
