import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'models.dart';
part 'riverpod.g.dart';

@Riverpod(keepAlive: true)
Stream<ResellerData?> resellerData(Ref ref) async* {
  final User? user = await ref.watch(userProvider.future);
  if (user == null) {
    throw Exception("User is not logged in");
  }
  final db = FirebaseFirestore.instance;
  final path = "users/${user.uid}/reseller/data";
  final docRef = db.doc(path);
  yield* docRef.snapshots().map((snapshot) {
    final data = snapshot.data();
    if (data == null) {
      return null;
    }
    return ResellerData.fromJson(data);
  });
}
