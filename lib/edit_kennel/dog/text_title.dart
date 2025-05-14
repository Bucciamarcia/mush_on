import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final String text;
  const TextTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
    );
  }
}
