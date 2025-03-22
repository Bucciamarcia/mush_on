import 'package:flutter/material.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/stats/services.dart';

class StatsProvider extends ChangeNotifier {
  List<TeamGroup> _teams = [];
  List<TeamGroup> get teams => _teams;
  
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  
  StatsProvider() {
    _fetchTeams();
  }

  Future<void> _fetchTeams() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _teams = await StatsDb().getTeamsAfterDate();
      print("STATS PROVIDER DATA LOADED: ${_teams.length} teams");
    } catch (e) {
      print("Error fetching teams: $e");
      // Handle error appropriately
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Add a method to refresh data when needed
  Future<void> refreshData() async {
    await _fetchTeams();
  }
}
