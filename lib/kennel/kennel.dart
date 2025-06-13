import 'package:flutter/material.dart';
import 'package:mush_on/kennel/main.dart';
import 'package:mush_on/kennel/provider.dart';
import 'package:mush_on/page_template.dart';
import 'package:provider/provider.dart';

class EditKennelScreen extends StatelessWidget {
  const EditKennelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => KennelProvider(),
        child: TemplateScreen(title: "Kennel", child: EditKennelMain()));
  }
}
