import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../config/http_client.dart';
import '../features/image/bloc/image_bloc.dart';

String getImageUrl(String? fileName) {
  if (fileName == null) {
    return '';
  }

  return '${dio.options.baseUrl}${servicePaths['images']!}/$fileName';
}

void getImage(ImageBloc imageBloc) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    var file = File(pickedFile.path);
    var sizeInBytes = await file.length();
    var sizeInKB = sizeInBytes / 1024;
    var sizeInMB = sizeInKB / 1024;

    if (sizeInMB <= 5) {
      imageBloc.add(ImageUpload(image: pickedFile));
    }
  }
}
