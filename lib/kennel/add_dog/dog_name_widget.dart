import 'package:flutter/material.dart';

class DogNameWidget extends StatefulWidget {
  final Function(String) onChanged;

  const DogNameWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<DogNameWidget> createState() => _DogNameWidgetState();
}

class _DogNameWidgetState extends State<DogNameWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        widget.onChanged(value);
      },
      decoration: const InputDecoration(labelText: "Name of the dog"),
    );
  }
}
