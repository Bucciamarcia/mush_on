import 'package:flutter/material.dart';
import 'package:mush_on/edit_kennel/main.dart';
import 'package:mush_on/edit_kennel/provider.dart';
import 'package:mush_on/page_template.dart';
import 'package:provider/provider.dart';

class EditKennelScreen extends StatelessWidget {
  const EditKennelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => KennelProvider(),
        child: TemplateScreen(title: "Edit Kennel", child: EditKennelMain()));
  }
}
