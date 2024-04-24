part of 'category_bloc.dart';

@immutable
sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class CategoryFetching extends CategoryState {}

final class CategoryFetchSuccess extends CategoryState {
  final List<CategoryDto> categories;

  const CategoryFetchSuccess({required this.categories});

  @override
  List<Object?> get props => [categories];
}

final class CategoryFetchFailure extends CategoryState {
  final String message;

  const CategoryFetchFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
