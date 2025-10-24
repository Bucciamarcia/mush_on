import 'package:flutter/material.dart';
import 'package:mush_on/shared/text_title.dart';

class ResellerCreateAccount extends StatefulWidget {
  const ResellerCreateAccount({super.key});

  @override
  State<ResellerCreateAccount> createState() => _ResellerCreateAccountState();
}

class _ResellerCreateAccountState extends State<ResellerCreateAccount> {
  late TextEditingController _legalNameController;
  late TextEditingController _addressLineOneController;
  late TextEditingController _addressLineTwoController;
  late TextEditingController _provinceController;
  late TextEditingController _zipCodeController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _businessIdController;
  late TextEditingController _phoneNumberController;
  late bool _reverseCharge;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _legalNameController = TextEditingController();
    _addressLineOneController = TextEditingController();
    _addressLineTwoController = TextEditingController();
    _provinceController = TextEditingController();
    _zipCodeController = TextEditingController();
    _cityController = TextEditingController();
    _countryController = TextEditingController();
    _businessIdController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _reverseCharge = false;
  }

  @override
  void dispose() {
    _legalNameController.dispose();
    _addressLineOneController.dispose();
    _addressLineTwoController.dispose();
    _provinceController.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _businessIdController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const TextTitle("All fields are required"),
            TextFormField(
              controller: _legalNameController,
              decoration: const InputDecoration(labelText: "Legal Name"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the legal name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressLineOneController,
              decoration: const InputDecoration(labelText: "Address Line 1"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the address line 1';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressLineTwoController,
              decoration: const InputDecoration(labelText: "Address Line 2"),
            ),
            TextFormField(
              controller: _provinceController,
              decoration: const InputDecoration(labelText: "Province"),
            ),
            TextFormField(
              controller: _zipCodeController,
              decoration: const InputDecoration(labelText: "Zip Code"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the zip code';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: "City"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the city';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: "Country"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the country';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _businessIdController,
              decoration: const InputDecoration(labelText: "Business ID"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the business ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: "Phone Number"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the phone number';
                }
                return null;
              },
            ),
            CheckboxListTile.adaptive(
                title: const Text("Request reverse charge"),
                subtitle: const Text(
                    "VAT will be removed from invoice for reverse charge."),
                value: _reverseCharge,
                onChanged: (v) {
                  if (v != null) {
                    setState(() {
                      _reverseCharge = v;
                    });
                  }
                }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Process data
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
