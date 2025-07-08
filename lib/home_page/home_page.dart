import 'package:flutter/material.dart';
import 'package:mush_on/home_page/main.dart';
import 'package:mush_on/page_template.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(title: "Mush on!", child: HomePageScreenContent());
  }
}
