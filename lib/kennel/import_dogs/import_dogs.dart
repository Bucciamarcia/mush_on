import 'package:flutter/material.dart';
import 'package:mush_on/kennel/import_dogs/main.dart';
import 'package:mush_on/page_template.dart';

class ImportDogsScreen extends StatelessWidget {
  const ImportDogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateScreen(
      title: "Import dogs from file",
      child: ImportDogsMain(),
    );
  }
}
