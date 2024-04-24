import 'dart:developer';

import 'package:camera/camera.dart';

import '../../result_type.dart';
import 'image_api_client.dart';

class ImageRepository {
  final ImageApiClient imageApiClient;

  ImageRepository(this.imageApiClient);

  Future<Result<String>> upload(XFile file) async {
    try {
      final result = await imageApiClient.upload(file);
      return Success(result);
    } on Exception catch (e) {
      log('$e');
      return Failure('$e');
    }
  }
}
