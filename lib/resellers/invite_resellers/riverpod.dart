import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/resellers/invite_resellers/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod
Stream<ResellerInvitation?> resellerInvitation(Ref ref, String email) async* {
  final db = FirebaseFirestore.instance;
  final path = "resellerInvitations/$email";
  final doc = db.doc(path);
  yield* doc.snapshots().map((snapshot) {
    final data = snapshot.data();
    if (data == null) return null;
    return ResellerInvitation.fromJson(data);
  });
}
