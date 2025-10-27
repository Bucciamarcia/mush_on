import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/resellers/invite_resellers/repository.dart';
import 'package:mush_on/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod
Stream<Reseller?> reseller(Ref ref) async* {
  final user = await ref.watch(userProvider.future);
  if (user == null) {
    yield null;
    return;
  }
  final uid = user.uid;
  final db = FirebaseFirestore.instance;
  final path = "users/$uid";
  final doc = db.doc(path);
  yield* doc.snapshots().map((snapshot) {
    final data = snapshot.data();
    if (data == null) {
      return null;
    }
    return Reseller.fromJson(data);
  });
}
