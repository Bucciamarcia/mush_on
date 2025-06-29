import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mush_on/health/main.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/services/auth.dart';

class TemplateScreen extends ConsumerWidget {
  final Widget child;
  final String title;

  const TemplateScreen({super.key, required this.child, required this.title});

  SpeedDial? _getFab(WidgetRef ref) {
    if (child is HealthMain) {
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
            child: Icon(Icons.local_hospital),
            label: 'Add health event',
            onTap: () {
              ref.read(triggerAddhealthEventProvider.notifier).setValue(true);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.vaccines),
            label: 'Add vaccination',
            onTap: () {
              // Handle schedule
            },
          ),
          SpeedDialChild(
            child: FaIcon(FontAwesomeIcons.fire),
            label: 'Add heat',
            onTap: () {
              // Handle analytics
            },
          ),
        ],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: _getFab(ref),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer),
              child: Text("Menu",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onPrimaryContainer)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false),
              title: const Text("Home"),
            ),
            ListTile(
              leading: Icon(Icons.group_add),
              onTap: () => Navigator.pushNamed(context, "/createteam"),
              title: const Text(
                "Create Team",
              ),
            ),
            ListTile(
              leading: Icon(Icons.pets),
              onTap: () => Navigator.pushNamed(context, "/editkennel"),
              title: const Text(
                "Kennel",
              ),
            ),
            ListTile(
              leading: Icon(Icons.history),
              onTap: () => Navigator.pushNamed(context, "/teamshistory"),
              title: const Text(
                "Teams history",
              ),
            ),
            ListTile(
              leading: Icon(Icons.query_stats),
              onTap: () => Navigator.pushNamed(context, "/stats"),
              title: const Text(
                "Stats",
              ),
            ),
            ListTile(
              leading: Icon(Icons.task),
              onTap: () => Navigator.pushNamed(context, "/tasks"),
              title: const Text(
                "Tasks",
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              onTap: () => Navigator.pushNamed(context, "/settings"),
              title: const Text(
                "Settings",
              ),
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety),
              onTap: () => Navigator.pushNamed(context, "/health_dashboard"),
              title: const Text(
                "Health dashboard",
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              onTap: () async {
                await AuthService().signOut();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                }
              },
              title: const Text(
                "Log out",
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      )),
    );
  }
}
