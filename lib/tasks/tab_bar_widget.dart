import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: [
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 3,
            children: [Icon(Icons.today), Text("Today")],
          ),
        ),
        Tab(
          child: Row(
            spacing: 3,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.question_mark), Text("Perm.")],
          ),
        ),
        Tab(
          child: Row(
            spacing: 3,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.calendar_today), Text("Cal")],
          ),
        ),
      ],
    );
  }
}
