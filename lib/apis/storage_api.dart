import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/consts/appwrite_const.dart';
import 'package:twichat/consts/appwrite_provider.dart';

abstract class IStorageAPI {
  Future<List<String>> uploadImages(List<File> files);
  Future<String> uploadImage(File files);
}

final storageAPIProvider = Provider((ref) {
  return StorageAPI(storage: ref.watch(appwriteStorageProvider));
});

class StorageAPI implements IStorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  @override
  Future<List<String>> uploadImages(List<File> files) async {
    List<String> imageUrls = [];
    for (final file in files) {
      final res = await _storage.createFile(
        bucketId: AppwriteConsts.bucketID,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      imageUrls.add(AppwriteConsts.imagUrls(res.$id));
    }
    return imageUrls;
  }

  @override
  Future<String> uploadImage(File file) async {
    final res = await _storage.createFile(
      bucketId: AppwriteConsts.bucketID,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: file.path),
    );
    String url = AppwriteConsts.imagUrls(res.$id);
    return url;
  }
}
