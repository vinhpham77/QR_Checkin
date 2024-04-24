part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

final class CategoryFetchStarted extends CategoryEvent {}
