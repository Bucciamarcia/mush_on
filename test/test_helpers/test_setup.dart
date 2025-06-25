import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/create_team/models.dart';
import 'mock_providers.mocks.dart';

/// Helper to set up mocks with sensible defaults
class TestSetup {
  static MockMainProvider createMainProvider({
    List<Dog>? dogs,
    Map<String, Dog>? dogsById,
    SettingsModel? settings,
    bool loaded = true,
    String account = "test-account",
  }) {
    final mock = MockMainProvider();
    
    when(mock.dogs).thenReturn(dogs ?? <Dog>[]);
    when(mock.dogsById).thenReturn(dogsById ?? <String, Dog>{});
    when(mock.settings).thenReturn(settings ?? SettingsModel());
    when(mock.loaded).thenReturn(loaded);
    when(mock.account).thenReturn(account);
    
    return mock;
  }

  static MockCreateTeamProvider createCreateTeamProvider({
    required MockMainProvider mainProvider,
    List<Dog>? dogs,
    Map<String, Dog>? dogsById,
    bool unsavedData = false,
    bool isFetchingDistance = false,
    List<String>? runningDogIds,
    TeamGroup? group,
    List<DogNote>? dogNotes,
  }) {
    final mock = MockCreateTeamProvider();
    
    when(mock.provider).thenReturn(mainProvider);
    when(mock.dogs).thenReturn(dogs ?? <Dog>[]);
    when(mock.dogsById).thenReturn(dogsById ?? <String, Dog>{});
    when(mock.unsavedData).thenReturn(unsavedData);
    when(mock.isFetchingDistance).thenReturn(isFetchingDistance);
    when(mock.runningDogIds).thenReturn(runningDogIds ?? <String>[]);
    when(mock.dogNotes).thenReturn(dogNotes ?? <DogNote>[]);
    when(mock.group).thenReturn(group ?? TeamGroup(
      teams: [Team(dogPairs: [DogPair(), DogPair()])],
      date: DateTime.now(),
    ));
    
    // Stub common methods that are called - these use named parameters
    when(mock.addRow(teamNumber: anyNamed('teamNumber'))).thenAnswer((_) {});
    when(mock.removeRow(teamNumber: anyNamed('teamNumber'), rowNumber: anyNamed('rowNumber'))).thenAnswer((_) {});
    when(mock.addTeam(teamNumber: anyNamed('teamNumber'))).thenAnswer((_) {});
    when(mock.removeTeam(teamNumber: anyNamed('teamNumber'))).thenAnswer((_) {});
    
    return mock;
  }
}