import 'package:flutter/material.dart';
import 'package:mush_on/services/auth.dart';

class HomePageScreenContent extends StatelessWidget {
  const HomePageScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, "/createteam"),
            child: const Text(
              "Create Team",
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, "/editkennel"),
            child: const Text(
              "Kennel",
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, "/teamshistory"),
            child: const Text(
              "Teams history",
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, "/stats"),
            child: const Text(
              "Stats",
            ),
          ),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/tasks"),
              child: const Text("Tasks")),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/settings"),
              child: const Text("Settings")),
          ElevatedButton(
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            child: Text("Log out"),
          ),
        ],
      ),
    );
  }
}
