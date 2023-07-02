import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<List<File>> pickAllImages() async {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage();
  if (imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(File(image.path));
    }
  }
  return images;
}

Future<File?> pickimage() async {
  File? image;
  final ImagePicker picker = ImagePicker();
  final imagefile = await picker.pickImage(source: ImageSource.gallery);
  if (imagefile != null) {
    return File(imagefile.path);
  }
  return image;
}
