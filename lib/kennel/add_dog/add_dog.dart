import 'package:flutter/material.dart';
import 'package:mush_on/kennel/add_dog/main.dart';
import 'package:mush_on/kennel/add_dog/provider.dart';
import 'package:mush_on/page_template.dart';
import 'package:provider/provider.dart';

class AddDogScreen extends StatelessWidget {
  const AddDogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          final provider = AddDogProvider();
          provider.init();
          return provider;
        },
        child: TemplateScreen(title: "Add a Dog", child: AddDogMain()));
  }
}
