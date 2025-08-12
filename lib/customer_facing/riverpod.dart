import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod
class CustomerDogPhotos extends _$CustomerDogPhotos {
  @override
  Future<List<Uint8List>> build(String dogId) async {
    List<Uint8List> toReturn = [];
    String account = await ref.watch(accountProvider.future);
    final i = FirebaseStorage.instance;
    final dogRef = i.ref("accounts/$account/dogs/$dogId");
    ListResult result;
    try {
      result = await dogRef.listAll();
    } catch (e, s) {
      BasicLogger().error("Couldn't get avatar", error: e, stackTrace: s);
      return toReturn;
    }
    List<Reference> items = result.items;

    // There is only one pic in the folder, the dog's avatar
    Reference dogAvatarReference = items[0];
    Uint8List? dogAvatar;
    try {
      dogAvatar = await dogAvatarReference.getData();
    } catch (e, s) {
      BasicLogger().error("Couldn't get dog avatar", error: e, stackTrace: s);
      return toReturn;
    }
    if (dogAvatar != null) {
      toReturn.add(dogAvatar);
    }

    // Now process all the pics in the customer_facing_pics subfolder
    final cRef = i.ref("accounts/$account/dogs/$dogId/customer_facing_pics");
    ListResult cResult;
    try {
      cResult = await cRef.listAll();
    } catch (e, s) {
      BasicLogger()
          .error("Couldn't get customer facing pics", error: e, stackTrace: s);
      return toReturn;
    }
    for (var p in cResult.items) {
      try {
        final cData = await p.getData();
        if (cData != null) {
          toReturn.add(cData);
        } else {
          BasicLogger().error("Received null data for pic ${p.fullPath}");
        }
      } catch (e, s) {
        BasicLogger().error("Couldn't get customer facing pic ${p.fullPath}",
            error: e, stackTrace: s);
      }
    }
    return toReturn;
  }
}
