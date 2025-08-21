import 'dart:io';

import 'package:driver_repository/src/storage_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageRepository extends StorageRepo {
  FirebaseStorageRepository({
    FirebaseStorage? storageInstance,
  }) : _storageInstance = storageInstance ?? FirebaseStorage.instance;

  final FirebaseStorage _storageInstance;

  @override
  Future<String> uploadFile({
    required File file,
    required String folderName,
    required String fileName,
  }) async {
    final ref = _storageInstance.ref().child('$folderName/$fileName');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  /// Get download URL
  @override
  Future<String> getFileUrl({
    required String folderName,
    required String fileName,
  }) async {
    final ref = _storageInstance.ref().child('$folderName/$fileName');
    return await ref.getDownloadURL();
  }

  /// Delete file
  @override
  Future<void> deleteFile({
    required String folderName,
    required String fileName,
  }) async {
    final ref = _storageInstance.ref().child('$folderName/$fileName');
    await ref.delete();
  }

  /// Update (replace) file
  @override
  Future<String> updateFile({
    required File newFile,
    required String folderName,
    required String fileName,
  }) async {
    final ref = _storageInstance.ref().child('$folderName/$fileName');
    await ref.putFile(newFile, SettableMetadata(contentType: 'image/png'));
    return await ref.getDownloadURL();
  }
}
