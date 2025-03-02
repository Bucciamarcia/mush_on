import 'package:flutter/material.dart';
import 'package:mush_on/edit_kennel/add_dog/main.dart';
import 'package:mush_on/edit_kennel/add_dog/provider.dart';
import 'package:mush_on/page_template.dart';
import 'package:provider/provider.dart';

class AddDogScreen extends StatelessWidget {
  const AddDogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AddDogProvider(),
        child: TemplateScreen(title: "Add a Dog", child: AddDogMain()));
  }
}
