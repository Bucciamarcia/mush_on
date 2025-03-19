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
              "Edit kennel",
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, "/teamshistory"),
            child: const Text(
              "Teams history",
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService().signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text("Log out"),
          )
        ],
      ),
    );
  }
}
