import 'package:flutter/material.dart';
import 'package:mush_on/edit_kennel/main.dart';
import 'package:mush_on/page_template.dart';

class EditKennelScreen extends StatelessWidget {
  const EditKennelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateScreen(title: "Edit Kennel", child: EditKennelMain());
  }
}
