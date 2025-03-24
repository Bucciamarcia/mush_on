import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';

class StatsProvider with ChangeNotifier {
  List<TeamGroup> teams = [];
  List<Dog> dogs = [];

  StatsProvider() {
    getTeams();
  }

  /// Fetches the teams from Firestore
  /// If [cutOff] is provided, only fetches teams after that date
  /// Ordered by date descending

  Future<void> getTeams({DateTime? cutOff}) async {
    if (cutOff == null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      String account = await FirestoreService().getUserAccount() ?? "";
      var ref = db.collection("accounts/$account/data/teams/history");
      var snapshot = await ref.get();
      var data = snapshot.docs.map((s) => s.data());
      var newTeams = data.map((d) => TeamGroup.fromJson(d)).toList();
      newTeams.sort((a, b) => b.date.compareTo(a.date));
      teams = newTeams;
      notifyListeners();
    } else {
      FirebaseFirestore db = FirebaseFirestore.instance;
      String account = await FirestoreService().getUserAccount() ?? "";
      var ref = db
          .collection("accounts/$account/data/teams/history")
          .where("date", isGreaterThan: cutOff);
      var snapshot = await ref.get();
      var data = snapshot.docs.map((s) => s.data());
      var newTeams = data.map((d) => TeamGroup.fromJson(d)).toList();
      newTeams.sort((a, b) => b.date.compareTo(a.date));
      teams = newTeams;
      notifyListeners();
    }
  }
}
