import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user.g.dart';

@riverpod
class UserProfilePic extends _$UserProfilePic {
  @override
  Future<Uint8List?> build(String? uid) async {
    late String path;
    if (uid == null) {
      final u = await ref.watch(userProvider.future);
      if (u == null) {
        BasicLogger().warning("Uid is null");
        return null;
      }
      path = "users/${u.uid}/avatar";
    } else {
      path = "users/$uid/avatar";
    }
    final storageRef = FirebaseStorage.instance.ref(path);
    late ListResult result;
    try {
      result = await storageRef.listAll();
    } catch (e, s) {
      BasicLogger().error("Failed to list items in storage at path: $path",
          error: e, stackTrace: s);
      return null;
    }
    final items = result.items;
    if (items.isEmpty) {
      BasicLogger().warning("empty");
      return null;
    }
    final avatarPath = result.items.first;
    try {
      return await avatarPath.getData();
    } catch (e, s) {
      BasicLogger().error("Failed to get data from storage at path: $path",
          error: e, stackTrace: s);
      return null;
    }
  }

  void changeProfilePic(Uint8List newData) {
    state = state.whenData((data) {
      return newData;
    });
  }

  void removeProfilePic() {
    state = state.whenData((data) {
      return null;
    });
  }
}
