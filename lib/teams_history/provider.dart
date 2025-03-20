import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';

class TeamsHistoryProvider extends ChangeNotifier {
  List<TeamGroup> _groupObjects = [];
  List<TeamGroup> get groupObjects => _groupObjects;

  TeamsHistoryProvider() {
    _fetchGroupObjects();
  }

  Future<void> _fetchGroupObjects() async {
    String account = await FirestoreService().getUserAccount() ?? "";
    String path = "accounts/$account/data/teams/history";
    FirebaseFirestore.instance.collection(path).snapshots().listen((snapshot) {
      _groupObjects =
          snapshot.docs.map((doc) => TeamGroup.fromJson(doc.data())).toList();

      _groupObjects.sort((a, b) => b.date.compareTo(a.date));

      notifyListeners();
    });
  }
}
