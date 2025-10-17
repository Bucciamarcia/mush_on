import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mush_on/customer_management/tours/main.dart';
import 'package:mush_on/health/main.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/kennel/main.dart';
import 'package:mush_on/login_screen/login_screen.dart';
import 'package:mush_on/services/auth.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'customer_management/main.dart';
import 'riverpod.dart';

class TemplateScreen extends ConsumerWidget {
  final Widget child;
  final String title;

  /// Minimum user level for the user level to access this page.
  final UserLevel minUserRank;

  const TemplateScreen(
      {super.key,
      required this.child,
      required this.title,
      this.minUserRank = UserLevel.guest});

  Widget? _getFab(BuildContext context, WidgetRef ref) {
    if (child is HealthMain) {
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.local_hospital),
            label: 'Add health event',
            onTap: () {
              ref.read(triggerAddhealthEventProvider.notifier).setValue(true);
            },
          ),
          SpeedDialChild(
            child: const FaIcon(FontAwesomeIcons.syringe),
            label: 'Add vaccination',
            onTap: () {
              ref.read(triggerAddVaccinationProvider.notifier).setValue(true);
            },
          ),
          SpeedDialChild(
            child: const FaIcon(FontAwesomeIcons.fire),
            label: 'Add heat',
            onTap: () {
              ref.read(triggerAddHeatCycleProvider.notifier).setValue(true);
            },
          ),
        ],
      );
    }
    if (child is ClientManagementMainScreen) {
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.people_alt),
              label: "Add Customer Group",
              onTap: () => context.pushNamed("/add_customer_group")),
          SpeedDialChild(
              child: const FaIcon(FontAwesomeIcons.calendarPlus),
              label: "Mass add Customer Groups",
              onTap: () => context.pushNamed("/mass_add_cg"))
        ],
      );
    }
    if (child is EditKennelMain) {
      return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.pushNamed("/adddog");
        },
      );
    }
    if (child is ToursMainScreen) {
      return FloatingActionButton(
        onPressed: () => context.pushNamed("/tours_add"),
        child: const Icon(Icons.add),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(userProvider);
    return authState.when(
      error: (e, s) {
        BasicLogger().error("Couldn't get auth state in template",
            error: e, stackTrace: s);
        return const Scaffold(
          body: Text(
              "Error in getting user. This shouldn't happen: contact an admin."),
        );
      },
      loading: () => const CircularProgressIndicator.adaptive(),
      data: (data) {
        if (data == null) {
          return const LoginScreen();
        } else {
          final userNameAsync = ref.watch(userNameProvider(data.uid));
          return userNameAsync.when(
              data: (userName) {
                if (userName == null) {
                  return const Text("Error: username not valid");
                }
                if (userName.userLevel.rank < minUserRank.rank) {
                  return const Scaffold(
                    body: Text("You don't have access to this page."),
                  );
                }
                return Scaffold(
                  floatingActionButton: _getFab(context, ref),
                  drawer: Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        DrawerHeader(
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                          child: Text("Menu",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer)),
                        ),
                        ListTile(
                          leading: const Icon(Icons.home),
                          onTap: () => context.pushNamed("/"),
                          title: const Text("Home"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          onTap: () => context.pushNamed("/whiteboard"),
                          title: const Text("Whiteboard"),
                        ),
                        const Divider(),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                          child: Text(
                            "Dogs and teams",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.group_add),
                          onTap: () => context.pushNamed("/createteam"),
                          title: const Text(
                            "Create Team",
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.pets),
                          onTap: () => context.pushNamed("/editkennel"),
                          title: const Text(
                            "Kennel",
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.history),
                          onTap: () => context.pushNamed("/teamshistory"),
                          title: const Text(
                            "Teams history",
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                          child: Text(
                            "Booking manager",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person_2),
                          onTap: () => context.pushNamed("/client_management"),
                          title: const Text(
                            "Manage bookings",
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.tour),
                          onTap: () => context.pushNamed("/tours"),
                          title: const Text(
                            "Tours",
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                          child: Text(
                            "Data",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.query_stats),
                          onTap: () => context.pushNamed("/stats"),
                          title: const Text(
                            "Stats",
                          ),
                        ),
                        ListTile(
                          leading: const FaIcon(
                              FontAwesomeIcons.magnifyingGlassChart),
                          onTap: () => context.pushNamed("/insights"),
                          title: const Text(
                            "Insights",
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                          child: Text(
                            "Other",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.task),
                          onTap: () => context.pushNamed("/tasks"),
                          title: const Text(
                            "Tasks",
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          onTap: () => context.pushNamed("/settings"),
                          title: const Text(
                            "Settings",
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.health_and_safety),
                          onTap: () => context.pushNamed("/health_dashboard"),
                          title: const Text(
                            "Health dashboard",
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          onTap: () async {
                            await AuthService().signOut();
                          },
                          title: const Text(
                            "Log out",
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                  appBar: AppBar(
                    title: Text(title),
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                  ),
                  body: SafeArea(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: child,
                  )),
                );
              },
              error: (e, s) {
                BasicLogger()
                    .error("Couldn't fetch username", error: e, stackTrace: s);
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("Error"),
                    backgroundColor:
                        Theme.of(context).colorScheme.errorContainer,
                  ),
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Unable to Load User Data",
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "There was a problem loading your user information. This could be a temporary connection issue. Try reloading the page.",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton.icon(
                            onPressed: () async {
                              // Force a provider refresh
                              ref.invalidate(userNameProvider(data.uid));
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text("Retry"),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () async {
                              await AuthService().signOut();
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text("Sign Out"),
                          ),
                          const SizedBox(height: 24),
                          ExpansionTile(
                            title: const Text("Error Details"),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SelectableText(
                                  e.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontFamily: 'monospace',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator.adaptive());
        }
      },
    );
  }
}
