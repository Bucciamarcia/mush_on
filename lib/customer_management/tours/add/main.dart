import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/tours/repository.dart';
import 'package:mush_on/customer_management/tours/riverpod.dart';
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
    List<TourTypePricing> prices =
        ref.watch(tourTypePricesProvider(id)).value ?? [];
    var priceNotifier = ref.read(tourTypePricesProvider(id).notifier);
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
          Divider(),
          Column(
            spacing: 10,
            children: [
              Wrap(
                children: prices
                    .map(
                      (price) => InputChip(
                        label: Text(price.name),
                        onDeleted: () => priceNotifier.removePrice(price.id),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => PricingEditorAlert(
                            pricing: price,
                            onPricingSaved: (p) => priceNotifier.editPricing(p),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => PricingEditorAlert(
                    onPricingSaved: (p) => priceNotifier.addPrice(p),
                  ),
                ),
                child: Text("Add pricing option"),
              ),
            ],
          ),
          Divider(),
          _saveRow(onTourSaved: () async {
            var repo = ToursRepository(
              account: await ref.watch(accountProvider.future),
            );
            try {
              await repo.setTour(
                tour: TourType(
                  id: id,
                  name: nameController.text,
                  displayName: displayNameController.text,
                  distance: double.tryParse(distanceController.text) ?? 0.0,
                  notes: notesController.text,
                  displayDescription: displayDescriptionController.text,
                ),
                pricing: prices,
              );
            } catch (e, s) {
              BasicLogger().error("Failed to save tour type $id",
                  error: e, stackTrace: s);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  errorSnackBar(context, "Failed to save tour type"),
                );
              }
              return;
            }
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

class PricingEditorAlert extends StatefulWidget {
  final TourTypePricing? pricing;
  final Function(TourTypePricing) onPricingSaved;
  const PricingEditorAlert(
      {super.key, this.pricing, required this.onPricingSaved});

  @override
  State<PricingEditorAlert> createState() => _PricingEditorAlertState();
}

class _PricingEditorAlertState extends State<PricingEditorAlert> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late String id;
  late TextEditingController notes;
  late TextEditingController displayNameController;
  late TextEditingController displayDescription;

  @override
  void initState() {
    super.initState();
    id = widget.pricing?.id ?? Uuid().v4();
    nameController = TextEditingController(text: widget.pricing?.name);
    priceController =
        TextEditingController(text: widget.pricing?.price.toStringAsFixed(2));
    notes = TextEditingController(text: widget.pricing?.notes);
    displayNameController =
        TextEditingController(text: widget.pricing?.displayName);
    displayDescription =
        TextEditingController(text: widget.pricing?.displayDescription);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      title: Text("Pricing editor"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              label: Text("Name"),
              hint: Text("Name of the pricing option"),
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
            controller: priceController,
            decoration: InputDecoration(
              label: Text("Price"),
              hint: Text("Price in EUR"),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          ),
          TextField(
            controller: notes,
            decoration: InputDecoration(
              label: Text("Notes"),
              hint: Text("Internal notes for staff"),
            ),
            maxLines: 3,
          ),
          TextField(
            controller: displayDescription,
            decoration: InputDecoration(
              label: Text("Display description"),
              hint: Text("Shown to customers"),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onPricingSaved(
              TourTypePricing(
                id: id,
                name: nameController.text,
                displayName: displayNameController.text,
                price: double.tryParse(priceController.text) ?? 0.0,
                notes: notes.text,
                displayDescription: displayDescription.text,
              ),
            );
            Navigator.of(context).pop();
          },
          child: Text("Save"),
        )
      ],
    );
  }
}
