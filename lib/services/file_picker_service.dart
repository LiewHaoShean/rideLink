import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class FilePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Compress image
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  /// Take photo with camera
  Future<File?> takePhotoWithCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      throw Exception('Failed to take photo: $e');
    }
  }

  /// Get image as bytes (useful for camera captures)
  Future<Uint8List?> getImageBytes(File imageFile) async {
    try {
      return await imageFile.readAsBytes();
    } catch (e) {
      throw Exception('Failed to read image bytes: $e');
    }
  }
}
