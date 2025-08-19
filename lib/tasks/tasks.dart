import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'main.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateScreen(title: "Tasks", child: TasksMainWidget());
  }
}
