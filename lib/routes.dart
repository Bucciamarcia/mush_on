import 'package:flutter/material.dart';
import 'package:mush_on/create_team/create_team.dart';
import 'package:mush_on/kennel/add_dog/add_dog.dart';
import 'package:mush_on/kennel/dog/dog.dart';
import 'package:mush_on/kennel/edit_kennel.dart';
import 'package:mush_on/main.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/settings/settings.dart';
import 'package:mush_on/teams_history/teams_history.dart';
import 'package:mush_on/stats/stats.dart';

BasicLogger logger = BasicLogger();
var appRoutes = {
  "/": (context) => const HomeScreen(),
  "/editkennel": (context) => const EditKennelScreen(),
  "/dog": (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Dog) {
      return DogScreen(dog: args);
    } else {
      final errorMessage =
          "Invalid or null arguments provided for /dog route. Expected Dog, got: ${args?.runtimeType}";
      logger.error(errorMessage);
      throw Exception(errorMessage);
    }
  },
  "/adddog": (context) => const AddDogScreen(),
  "/createteam": (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    TeamGroup? teamGroup;
    if (args is TeamGroup) {
      teamGroup = args;
    }
    return CreateTeamScreen(loadedTeam: teamGroup);
  },
  "/teamshistory": (context) => const TeamsHistoryScreen(),
  "/stats": (context) => const StatsScreen(),
  "/settings": (context) => const SettingsScreen()
};
