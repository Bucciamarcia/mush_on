import 'package:flutter/material.dart';

AlertDialog confirmationBoxAlert(
    Widget title, Widget body, Function() onAccepted, Function() onCancelled) {
  return AlertDialog.adaptive(
    title: title,
    content: body,
    actions: [
      TextButton(onPressed: () => onCancelled(), child: const Text("Go back")),
      TextButton(
          onPressed: () => onAccepted(), child: const Text("Yes, I confirm")),
    ],
  );
}
