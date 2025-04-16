import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';

class StatsProvider with ChangeNotifier {
  ///Ordered by date descending.
  List<TeamGroup> teams = [];
  List<Dog> dogs = [];

  StatsProvider() {
    getTeams();
  }

  /// Fetches the teams from Firestore
  /// If [cutOff] is provided, only fetches teams after that date
  /// Ordered by date descending
  Future<void> getTeams({DateTime? cutOff}) async {
    String account = await FirestoreService().getUserAccount();
    FirebaseFirestore db = FirebaseFirestore.instance;

    Query<Map<String, dynamic>> ref =
        db.collection("accounts/$account/data/teams/history");

    if (cutOff != null) {
      ref = ref.where("date", isGreaterThan: cutOff);
    }

    ref.snapshots().listen((snapshot) {
      final newTeams =
          snapshot.docs.map((doc) => TeamGroup.fromJson(doc.data())).toList();

      // Sort the teams by date inside the callback
      newTeams.sort((a, b) => b.date.compareTo(a.date));

      // Update the teams list and notify listeners inside the callback
      teams = newTeams;
      notifyListeners();
    });
  }
}
