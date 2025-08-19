// Repository for things related to the UserName class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/username.dart';

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
    try {
      final data = await avatarPath.getData();
      return data;
    } catch (e, s) {
      BasicLogger().error("Couldn't read data", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteAvatar(String uid) async {
    String path = "users/$uid/avatar";
    try {
      final child = ref.child(path);
      final result = await child.listAll();
      for (Reference r in result.items) {
        await r.delete();
      }
    } catch (e, s) {
      logger.error("Error deleting avatar for user $uid",
          error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Updates the avatar of the user
  Future<void> writeAvatar(Uint8List data, String fileName, String uid) async {
    String path = "users/$uid/avatar";
    try {
      final child = ref.child(path);
      final result = await child.listAll();
      for (Reference r in result.items) {
        await r.delete();
      }
    } catch (e, s) {
      logger.error("Error deleting old avatar for user $uid:",
          error: e, stackTrace: s);
      rethrow;
    }
    final child = ref.child("$path/$fileName");
    try {
      await child.putData(data);
    } catch (e, s) {
      logger.error("Error uploading avatar for user $uid:",
          error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> setUsername(UserName username) async {
    String uid = username.uid;
    String path = "users/$uid";
    final db = FirebaseFirestore.instance;
    try {
      await db.doc(path).set(username.toJson());
    } catch (e, s) {
      logger.error("Error setting username for user $uid:",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}
