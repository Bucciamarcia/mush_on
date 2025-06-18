import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TasksProvider(),
        child: const TemplateScreen(title: "Tasks", child: TasksMainWidget()));
  }
}
