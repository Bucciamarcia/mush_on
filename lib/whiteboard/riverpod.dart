import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/home_page/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod
Stream<List<WhiteboardElement>> permanentWhiteboardElements(Ref ref) async* {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/whiteboard/elements";
  final db = FirebaseFirestore.instance;
  final collection = db.collection(path);
  yield* collection.snapshots().map((snapshot) => snapshot.docs
      .map((doc) => WhiteboardElement.fromJson(doc.data()))
      .toList());
}
