import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models/teamgroup.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'teamgroup.g.dart';

@riverpod

/// Returns the TeamGroup element from its id from the db
Future<TeamGroup> teamGroupFromId(Ref ref, String id) async {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/teams/history";
  var db = FirebaseFirestore.instance;
  var collection = db.collection(path);
  var snapshot = await collection.where("id", isEqualTo: id).get();
  var doc = snapshot.docs.first;
  return TeamGroup.fromJson(doc.data());
}
