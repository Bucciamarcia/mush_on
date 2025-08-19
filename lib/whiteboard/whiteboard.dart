import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/whiteboard/main.dart';

class WhiteboardScreen extends StatelessWidget {
  const WhiteboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateScreen(
        title: "Whiteboard", child: GeneralWhiteboard());
  }
}
