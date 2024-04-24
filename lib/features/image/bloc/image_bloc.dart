import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_checkin/features/image/data/image_repository.dart';

import '../../../utils/image_utils.dart';
import '../../result_type.dart';

part 'image_event.dart';

part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository imageRepository;

  ImageBloc(this.imageRepository) : super(ImageInitial()) {
    on<ImageInitialStart>(_onInitialStart);
    on<ImageUpload>(_uploadImage);
  }

  Future<void> _uploadImage(ImageUpload event, Emitter<ImageState> emit) async {
    emit(ImageUploading());
    final result = await imageRepository.upload(event.image);
    return (switch (result) {
      Success() => emit(ImageUploadSuccess(imageUrl: getImageUrl(result.data))),
      Failure() => emit(ImageUploadFailure(message: result.message)),
    });
  }

  void _onInitialStart(ImageInitialStart event, Emitter<ImageState> emit) {
    emit(ImageInitial());
  }
}
