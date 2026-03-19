import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
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
        }
      });
    });

    final bookingManagerKennelInfo =
        ref.watch(bookingManagerKennelInfoProvider(account: null));
    final tempCustomerFields = ref.watch(tempCustomerFieldsProvider);

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
                    CustomerCustomFieldsEditor(fields: tempCustomerFields),
                    ElevatedButton(
                        onPressed: () => _submitForm(),
                        child: const Text("Submit")),
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
          vatRate: applyVat == false ? 0 : 0.255);
      try {
        final account = await ref.read(accountProvider.future);
        await StripeRepository(account: account)
            .saveBookingManagerKennelInfo(toSubmit);
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

class CustomerCustomFieldsEditor extends ConsumerWidget {
  final List<CustomerCustomField> fields;
  const CustomerCustomFieldsEditor({super.key, required this.fields});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        ...fields.asMap().entries.map((entry) {
          final index = entry.key;
          final field = entry.value;
          return FieldDisplayWidget(
            field: field,
            onChanged: (v) => ref
                .read(tempCustomerFieldsProvider.notifier)
                .updateField(index, v),
          );
        }),
        IconButton(
            onPressed: () =>
                ref.read(tempCustomerFieldsProvider.notifier).addField(),
            icon: const Icon(Icons.add))
      ],
    );
  }
}

class FieldDisplayWidget extends StatefulWidget {
  final CustomerCustomField field;
  final Function(CustomerCustomField) onChanged;
  const FieldDisplayWidget(
      {super.key, required this.field, required this.onChanged});

  @override
  State<FieldDisplayWidget> createState() => _FieldDisplayWidgetState();
}

class _FieldDisplayWidgetState extends State<FieldDisplayWidget> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late bool isRequired;
  late bool canEditName;
  late bool canEditDescription;
  @override
  void initState() {
    nameController = TextEditingController(text: widget.field.name);
    descriptionController =
        TextEditingController(text: widget.field.description);
    isRequired = widget.field.isRequired;
    canEditName = false;
    canEditDescription = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(hintText: "Name"),
                  controller: nameController,
                  enabled: canEditName,
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (canEditName)
                      widget.onChanged(
                          widget.field.copyWith(name: nameController.text));
                    setState(() {
                      canEditName = !canEditName;
                    });
                  },
                  icon: canEditName
                      ? const Icon(Icons.check)
                      : const Icon(Icons.edit)),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(hintText: "Description"),
                  controller: descriptionController,
                  maxLines: 3,
                  enabled: canEditDescription,
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (canEditDescription) {
                      widget.onChanged(widget.field
                          .copyWith(description: descriptionController.text));
                    }
                    setState(() {
                      canEditDescription = !canEditDescription;
                    });
                  },
                  icon: canEditDescription
                      ? const Icon(Icons.check)
                      : const Icon(Icons.edit)),
            ],
          ),
          CheckboxListTile.adaptive(
              value: isRequired,
              onChanged: (v) {
                if (v != null) {
                  widget.onChanged(widget.field.copyWith(isRequired: v));
                  setState(() {
                    isRequired = v;
                  });
                }
              })
        ],
      ),
    );
  }
}
