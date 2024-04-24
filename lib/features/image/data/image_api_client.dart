import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_checkin/config/http_client.dart';

class ImageApiClient {
  final Dio dio;

  ImageApiClient(this.dio);

  Future<String> upload(XFile file) async {
    try {
      String fileName = file.name;
      List<int> fileBytes = await file.readAsBytes();

      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      final response =
          await dio.post('${servicePaths['images']}/upload', data: formData);
      return response.data;
    } on DioException catch (e) {
      if (e.response!.data['message'] != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> saveByContent(String content) async {
    try {
      await dio.post('${servicePaths['images']}/by-content', data: content);
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

  Future<void> deleteByContent(String content) async {
    try {
      await dio.delete('${servicePaths['images']}/by-content', data: content);
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
