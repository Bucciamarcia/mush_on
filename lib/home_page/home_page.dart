import 'package:flutter/material.dart';
import 'package:mush_on/home_page/main.dart';
import 'package:mush_on/home_page/provider.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/provider.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = context.watch<MainProvider>();
    return ChangeNotifierProvider(
      create: (context) {
        return HomePageProvider(mainProvider);
      },
      child: TemplateScreen(title: "Mush on!", child: HomePageScreenContent()),
    );
  }
}
