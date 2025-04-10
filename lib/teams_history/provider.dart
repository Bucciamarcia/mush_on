import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';

class TeamsHistoryProvider extends ChangeNotifier {
  List<TeamGroup> _groupObjects = [];
  List<TeamGroup> get groupObjects => _groupObjects;

  Map<String, Dog> _dogIdMaps = {};
  Map<String, Dog> get dogIdMaps => _dogIdMaps;

  final List<bool> _isLoading = [false, false];

  TeamsHistoryProvider() {
    _fetchGroupObjects();
    _fetchAllDogsById();
  }

// Member variable to hold the subscription
  StreamSubscription? _teamHistorySubscription;

  Future<void> _fetchGroupObjects() async {
    // Cancel previous subscription if exists (prevents leaks on hot reload/re-init)
    await _teamHistorySubscription?.cancel();
    _teamHistorySubscription = null; // Reset

    _isLoading[0] = true;
    notifyListeners(); // Notify UI that initial loading has started

    String account =
        await FirestoreService().getUserAccount(); // Handle potential null
    String path = "accounts/$account/data/teams/history";

    _teamHistorySubscription = FirebaseFirestore.instance
        .collection(path)
        .snapshots()
        .listen((snapshot) {
      // --- Successfully received data (could be initial or update) ---
      _groupObjects =
          snapshot.docs.map((doc) => TeamGroup.fromJson(doc.data())).toList();
      _groupObjects.sort((a, b) => b.date.compareTo(a.date));

      // If we were waiting for the initial load, mark it as complete
      if (_isLoading[0]) {
        _isLoading[0] = false;
      }
      notifyListeners(); // Update UI with new data and potentially new loading state
    }, onError: (error) {
      // --- Stream encountered an error ---
      print("Error fetching team history: $error");
      // Also mark initial loading as complete (with error) if it was ongoing
      if (_isLoading[0]) {
        _isLoading[0] = false;
      }
      // TODO: Consider setting an error flag/message in the provider
      notifyListeners(); // Notify UI about the error/loading state change
      // Optional: Cancel subscription on error? Depends if you want to retry.
      // _teamHistorySubscription?.cancel();
    }, onDone: () {
      // --- Stream closed (rarely happens with Firestore unless rules change etc.) ---
      if (_isLoading[0]) {
        _isLoading[0] = false;
      }
      notifyListeners();
    });
    // Note: _isLoading[0] remains true here until the *first* event (data/error/done) arrives in the listener.
  }

  Future<void> _fetchAllDogsById() async {
    _isLoading[1] = true;
    notifyListeners();
    try {
      _dogIdMaps = await DogsDbOperations().getAllDogsById();
    } finally {
      _isLoading[1] = false;
      notifyListeners();
    }
  }

  bool isLoading() {
    if (_isLoading[0] == false && _isLoading[1] == false) {
      return false;
    } else {
      return true;
    }
  }
}
