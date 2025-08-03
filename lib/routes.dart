import 'package:go_router/go_router.dart';
import 'package:mush_on/create_team/create_team.dart';
import 'package:mush_on/health/health.dart';
import 'package:mush_on/kennel/add_dog/add_dog.dart';
import 'package:mush_on/kennel/dog/dog.dart';
import 'package:mush_on/kennel/kennel.dart';
import 'package:mush_on/main.dart';
import 'package:mush_on/settings/settings.dart';
import 'package:mush_on/stats/insights/insights.dart';
import 'package:mush_on/tasks/tasks.dart';
import 'package:mush_on/teams_history/teams_history.dart';
import 'package:mush_on/stats/stats.dart';
import 'customer_management/customer_management.dart';

final goRoutes = GoRouter(
  routes: [
    GoRoute(
      name: "/",
      path: "/",
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      name: "/editkennel",
      path: "/editkennel",
      builder: (context, state) => EditKennelScreen(),
    ),
    GoRoute(
      name: "/dog",
      path: "/dog",
      builder: (context, state) {
        final dogId = state.uri.queryParameters["dogId"];
        return DogScreen(dog: dogId);
      },
    ),
    GoRoute(
      name: "/adddog",
      path: "/adddog",
      builder: (context, state) => AddDogScreen(),
    ),
    GoRoute(
      name: "/createteam",
      path: "/createteam",
      builder: (context, state) {
        final teamGroupId = state.uri.queryParameters["teamGroupId"];
        return CreateTeamScreen(loadedTeamId: teamGroupId);
      },
    ),
    GoRoute(
      name: "/teamshistory",
      path: "/teamshistory",
      builder: (context, state) => TeamsHistoryScreen(),
    ),
    GoRoute(
      name: "/stats",
      path: "/stats",
      builder: (context, state) => StatsScreen(),
    ),
    GoRoute(
      name: "/settings",
      path: "/settings",
      builder: (context, state) => SettingsScreen(),
    ),
    GoRoute(
      name: "/tasks",
      path: "/tasks",
      builder: (context, state) => TasksScreen(),
    ),
    GoRoute(
      name: "/health_dashboard",
      path: "/health_dashboard",
      builder: (context, state) => HealthScreen(),
    ),
    GoRoute(
      name: "/insights",
      path: "/insights",
      builder: (context, state) => InsightsScreen(),
    ),
    GoRoute(
      name: "/client_management",
      path: "/client_management",
      builder: (context, state) => ClientManagementScreen(),
    ),
  ],
);
