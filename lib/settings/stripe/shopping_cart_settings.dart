import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/shared/text_title.dart';

class ShoppingCartSettings extends StatefulWidget {
  const ShoppingCartSettings({super.key});

  @override
  State<ShoppingCartSettings> createState() => _ShoppingCartSettingsState();
}

class _ShoppingCartSettingsState extends State<ShoppingCartSettings> {
  static final logger = BasicLogger();
  late GlobalKey<FormState> _formKey;
  late TextEditingController _nameController;
  late TextEditingController _urlController;
  late TextEditingController _emailController;
  late TextEditingController _privacyPolicyController;
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _urlController = TextEditingController();
    _emailController = TextEditingController();
    _privacyPolicyController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _emailController.dispose();
    _privacyPolicyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextTitle("Payment page settings"),
        Form(
          key: _formKey,
          child: Column(
            children: [
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
                decoration: const InputDecoration(labelText: "Contact email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the contact email";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _privacyPolicyController,
                decoration:
                    const InputDecoration(labelText: "Privacy policy URL"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the privacy policy URL";
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
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      logger.info("ok");
    } else {
      logger.warning("Not all data filled");
    }
  }
}
