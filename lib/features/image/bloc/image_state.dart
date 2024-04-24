part of 'image_bloc.dart';

@immutable
sealed class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object?> get props => [];
}

final class ImageInitial extends ImageState {}

final class ImageUploading extends ImageState {}

final class ImageUploadSuccess extends ImageState {
  final String imageUrl;

  const ImageUploadSuccess({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

final class ImageUploadFailure extends ImageState {
  final String message;

  const ImageUploadFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
