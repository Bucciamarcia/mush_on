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
  late TextEditingController durationController;
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
    durationController =
        TextEditingController(text: widget.tour?.duration.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    displayNameController.dispose();
    distanceController.dispose();
    notesController.dispose();
    displayDescriptionController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    List<TourTypePricing> prices =
        ref.watch(tourTypePricesProvider(id)).value ?? [];
    var priceNotifier = ref.read(tourTypePricesProvider(id).notifier);
    return SingleChildScrollView(
      child: Column(
        spacing: 24,
        children: [
          _buildBasicInfoSection(colorScheme),
          _buildPricingSection(colorScheme, prices, priceNotifier),
          _buildSaveSection(colorScheme, onTourSaved: () async {
            var repo = ToursRepository(
              account: await ref.watch(accountProvider.future),
            );
            try {
              await repo.setTour(
                tour: TourType(
                  id: id,
                  name: nameController.text,
                  duration: int.tryParse(durationController.text) ?? 0,
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
          }, onTourDeleted: () async {
            var repo = ToursRepository(
              account: await ref.watch(accountProvider.future),
            );
            try {
              await repo.deleteTour(id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  confirmationSnackbar(context, "Tour deleted"),
                );
                Navigator.of(context).pop();
              }
            } catch (e, s) {
              BasicLogger().error("Failed to delete tour type $id",
                  error: e, stackTrace: s);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  errorSnackBar(context, "Failed to delete tour type"),
                );
              }
              return;
            }
          }),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            children: [
              Icon(Icons.tour, size: 20, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                "Tour Information",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Internal Name",
              hintText: "Won't be shown to customers",
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          TextField(
            controller: displayNameController,
            decoration: InputDecoration(
              labelText: "Display Name",
              hintText: "Shown to customers",
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          TextField(
            controller: distanceController,
            decoration: InputDecoration(
              labelText: "Distance",
              hintText: "In km",
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          ),
          TextField(
            controller: notesController,
            decoration: InputDecoration(
              labelText: "Notes",
              hintText: "Internal notes for staff",
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            maxLines: 3,
          ),
          TextField(
            controller: displayDescriptionController,
            decoration: InputDecoration(
              labelText: "Display Description",
              hintText: "Shown to customers",
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            maxLines: 3,
          ),
          TextField(
            controller: durationController,
            decoration: InputDecoration(
              labelText: "Duration",
              hintText: "In minutes",
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPricingSection(ColorScheme colorScheme,
      List<TourTypePricing> prices, dynamic priceNotifier) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            children: [
              Icon(Icons.euro, size: 20, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                "Pricing Options",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          if (prices.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: prices
                  .where((price) => !price.isArchived)
                  .map(
                    (price) => InputChip(
                      label: Text(price.name),
                      deleteIcon: Icon(Icons.close, size: 18),
                      onDeleted: () => showDialog(
                        context: context,
                        builder: (_) => DeletePricingAlert(
                            onPricingDeleted: () {
                              priceNotifier.editPricing(
                                price.copyWith(isArchived: true),
                              );
                            },
                            pricing: price),
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => PricingEditorAlert(
                          pricing: price,
                          onPricingSaved: (p) => priceNotifier.editPricing(p),
                        ),
                      ),
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      selectedColor: colorScheme.primaryContainer,
                      side: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                  )
                  .toList(),
            ),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => PricingEditorAlert(
                  onPricingSaved: (p) => priceNotifier.addPrice(p),
                ),
              ),
              icon: Icon(Icons.add),
              label: Text("Add Pricing Option"),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveSection(ColorScheme colorScheme,
      {required Function() onTourSaved, required Function() onTourDeleted}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 12,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cancel",
              style: TextStyle(color: colorScheme.error),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => ConfirmDeleteAlert(
                onConfirmed: () {
                  onTourDeleted();
                },
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            icon: Icon(Icons.delete),
            label: Text(
              "Delete",
              style: TextStyle(color: colorScheme.onError),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => onTourSaved(),
            icon: Icon(Icons.save),
            label: Text("Save Tour"),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
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
    priceController = TextEditingController(
        text: ((widget.pricing?.priceCents ?? 0) / 100).toStringAsFixed(2));
    notes = TextEditingController(text: widget.pricing?.notes);
    displayNameController =
        TextEditingController(text: widget.pricing?.displayName);
    displayDescription =
        TextEditingController(text: widget.pricing?.displayDescription);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isViewOnly = widget.pricing != null;
    return AlertDialog.adaptive(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(Icons.euro, color: colorScheme.primary),
          const SizedBox(width: 12),
          Text(isViewOnly ? "Pricing Details" : "New Pricing"),
        ],
      ),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              if (isViewOnly)
                Text(
                    "For safety, a pricing can't be edited or deleted, only archived"),
              TextField(
                controller: nameController,
                readOnly: isViewOnly,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Name of the pricing option",
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: displayNameController,
                readOnly: isViewOnly,
                decoration: InputDecoration(
                  labelText: "Display Name",
                  hintText: "Shown to customers",
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: priceController,
                readOnly: isViewOnly,
                decoration: InputDecoration(
                  labelText: "Price",
                  hintText: "Price in EUR",
                  prefixIcon: Icon(Icons.euro, color: colorScheme.primary),
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: isViewOnly ? null : TextInputType.number,
                inputFormatters: isViewOnly
                    ? null
                    : [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                      ],
              ),
              TextField(
                controller: notes,
                readOnly: isViewOnly,
                decoration: InputDecoration(
                  labelText: "Notes",
                  hintText: "Internal notes for staff",
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                maxLines: 3,
              ),
              TextField(
                controller: displayDescription,
                readOnly: isViewOnly,
                decoration: InputDecoration(
                  labelText: "Display Description",
                  hintText: "Shown to customers",
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(color: colorScheme.error),
          ),
        ),
        if (!isViewOnly)
          ElevatedButton.icon(
            onPressed: () {
              widget.onPricingSaved(
                TourTypePricing(
                  id: id,
                  name: nameController.text,
                  displayName: displayNameController.text,
                  priceCents:
                      ((double.tryParse(priceController.text) ?? 0.0) * 100)
                          .round(),
                  notes: notes.text,
                  displayDescription: displayDescription.text,
                ),
              );
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.save),
            label: Text("Save"),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
      ],
    );
  }
}

class ConfirmDeleteAlert extends StatelessWidget {
  final Function() onConfirmed;
  const ConfirmDeleteAlert({super.key, required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text("Confirm Deletion"),
      content: Text(
        "Are you sure you want to delete this tour? This action cannot be undone.",
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Nevermind"),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirmed();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          child: Text("Delete"),
        ),
      ],
    );
  }
}

class DeletePricingAlert extends StatelessWidget {
  final TourTypePricing pricing;
  final Function() onPricingDeleted;
  const DeletePricingAlert(
      {super.key, required this.onPricingDeleted, required this.pricing});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Archive pricing"),
      content: Text(
        "Are you sure you want to archive pricing: ${pricing.name}\n\nFor safety reasons pricing options can't be deleted, only archived.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Nevermind"),
        ),
        TextButton(
          onPressed: () {
            onPricingDeleted();
            Navigator.of(context).pop();
          },
          child: Text("Archive pricing"),
        )
      ],
    );
  }
}
