import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:nanoid/nanoid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload an image file to Firebase Storage
  /// Returns the download URL
  Future<String> uploadImage({
    required File imageFile,
    required String folder,
    String? customFileName,
  }) async {
    try {
      // Generate unique filename if not provided
      final fileName = customFileName ??
          '${nanoid()}_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';

      // Create reference to the file location
      final storageRef = _storage.ref().child('$folder/$fileName');

      // Upload the file
      final uploadTask = storageRef.putFile(imageFile);

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Upload image from bytes (useful for camera captures)
  Future<String> uploadImageBytes({
    required Uint8List imageBytes,
    required String folder,
    String? customFileName,
    String fileExtension = '.jpg',
  }) async {
    try {
      final fileName = customFileName ??
          '${nanoid()}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      final storageRef = _storage.ref().child('$folder/$fileName');

      final uploadTask = storageRef.putData(imageBytes);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image bytes: $e');
    }
  }

  /// Upload a PDF file to Firebase Storage
  /// Returns the download URL
  Future<String> uploadPdf({
    required File pdfFile,
    required String folder,
    String? customFileName,
  }) async {
    try {
      // Generate unique filename if not provided
      final fileName = customFileName ??
          '${nanoid()}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // Create reference to the file location
      final storageRef = _storage.ref().child('$folder/$fileName');

      // Upload the file
      final uploadTask = storageRef.putFile(pdfFile);

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload PDF: $e');
    }
  }

  /// Upload PDF from bytes
  Future<String> uploadPdfBytes({
    required Uint8List pdfBytes,
    required String folder,
    String? customFileName,
  }) async {
    try {
      final fileName = customFileName ??
          '${nanoid()}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final storageRef = _storage.ref().child('$folder/$fileName');

      final uploadTask = storageRef.putData(pdfBytes);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload PDF bytes: $e');
    }
  }

  /// Upload any file type to Firebase Storage
  /// Returns the download URL
  Future<String> uploadFile({
    required File file,
    required String folder,
    String? customFileName,
  }) async {
    try {
      // Get file extension
      final fileExtension = path.extension(file.path);

      // Generate unique filename if not provided
      final fileName = customFileName ??
          '${nanoid()}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      // Create reference to the file location
      final storageRef = _storage.ref().child('$folder/$fileName');

      // Upload the file
      final uploadTask = storageRef.putFile(file);

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Upload file from bytes
  Future<String> uploadFileBytes({
    required Uint8List fileBytes,
    required String folder,
    String? customFileName,
    String fileExtension = '.bin',
  }) async {
    try {
      final fileName = customFileName ??
          '${nanoid()}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      final storageRef = _storage.ref().child('$folder/$fileName');

      final uploadTask = storageRef.putData(fileBytes);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file bytes: $e');
    }
  }

  /// Delete a file from Firebase Storage
  Future<void> deleteFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Get file metadata
  Future<FullMetadata> getFileMetadata(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      return await ref.getMetadata();
    } catch (e) {
      throw Exception('Failed to get file metadata: $e');
    }
  }

  /// Upload multiple files and return their URLs
  Future<List<String>> uploadMultipleFiles({
    required List<File> files,
    required String folder,
  }) async {
    try {
      final List<String> downloadUrls = [];

      for (final file in files) {
        final downloadUrl = await uploadFile(
          file: file,
          folder: folder,
        );
        downloadUrls.add(downloadUrl);
      }

      return downloadUrls;
    } catch (e) {
      throw Exception('Failed to upload multiple files: $e');
    }
  }
}
