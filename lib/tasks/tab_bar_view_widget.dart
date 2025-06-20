import 'package:flutter/material.dart';

class TabBarViewWidget extends StatelessWidget {
  const TabBarViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Text("1"),
        Text("2"),
      ],
    );
  }
}
