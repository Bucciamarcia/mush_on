import 'package:flutter/material.dart';
import 'package:mush_on/create_team/create_team.dart';
import 'package:mush_on/edit_kennel/add_dog/add_dog.dart';
import 'package:mush_on/edit_kennel/edit_kennel.dart';
import 'package:mush_on/main.dart';
import 'package:mush_on/teams_history/teams_history.dart';

var appRoutes = {
  "/": (context) => const HomeScreen(),
  "/editkennel": (context) => const EditKennelScreen(),
  "/adddog": (context) => const AddDogScreen(),
  "/createteam": (context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    // Try to cast safely and log the result
    Map<String, dynamic>? mapArgs;
    mapArgs = args as Map<String, dynamic>?;

    return CreateTeamScreen(loadedTeam: mapArgs);
  },
  "/teamshistory": (context) => const TeamsHistoryScreen(),
};
