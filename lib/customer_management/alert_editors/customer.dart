import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/customer_management/tours/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/stripe/riverpod.dart' as stripe;
import 'package:uuid/uuid.dart';

class CustomerEditorAlert extends ConsumerStatefulWidget {
  final Customer? customer;

  /// The booking id this Customer is part of.
  final String bookingId;
  final CustomerGroup? customerGroup;
  final Function(Customer) onCustomerEdited;
  const CustomerEditorAlert({
    super.key,
    this.customer,
    required this.onCustomerEdited,
    required this.bookingId,
    required this.customerGroup,
  });

  @override
  ConsumerState<CustomerEditorAlert> createState() =>
      _CustomerEditorAlertState();
}

class _CustomerEditorAlertState extends ConsumerState<CustomerEditorAlert> {
  late String id;
  final logger = BasicLogger();
  TourType? tourType;
  TourTypePricing? selectedPricing;
  late TextEditingController pricingController;
  late Map<String, TextEditingController> customerCustomFieldControllers;

  // Add a flag to track if pricing has been loaded
  bool pricingLoaded = false;

  @override
  void initState() {
    super.initState();
    id = widget.customer?.id ?? const Uuid().v4();
    pricingController = TextEditingController();
    customerCustomFieldControllers = {};
  }

  @override
  void dispose() {
    pricingController.dispose();
    for (final controller in customerCustomFieldControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch tour type if we have a customer group with a tour type ID
    logger.debug("customer group: ${widget.customerGroup?.id}");
    logger.debug("tour type id: ${widget.customerGroup?.tourTypeId}");
    if (widget.customerGroup != null &&
        widget.customerGroup!.tourTypeId != null &&
        tourType == null) {
      logger.debug(
        "Fetching tour type with ID: ${widget.customerGroup!.tourTypeId} for customer group: ${widget.customerGroup!.id}",
      );

      // This should fetch the tour type by its ID
      var tourTypeAsync = ref.watch(
        tourTypeByIdProvider(widget.customerGroup!.tourTypeId!),
      );

      if (tourTypeAsync.hasValue && tourTypeAsync.value != null) {
        tourType = tourTypeAsync.value;
        logger.debug("Tour type loaded: ${tourType!.id}");
      }
    }

    // Fetch pricing if customer has a pricing ID and tour type is loaded
    if (widget.customer?.pricingId != null &&
        tourType != null &&
        !pricingLoaded) {
      logger.debug(
        "Fetching pricing with ID: ${widget.customer!.pricingId} for tour type: ${tourType!.id}",
      );

      var selectedPricingAsync = ref.watch(
        tourTypePricingByIdProvider(widget.customer!.pricingId!, tourType!.id),
      );

      selectedPricingAsync.whenData((data) {
        if (data != null && !pricingLoaded) {
          logger.debug(
            "Pricing loaded successfully: ${data.name} (${data.id})",
          );
          // Use WidgetsBinding to ensure setState is called after build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                selectedPricing = data;
                pricingController.text = data.name;
                pricingLoaded = true;
              });
            }
          });
        } else if (data == null) {
          logger.debug(
            "WARNING: Pricing with ID ${widget.customer!.pricingId} not found for tour type ${tourType!.id}",
          );
        }
      });
    }

    final kennelInfoAsync = ref.watch(
      stripe.bookingManagerKennelInfoProvider(),
    );
    if (kennelInfoAsync.isLoading && !kennelInfoAsync.hasValue) {
      return const CircularProgressIndicator.adaptive();
    }
    final kennelInfo = kennelInfoAsync.valueOrNull;
    for (final field in kennelInfo?.customerCustomFields ?? const []) {
      customerCustomFieldControllers.putIfAbsent(
        field.name,
        () => TextEditingController(
          text: widget.customer?.customerOtherInfo[field.name],
        ),
      );
    }

    // Fetch all available prices for the tour type
    var prices = <TourTypePricing>[];
    if (tourType != null) {
      logger.debug("Getting prices");
      var pricesAsync = ref.watch(tourTypePricesProvider(tourType!.id));
      if (pricesAsync.hasValue && pricesAsync.value != null) {
        logger.debug("Prices loaded successfully");
        prices = pricesAsync.value!;
        logger.debug("Available prices loaded: ${prices.length} options");

        // Double-check if our selected pricing exists in the list
        if (widget.customer?.pricingId != null &&
            !pricingLoaded &&
            prices.isNotEmpty) {
          final matchingPricing = _firstPricingById(
            prices,
            widget.customer!.pricingId!,
          );

          if (matchingPricing != null) {
            logger.debug(
              "Found matching pricing in prices list: ${matchingPricing.name}",
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !pricingLoaded) {
                setState(() {
                  selectedPricing = matchingPricing;
                  pricingController.text = matchingPricing.name;
                  pricingLoaded = true;
                });
              }
            });
          }
        }
      }
    } else {
      logger.warning("Tour type is null, cannot load prices.");
    }

    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog.adaptive(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      scrollable: true,
      title: Row(
        children: [
          Icon(Icons.person_add, color: colorScheme.primary),
          const SizedBox(width: 12),
          Text(widget.customer == null ? "Add Customer" : "Edit Customer"),
        ],
      ),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              if ((kennelInfo?.customerCustomFields ?? []).isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    "No customer custom fields are configured.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else
                ...kennelInfo!.customerCustomFields.map(
                  (field) => TextField(
                    controller: customerCustomFieldControllers[field.name],
                    decoration: InputDecoration(
                      labelText:
                          "${field.name}${field.isRequired ? " (Required)" : ""}",
                      hintText: field.description.isEmpty
                          ? null
                          : field.description,
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                  ),
                ),
              DropdownMenu<TourTypePricing>(
                // Add a key that changes when pricing is loaded to force rebuild
                key: ValueKey(
                  'dropdown_${selectedPricing?.id ?? "empty"}_${prices.length}',
                ),
                width: double.infinity,
                initialSelection: selectedPricing,
                controller: pricingController,
                onSelected: (value) {
                  setState(() {
                    selectedPricing = value;
                    if (value != null) {
                      pricingController.text = value.name;
                    }
                  });
                },
                dropdownMenuEntries: prices
                    .map(
                      (e) => DropdownMenuEntry<TourTypePricing>(
                        value: e,
                        label: e.name,
                      ),
                    )
                    .toList(),
                leadingIcon: const Icon(Icons.attach_money),
                label: const Text("Select Pricing"),
                hintText: "Choose a pricing option for this customer",
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel", style: TextStyle(color: colorScheme.error)),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            logger.debug(
              "Saving customer with pricing: ${selectedPricing?.id}",
            );
            final customerOtherInfo = Map<String, String>.from(
              widget.customer?.customerOtherInfo ?? const <String, String>{},
            );
            for (final entry in customerCustomFieldControllers.entries) {
              customerOtherInfo[entry.key] = entry.value.text;
            }
            widget.onCustomerEdited(
              (widget.customer ?? Customer(id: id, bookingId: widget.bookingId))
                  .copyWith(
                    bookingId: widget.bookingId,
                    pricingId: selectedPricing?.id,
                    customerOtherInfo: customerOtherInfo,
                  ),
            );
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.save),
          label: Text(
            widget.customer == null ? "Add Customer" : "Save Changes",
          ),
        ),
      ],
    );
  }
}

TourTypePricing? _firstPricingById(List<TourTypePricing> prices, String id) {
  for (final price in prices) {
    if (price.id == id) return price;
  }
  return null;
}
