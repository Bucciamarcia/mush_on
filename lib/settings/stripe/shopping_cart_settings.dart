import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/stripe/booking_custom_fields.dart';
import 'package:mush_on/settings/stripe/customer_custom_fields.dart';
import 'package:mush_on/settings/stripe/riverpod.dart';
import 'package:mush_on/settings/stripe/shopping_cart_settings_image.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'package:mush_on/shared/text_title.dart';

import 'stripe_repository.dart';

class ShoppingCartSettings extends ConsumerStatefulWidget {
  const ShoppingCartSettings({super.key});

  @override
  ConsumerState<ShoppingCartSettings> createState() =>
      _ShoppingCartSettingsState();
}

class _ShoppingCartSettingsState extends ConsumerState<ShoppingCartSettings> {
  static final logger = BasicLogger();
  late GlobalKey<FormState> _formKey;
  late TextEditingController _nameController;
  late TextEditingController _urlController;
  late TextEditingController _emailController;
  late TextEditingController _cancellationPolicyController;
  bool? applyVat;
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _urlController = TextEditingController();
    _emailController = TextEditingController();
    _cancellationPolicyController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _emailController.dispose();
    _cancellationPolicyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logger = BasicLogger();
    final imageState = ref.watch(kennelImageProvider(account: null));
    bool isLoading = imageState.isLoading;
    Uint8List? image = imageState.value;
    ref.listen(bookingManagerKennelInfoProvider(account: null),
        (previous, next) {
      next.whenData((kennelInfo) {
        if (kennelInfo != null) {
          // Only fill the controllers if they are currently empty
          // (This prevents overwriting what the user is currently typing)
          if (_nameController.text.isEmpty) {
            _nameController.text = kennelInfo.name;
            _urlController.text = kennelInfo.url;
            _emailController.text = kennelInfo.email;
            _cancellationPolicyController.text = kennelInfo.cancellationPolicy;
            setState(() => applyVat = kennelInfo.vatRate != 0);
          }

          // Initialize the other provider safely
          ref
              .read(tempCustomerFieldsProvider.notifier)
              .setInitialFields(kennelInfo.customerCustomFields);
          ref
              .read(tempBookingFieldsProvider.notifier)
              .setInitialFields(kennelInfo.bookingCustomFields);
        }
      });
    });

    final bookingManagerKennelInfo =
        ref.watch(bookingManagerKennelInfoProvider(account: null));
    final tempCustomerFields = ref.watch(tempCustomerFieldsProvider);
    final tempBookingFields = ref.watch(tempBookingFieldsProvider);

    return bookingManagerKennelInfo.when(
        data: (kennelInfo) {
          if (kennelInfo != null) {
            _nameController.text = kennelInfo.name;
            _urlController.text = kennelInfo.url;
            _emailController.text = kennelInfo.email;
            _cancellationPolicyController.text = kennelInfo.cancellationPolicy;
            applyVat ??= kennelInfo.vatRate != 0;
          }
          return Column(
            children: [
              const TextTitle("Payment page settings"),
              Form(
                key: _formKey,
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    KennelImageCard(image: image, isLoading: isLoading),
                    TextFormField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: "Kennel name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter the kennel name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: _urlController,
                      keyboardType: TextInputType.url,
                      decoration:
                          const InputDecoration(labelText: "Kennel URL"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter the kennel URL";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(labelText: "Contact email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter the contact email";
                        } else if (!value.contains("@") ||
                            !value.contains(".")) {
                          return "Enter a valid email address";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: _cancellationPolicyController,
                      decoration: const InputDecoration(
                          labelText: "Cancellation policy"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter the cancellation policy";
                        } else {
                          return null;
                        }
                      },
                    ),
                    Row(
                      children: [
                        DropdownMenuFormField(
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: true, label: "Yes"),
                            DropdownMenuEntry(value: false, label: "No"),
                          ],
                          onSelected: (v) {
                            setState(() {
                              applyVat = v;
                            });
                          },
                          validator: (v) {
                            if (v == null) {
                              return "Select if VAT should be applied";
                            } else {
                              return null;
                            }
                          },
                          initialSelection: applyVat,
                          label: const Text("Apply Finnish 25,5% VAT"),
                        ),
                        const Tooltip(
                          message:
                              "Select YES if your business is in Finland to be charged VAT for your payments to Mush On. Select NO if you want reverse VAT.",
                          triggerMode: TooltipTriggerMode.tap,
                          child: Icon(
                            Icons.help_outline,
                            size: 20,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    CustomerCustomFieldsMain(
                      tempCustomerFields: tempCustomerFields,
                      kennelInfo: kennelInfo,
                      onSubmit: () => _submitForm(),
                    ),
                    BookingCustomFieldsMain(
                      tempBookingFields: tempBookingFields,
                      kennelInfo: kennelInfo,
                      onSubmit: () => _submitForm(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        error: (e, s) {
          logger.error("Error loading kennel info", error: e, stackTrace: s);
          return Text("Error loading kennel info: $e");
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }

  /// checks that all the fields, returns false if any is empty.
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      logger.info("Form contains valid data");
      if (applyVat == null) {
        BasicLogger().error("Apply vat is not right!");
        ScaffoldMessenger.of(context).showSnackBar(
            errorSnackBar(context, "Select if VAT should be applied"));
        return;
      }
      final toSubmit = BookingManagerKennelInfo(
          name: _nameController.text,
          url: _urlController.text,
          email: _emailController.text,
          cancellationPolicy: _cancellationPolicyController.text,
          customerCustomFields: ref.read(tempCustomerFieldsProvider),
          bookingCustomFields: ref.read(tempBookingFieldsProvider),
          vatRate: applyVat == false ? 0 : 0.255);
      try {
        final account = await ref.read(accountProvider.future);
        await StripeRepository(account: account)
            .saveBookingManagerKennelInfo(toSubmit);
        ref
            .read(isCustomerCustomFieldsEditedProvider.notifier)
            .setEdited(false);
        ref.read(isBookingCustomFieldsEditedProvider.notifier).setEdited(false);
        ScaffoldMessenger.of(context).showSnackBar(
            confirmationSnackbar(context, "Data saved correctly"));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackBar(context, "Couldn't save the data"));
      }
    } else {
      logger.warning("Not all data filled");
    }
  }
}
