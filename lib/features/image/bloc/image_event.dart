part of 'image_bloc.dart';

@immutable
sealed class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object?> get props => [];
}

final class ImageInitialStart extends ImageEvent {}

final class ImageUpload extends ImageEvent {
  final XFile image;

  const ImageUpload({required this.image});

  @override
  List<Object?> get props => [image];
}