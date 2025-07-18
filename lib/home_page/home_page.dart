import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/home_page/main.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/shared/add_id_to_teamgroup/main.dart';

class HomePageScreen extends ConsumerWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAccount = ref.watch(accountProvider);
    return asyncAccount.when(
      data: (account) {
        return FutureBuilder(
          future: addIdToTeamgroups(account),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator.adaptive();
            } else if (snapshot.hasError) {
              return Text("Error in database.");
            } else if (snapshot.connectionState == ConnectionState.done) {
              return TemplateScreen(
                  title: "Kennel", child: HomePageScreenContent());
            } else {
              return Text("Unknown state.");
            }
          },
        );
      },
      error: (e, s) => Text("Error getting account"),
      loading: () => CircularProgressIndicator.adaptive(),
    );
  }
}
