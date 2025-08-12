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
    final toReturn = <Uint8List>[];
    final account = await ref.watch(accountProvider.future);
    final storage = FirebaseStorage.instance;

    // ---- Avatar ----
    try {
      final dogRef = storage.ref("accounts/$account/dogs/$dogId");
      final result = await dogRef.listAll();

      if (result.items.isEmpty) {
        BasicLogger().error("No avatar found in $dogId root folder");
      } else {
        final avatarRef = result.items.first;

        try {
          final bytes = await avatarRef.getData();
          if (bytes != null) toReturn.add(bytes);
        } catch (e, s) {
          BasicLogger()
              .error("Couldn't get dog avatar", error: e, stackTrace: s);
        }
      }
    } catch (e, s) {
      BasicLogger()
          .error("Couldn't list avatar folder", error: e, stackTrace: s);
    }

    // ---- Customer-facing pics (parallel, throttled) ----
    try {
      final cRef =
          storage.ref("accounts/$account/dogs/$dogId/customer_facing_pics");
      final cResult = await cRef.listAll();

      final pics = cResult.items;

      const concurrency = 6;
      for (var i = 0; i < pics.length; i += concurrency) {
        final slice = pics.skip(i).take(concurrency).toList();
        final futures = slice.map((p) async {
          try {
            final data = await p.getData();
            if (data == null) {
              BasicLogger().error("Received null data for ${p.fullPath}");
            }
            return data;
          } catch (e, s) {
            BasicLogger().error(
              "Couldn't get customer pic ${p.fullPath}",
              error: e,
              stackTrace: s,
            );
            return null;
          }
        }).toList();

        final batch = await Future.wait(futures, eagerError: false);
        toReturn.addAll(batch.whereType<Uint8List>());
      }
    } catch (e, s) {
      BasicLogger().error(
        "Couldn't list customer-facing pics",
        error: e,
        stackTrace: s,
      );
    }

    return toReturn;
  }
}
