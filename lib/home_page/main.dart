import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:provider/provider.dart';

class HomePageScreenContent extends StatelessWidget {
  const HomePageScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<MainProvider>();
    return provider.loaded
        ? Text("ok")
        : Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator.adaptive(),
          );
  }
}
