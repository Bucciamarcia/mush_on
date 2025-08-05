import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'main.dart';

class AddTourScreen extends StatelessWidget {
  const AddTourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(title: "Add tour", child: TourEditorMain());
  }
}
