import 'package:dio/dio.dart';
import 'package:qr_checkin/features/category/dtos/category_dto.dart';

class CategoryApiClient {
  final Dio dio;

  CategoryApiClient(this.dio);

  Future<void> createCategory(String category) async {
    try {
      await dio.post(
        '/categories',
        data: {'category': category},
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<CategoryDto>> getCategories() async {
    try {
      final response = await dio.get('/categories');
      return (response.data as List)
          .map((category) => CategoryDto.fromJson(category))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
