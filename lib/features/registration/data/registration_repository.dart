import 'dart:developer';

import 'package:qr_checkin/features/registration/data/registration_api_client.dart';
import 'package:qr_checkin/features/registration/dtos/attendance_user_dto.dart';
import 'package:qr_checkin/features/registration/dtos/registration_user_dto.dart';

import '../../item_counter.dart';
import '../../result_type.dart';
import '../dtos/registration_detail_dto.dart';

class RegistrationRepository {
  final RegistrationApiClient registrationApiClient;

  RegistrationRepository(this.registrationApiClient);

  Future<Result<ItemCounterDto<RegistrationDetailDto>>> getRegistrationDetails(
      {int page = 1, int size = 10}) async {
    try {
      final ticketDetails =
          await registrationApiClient.getRegistrationDetails(page: page, size: size);
      return Success(ticketDetails);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<ItemCounterDto<AttendanceUserDto>>> getAttendances({
    required int eventId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final attendances = await registrationApiClient.getAttendances(
        eventId: eventId,
        page: page,
        size: size,
      );
      return Success(attendances);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<ItemCounterDto<RegistrationUserDto>>> getAcceptedRegistrations({
    required int eventId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final registrations = await registrationApiClient.getAcceptedRegistrations(
        eventId: eventId,
        page: page,
        size: size,
      );
      return Success(registrations);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<ItemCounterDto<RegistrationUserDto>>> getPendingRegistrations({
    required int eventId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final registrations = await registrationApiClient.getPendingRegistrations(
        eventId: eventId,
        page: page,
        size: size,
      );
      return Success(registrations);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<void>> acceptRegistration({required int registrationId}) async {
    try {
      await registrationApiClient.acceptRegistration(registrationId);
      return Success(null);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }

  Future<Result<void>> rejectRegistration({required int registrationId}) async {
    try {
      await registrationApiClient.rejectRegistration(registrationId);
      return Success(null);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }
}
