import 'package:flutter/material.dart';
import 'package:mush_on/kennel/main.dart';
import 'package:mush_on/page_template.dart';

class EditKennelScreen extends StatelessWidget {
  const EditKennelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(title: "Kennel", child: EditKennelMain());
  }
}
