import 'dart:io';
import 'package:image_picker/image_picker.dart';

enum MediaType { image, video }

Future<File?> pickMedia({
  required MediaType mediaType,
  required ImageSource source,
}) async {
  final picker = ImagePicker();

  try {
    XFile? pickedFile;

    if (mediaType == MediaType.image) {
      pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 50, // compress image
      );
    } else {
      pickedFile = await picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5), // optional
      );
    }

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
