import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/resellers/create_account/repository.dart';
import 'package:mush_on/resellers/create_account/riverpod.dart';
import 'package:mush_on/resellers/models.dart';
import 'package:mush_on/resellers/reseller_template.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/shared/text_title.dart';

class ResellerCreateAccount extends ConsumerStatefulWidget {
  const ResellerCreateAccount({super.key});

  @override
  ConsumerState<ResellerCreateAccount> createState() =>
      _ResellerCreateAccountState();
}

class _ResellerCreateAccountState extends ConsumerState<ResellerCreateAccount> {
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
    final logger = BasicLogger();
    final resellerAsync = ref.watch(resellerProvider);
    return resellerAsync.when(
        data: (reseller) {
          if (reseller == null) {
            return const ResellerError(message: "Reseller is null");
          }
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
                    decoration:
                        const InputDecoration(labelText: "Address Line 1"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the address line 1';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressLineTwoController,
                    decoration:
                        const InputDecoration(labelText: "Address Line 2"),
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
                    decoration:
                        const InputDecoration(labelText: "Phone Number"),
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
                        try {
                          final data = ResellerData(
                            status: ResellerStatus.active,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            phoneNumber: _phoneNumberController.text,
                            reverseCharge: _reverseCharge,
                            businessInfo: ResellerBusinessInfo(
                                legalName: _legalNameController.text,
                                addressLineOne: _addressLineOneController.text,
                                zipCode: _zipCodeController.text,
                                city: _cityController.text,
                                country: _countryController.text,
                                province: _provinceController.text,
                                addressLineTwo: _addressLineOneController.text,
                                businessId: _businessIdController.text),
                          );
                          CreateResellerAccountDataRepository()
                              .putData(uid: reseller.uid, data: data);
                          ScaffoldMessenger.of(context).showSnackBar(
                              confirmationSnackbar(
                                  context, "Data updated successfully"));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar(context, "Couldn't update data"));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(context, "Not all field are filled"));
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          );
        },
        error: (e, s) {
          logger.error("Couldn't retrieve reseller data",
              error: e, stackTrace: s);
          return const ResellerError(message: "Couldn't retrieve data");
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}
