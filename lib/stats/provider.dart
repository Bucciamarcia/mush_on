import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';

class StatsProvider with ChangeNotifier {
  List<TeamGroup> _teams = [];
  List<TeamGroup> get teams => _teams;

  StatsProvider() {
    fetchTeams();
  }

  void fetchTeams() async {
    // Replace with your actual data source
    String account = await FirestoreService().getUserAccount() ?? "";
    FirebaseFirestore.instance
        .collection("accounts/$account/data/teams/history")
        .snapshots()
        .listen((snapshot) {
      _teams =
          snapshot.docs.map((doc) => TeamGroup.fromJson(doc.data())).toList();
      notifyListeners();
    });
  }
}
