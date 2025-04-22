import 'dart:io';

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
}
