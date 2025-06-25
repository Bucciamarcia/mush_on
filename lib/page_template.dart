import 'package:flutter/material.dart';
import 'package:mush_on/services/auth.dart';

class TemplateScreen extends StatelessWidget {
  final Widget child;
  final String title;

  const TemplateScreen({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
