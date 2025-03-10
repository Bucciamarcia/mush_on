import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeamsHistoryProvider extends ChangeNotifier {
  List _groups = [];
  List get groups => _groups;

  TeamsHistoryProvider() {
    _fetchGroups();
  }

  void _fetchGroups() {
    FirebaseFirestore.instance
        .collection("data/teams/history")
        .snapshots()
        .listen((snapshot) {
      _groups = snapshot.docs.map((doc) => doc.data()).toList();

      _groups.sort((a, b) {
        int timestampA = a['date']?.seconds ?? 0;
        int timestampB = b['date']?.seconds ?? 0;

        return timestampB.compareTo(timestampA);
      });

      notifyListeners();
    });
  }
}
