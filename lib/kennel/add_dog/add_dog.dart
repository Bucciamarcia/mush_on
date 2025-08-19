import 'package:flutter/material.dart';
import 'package:mush_on/kennel/add_dog/main.dart';
import 'package:mush_on/page_template.dart';

class AddDogScreen extends StatelessWidget {
  const AddDogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateScreen(title: "Add a Dog", child: AddDogMain());
  }
}
