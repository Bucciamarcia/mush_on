// Repository for things related to the UserName class
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mush_on/services/error_handling.dart';

class UserNameRepository {
  final logger = BasicLogger();
  final ref = FirebaseStorage.instance.ref();

  /// Gets the bytes of the user avatar.
  Future<Uint8List?> getAvatar(String uid) async {
    final child = ref.child("users/$uid/avatar");
    final results = await child.listAll();
    List<String> fileNames = [];
    for (Reference r in results.items) {
      fileNames.add(r.name);
    }
    final fn = fileNames.first;
    final avatarPath = ref.child(fn);
    final data = await avatarPath.getData();
    return data;
  }

  /// Updates the avatar of the user
  Future<void> writeAvatar(File file, String uid) async {
    String path = "users/$uid/avatar";
    String extension = file.path.split('.').last;
    final child = ref.child("$path/$extension");
    try {
      await child.putFile(file);
    } catch (e, s) {
      logger.error("Error uploading avatar for user $uid:",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}
