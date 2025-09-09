import 'package:go_router/go_router.dart';
import 'package:mush_on/create_team/create_team.dart';
import 'package:mush_on/customer_facing/booking_page.dart';
import 'package:mush_on/customer_management/tours/tours.dart';
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
import 'package:mush_on/whiteboard/whiteboard.dart';
import 'customer_management/customer_management.dart';
import 'customer_management/tours/editor/editor.dart';

final goRoutes = GoRouter(
  routes: [
    GoRoute(
      name: "/",
      path: "/",
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: "/editkennel",
      path: "/editkennel",
      builder: (context, state) => const EditKennelScreen(),
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
      builder: (context, state) => const AddDogScreen(),
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
      builder: (context, state) => const TeamsHistoryScreen(),
    ),
    GoRoute(
      name: "/stats",
      path: "/stats",
      builder: (context, state) => const StatsScreen(),
    ),
    GoRoute(
      name: "/settings",
      path: "/settings",
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      name: "/tasks",
      path: "/tasks",
      builder: (context, state) => const TasksScreen(),
    ),
    GoRoute(
      name: "/health_dashboard",
      path: "/health_dashboard",
      builder: (context, state) => const HealthScreen(),
    ),
    GoRoute(
      name: "/insights",
      path: "/insights",
      builder: (context, state) => const InsightsScreen(),
    ),
    GoRoute(
      name: "/client_management",
      path: "/client_management",
      builder: (context, state) => const ClientManagementScreen(),
    ),
    GoRoute(
      path: "/tours",
      name: "/tours",
      builder: (context, state) => const ToursScreen(),
    ),
    GoRoute(
      path: "/tours/editor",
      name: "/tours_add",
      builder: (context, state) {
        String? tourId = state.uri.queryParameters["tourId"];
        return AddTourScreen(tourId: tourId);
      },
    ),
    GoRoute(
      path: "/whiteboard",
      name: "/whiteboard",
      builder: (context, state) => const WhiteboardScreen(),
    ),
    GoRoute(
        path: "/booking",
        name: "/booking",
        builder: (context, state) {
          String? account = state.uri.queryParameters["kennel"];
          String? tourId = state.uri.queryParameters["tourId"];
          return BookingPage(account: account, tourId: tourId);
        }),
  ],
);
