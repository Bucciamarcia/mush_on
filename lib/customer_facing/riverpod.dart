import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'models.dart';
part 'riverpod.g.dart';

@riverpod
class CustomerDogPhotos extends _$CustomerDogPhotos {
  @override
  Future<List<DogPhoto>> build(
      {required String dogId, required bool includeAvatar}) async {
    final toReturn = <DogPhoto>[];
    final account = await ref.watch(accountProvider.future);
    final storage = FirebaseStorage.instance;

    // ---- Avatar ----
    if (includeAvatar) {
      try {
        final dogRef = storage.ref("accounts/$account/dogs/$dogId");
        final result = await dogRef.listAll();

        if (result.items.isEmpty) {
          BasicLogger().error("No avatar found in $dogId root folder");
        } else {
          final avatarRef = result.items.first;

          try {
            final bytes = await avatarRef.getData();
            if (bytes != null) {
              toReturn.add(
                DogPhoto(
                  fileName: avatarRef.name,
                  data: bytes,
                  isAvatar: true,
                ),
              );
            }
          } catch (e, s) {
            BasicLogger()
                .error("Couldn't get dog avatar", error: e, stackTrace: s);
          }
        }
      } catch (e, s) {
        BasicLogger()
            .error("Couldn't list avatar folder", error: e, stackTrace: s);
      }
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
            return DogPhoto(fileName: p.name, data: data!, isAvatar: false);
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
        toReturn.addAll(batch.whereType<DogPhoto>());
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

  void addPicture(File pic) {
    state = state.whenData(
      (data) => data = [
        ...data,
        DogPhoto(
            fileName: path.basename(pic.path),
            data: pic.readAsBytesSync(),
            isAvatar: false)
      ],
    );
  }

  void removePicture(String fileName) {
    state = state.whenData(
      (data) {
        List<DogPhoto> newData = [];
        for (var d in data) {
          if (d.fileName != fileName) {
            newData.add(d);
          }
        }
        return newData;
      },
    );
  }
}

@riverpod
Stream<DogCustomerFacingInfo?> dogCustomerFacingInfo(Ref ref,
    {required String dogId, required String account}) async* {
  String path = "customerFacing/$account/dogInfo/$dogId";
  final db = FirebaseFirestore.instance;
  final doc = db.doc(path);
  yield* doc.snapshots().map(
    (snapshot) {
      if (snapshot.data() != null) {
        BasicLogger().debug("Received dog customer info for $dogId");
        BasicLogger().debug("Description: ${snapshot.data()?['description']}");
        return DogCustomerFacingInfo.fromJson(
          snapshot.data()!,
        );
      } else {
        BasicLogger().debug("No dog customer info found for $dogId");
        return null;
      }
    },
  );
}
