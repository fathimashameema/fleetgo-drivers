import 'dart:io';

abstract class StorageRepo {
  Future<String> uploadFile({
    required File file,
    required String folderName,
    required String fileName,
  });

  Future<String> getFileUrl({
    required String folderName,
    required String fileName,
  });

  Future<void> deleteFile({
    required String folderName,
    required String fileName,
  });

  Future<String> updateFile({
    required File newFile,
    required String folderName,
    required String fileName,
  });

  Future<void> deleteUserDocument(String floder);
}
