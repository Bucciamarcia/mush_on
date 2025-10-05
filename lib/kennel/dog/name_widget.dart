import 'package:flutter/material.dart';

class NameWidget extends StatelessWidget {
  final String name;
  final Function(String) onNameChanged;
  const NameWidget(
      {super.key, required this.name, required this.onNameChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        Text(name,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        IconButton.outlined(
            onPressed: () {
              showAdaptiveDialog(
                context: context,
                builder: (BuildContext context) => DogNameEditor(
                  currentName: name,
                  onNameChanged: (String newName) => onNameChanged(newName),
                ),
              );
            },
            icon: const Icon(Icons.edit)),
      ],
    );
  }
}

class DogNameEditor extends StatefulWidget {
  final String currentName;
  final Function(String) onNameChanged;
  const DogNameEditor(
      {super.key, required this.currentName, required this.onNameChanged});

  @override
  State<DogNameEditor> createState() => _DogNameEditorState();
}

class _DogNameEditorState extends State<DogNameEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text("Change dog name"),
      content: TextField(
        controller: _controller,
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            widget.onNameChanged(_controller.text);
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
