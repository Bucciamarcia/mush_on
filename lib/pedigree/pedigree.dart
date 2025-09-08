import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/services/models.dart';
import 'main.dart';

class PedigreeScreen extends StatelessWidget {
  final Dog dog;
  const PedigreeScreen({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(
      title: "Pedigree view: ${dog.name}",
      child: PedigreeCanvas(dog: dog),
    );
  }
}
