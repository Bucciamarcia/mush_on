import 'package:flutter/material.dart';

class SaveCancelButtons extends StatelessWidget {
  final Function() onCancelPressed;
  final Function() onSavePressed;
  final bool didSomethingChange;
  const SaveCancelButtons(
      {super.key,
      required this.onSavePressed,
      required this.onCancelPressed,
      required this.didSomethingChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 25,
      children: [
        ElevatedButton(
          onPressed: () => onCancelPressed(),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, foregroundColor: Colors.black),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => didSomethingChange ? onSavePressed() : null,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreen,
              foregroundColor: Colors.black),
          child: Text("Save"),
        ),
      ],
    );
  }
}
