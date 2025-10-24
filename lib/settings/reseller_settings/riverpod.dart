import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/resellers/models.dart' show ResellerSettings;
import 'package:mush_on/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod
Stream<ResellerSettings> resellerSettings(Ref ref) async* {
  final account = await ref.watch(accountProvider.future);
  final db = FirebaseFirestore.instance;
  final path = "accounts/$account/data/settings/resellers/settings";
  final docRef = db.doc(path);
  yield* docRef.snapshots().map((snapshot) {
    final data = snapshot.data();
    if (data == null) {
      return const ResellerSettings();
    } else {
      return ResellerSettings.fromJson(data);
    }
  });
}

@riverpod
class IsSaving extends _$IsSaving {
  @override
  bool build() {
    return false;
  }

  void change(bool v) {
    state = v;
  }
}
