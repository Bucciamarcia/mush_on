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
    bool isLoading = ref.watch(isLoadingKennelImageProvider);
    Uint8List? image = ref.watch(kennelImageProvider).value;
    return Column(
      children: [
        const TextTitle("Payment page settings"),
        Form(
          key: _formKey,
          child: Column(
            children: [
              KennelImageCard(image: image, isLoading: isLoading),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Kennel name"),
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
                decoration: const InputDecoration(labelText: "Kennel URL"),
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
                decoration: const InputDecoration(labelText: "Contact email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the contact email";
                  } else if (!value.contains("@") || !value.contains(".")) {
                    return "Enter a valid email address";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _cancellationPolicyController,
                decoration:
                    const InputDecoration(labelText: "Cancellation policy"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the cancellation policy";
                  } else {
                    return null;
                  }
                },
              ),
              ElevatedButton(
                  onPressed: _submitForm, child: const Text("Submit")),
            ],
          ),
        ),
      ],
    );
  }

  /// checks that all the fields, returns false if any is empty.
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      logger.info("Form contains valid data");
      final toSubmit = BookingManagerKennelInfo(
          name: _nameController.text,
          url: _urlController.text,
          email: _emailController.text,
          cancellationPolicy: _cancellationPolicyController.text);
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
