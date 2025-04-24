import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mush_on/services/error_handling.dart';

class StorageService {
  final FirebaseStorage instance = FirebaseStorage.instance;
  BasicLogger logger = BasicLogger();
  Future<void> uploadFromFile({
    required File file,

    /// The full path of the file in storage, including filename and ext,
    /// e.g. `images/avatar.png`
    required String path,
  }) async {
    var ref = instance.ref().child(path);
    try {
      await ref.putFile(file);
      logger.info("File uploaded to storage");
    } catch (e, s) {
      logger.error("Couldn't upload file to storage", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Returns the content of a single file in storage given its path.
  Future<Uint8List?> getFile(String path) async {
    try {
      var ref = instance.ref(path);
      return await ref.getData();
    } catch (e, s) {
      logger.error("Couldn't get file", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Deletes a file at the location. Include full path, eg. "images/file.png".
  Future<void> deleteFile(String path) async {
    var ref = instance.ref(path);
    try {
      await ref.delete();
    } catch (e, s) {
      logger.error("Couldn't delete file", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Returns a list of filenames, including extension, of all the files in a folder.
  /// eg. `["file1.png", "file2.png"]`
  Future<List<String>> listFilesInFolder(String path) async {
    try {
      var ref = instance.ref(path);
      ListResult listFiles = await ref.listAll();
      List<String> toReturn = [];
      for (var item in listFiles.items) {
        toReturn.add(item.name);
      }
      return toReturn;
    } catch (e, s) {
      logger.error("Couldn't list files in folder", error: e, stackTrace: s);
      rethrow;
    }
  }
}
