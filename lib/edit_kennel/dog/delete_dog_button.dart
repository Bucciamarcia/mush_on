import 'package:flutter/material.dart';
import 'package:mush_on/services/models/dog.dart';

class DeleteDogButton extends StatelessWidget {
  final Dog dog;
  final Function() onDogDeleted;
  const DeleteDogButton(
      {super.key, required this.dog, required this.onDogDeleted});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.black),
        backgroundColor: WidgetStateProperty.all(Colors.red),
      ),
      onPressed: () => onDogDeleted(),
      label: Text("Delete dog"),
      icon: Icon(Icons.delete),
    );
  }
}
