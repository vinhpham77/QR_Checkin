import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

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

      final response = await dio.post('/images/upload', data: formData);
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
}
