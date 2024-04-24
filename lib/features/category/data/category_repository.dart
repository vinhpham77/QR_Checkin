import 'dart:developer';

import '../../result_type.dart';
import '../dtos/category_dto.dart';
import 'category_api_client.dart';

class CategoryRepository {
  final CategoryApiClient _categoryApiClient;

  CategoryRepository(this._categoryApiClient);

  Future<Result<void>> createCategory(String category) async {
    try {
      await _categoryApiClient.createCategory(category);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
    return Success(null);
  }

  Future<Result<List<CategoryDto>>> getCategories() async {
    try {
      final categories = await _categoryApiClient.getCategories();
      return Success(categories);
    } on Exception catch (e) {
      log('$e');
      return Failure.fromException(e);
    }
  }
}