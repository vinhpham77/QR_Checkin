import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../result_type.dart';
import '../data/category_repository.dart';
import '../dtos/category_dto.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc(this.categoryRepository) : super(CategoryInitial()) {
    on<CategoryFetchStarted>(_onFetchStarted);
  }

  void _onFetchStarted(CategoryFetchStarted event, Emitter<CategoryState> emit) async {
    emit(CategoryFetching());
    final result = await categoryRepository.getCategories();
    return (switch (result) {
      Success() => emit(CategoryFetchSuccess(categories: result.data)),
      Failure() => emit(CategoryFetchFailure(message: result.message)),
    });
  }

}
