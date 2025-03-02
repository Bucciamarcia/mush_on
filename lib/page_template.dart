import 'package:flutter/material.dart';

class TemplateScreen extends StatelessWidget {
  final Widget child;
  final String title;

  const TemplateScreen({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      )),
    );
  }
}
