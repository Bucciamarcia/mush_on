import 'package:flutter/material.dart';
import 'package:mush_on/services/models/dog.dart';

class DeleteDogButton extends StatelessWidget {
  final Dog dog;
  final Function() onDogDeleted;
  final Function() onDogRetired;
  final Function() onDogUnretired;
  const DeleteDogButton({
    super.key,
    required this.dog,
    required this.onDogDeleted,
    required this.onDogRetired,
    required this.onDogUnretired,
  });

  @override
  Widget build(BuildContext context) {
    if (!dog.isRetired) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Tooltip(
            message:
                "Archive the dog and don't display it in the active dog list",
            child: ElevatedButton.icon(
              onPressed: () => onDogRetired(),
              label: const Text("Retire dog"),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.onPrimary,
                ),
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        Tooltip(
          message: "Move the dog back to the active dog list",
          child: ElevatedButton.icon(
            onPressed: () => onDogUnretired(),
            label: const Text("Unretire dog"),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.onPrimary,
              ),
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        Tooltip(
          message:
              "Deletes the dog from the database. WARNING: this cannot be reversed!",
          child: ElevatedButton.icon(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.onError,
              ),
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.error,
              ),
            ),
            onPressed: () => onDogDeleted(),
            label: const Text("Delete dog"),
            icon: const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
