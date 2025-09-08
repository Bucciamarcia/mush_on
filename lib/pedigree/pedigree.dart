import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'main.dart';

class PedigreeScreen extends StatelessWidget {
  const PedigreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateScreen(
      title: "Pedigree view",
      child: PedigreeCanvas(),
    );
  }
}
