import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/tours/repository.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:uuid/uuid.dart';

import '../models.dart';

class TourEditorMain extends ConsumerStatefulWidget {
  final TourType? tour;
  const TourEditorMain({super.key, this.tour});

  @override
  ConsumerState<TourEditorMain> createState() => _TourEditorMainState();
}

class _TourEditorMainState extends ConsumerState<TourEditorMain> {
  late TextEditingController nameController;
  late TextEditingController displayNameController;
  late TextEditingController distanceController;
  late TextEditingController notesController;
  late TextEditingController displayDescriptionController;
  late String id;

  @override
  void initState() {
    super.initState();
    id = widget.tour?.id ?? Uuid().v4();
    nameController = TextEditingController(text: widget.tour?.name);
    displayNameController =
        TextEditingController(text: widget.tour?.displayName);
    distanceController =
        TextEditingController(text: widget.tour?.distance.toString());
    notesController = TextEditingController(text: widget.tour?.notes);
    displayDescriptionController =
        TextEditingController(text: widget.tour?.displayDescription);
  }

  @override
  void dispose() {
    nameController.dispose();
    displayNameController.dispose();
    distanceController.dispose();
    notesController.dispose();
    displayDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              label: Text("Internal name"),
              hint: Text("Won't be shown to customers"),
            ),
          ),
          TextField(
            controller: displayNameController,
            decoration: InputDecoration(
              label: Text("Display name"),
              hint: Text("Shown to customers"),
            ),
          ),
          TextField(
            controller: distanceController,
            decoration: InputDecoration(
              label: Text("Distance"),
              hint: Text("In km"),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          ),
          TextField(
            controller: notesController,
            decoration: InputDecoration(
              label: Text("Notes"),
              hint: Text("Internal notes for staff"),
            ),
            maxLines: 3,
          ),
          TextField(
            controller: displayDescriptionController,
            decoration: InputDecoration(
              label: Text("Display description"),
              hint: Text("Shown to customers"),
            ),
            maxLines: 3,
          ),
          _saveRow(onTourSaved: () async {
            var repo = ToursRepository(
              account: await ref.watch(accountProvider.future),
            );
            await repo.setTour(
              TourType(
                id: id,
                name: nameController.text,
                displayName: displayNameController.text,
                distance: double.tryParse(distanceController.text) ?? 0.0,
                notes: notesController.text,
                displayDescription: displayDescriptionController.text,
              ),
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                confirmationSnackbar(context, "Tour saved"),
              );
              Navigator.of(context).pop();
            }
          }),
        ],
      ),
    );
  }

  Wrap _saveRow({required Function() onTourSaved}) {
    return Wrap(
      spacing: 15,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        ElevatedButton(
          onPressed: () => onTourSaved(),
          child: Text("Save"),
        ),
      ],
    );
  }
}
