import 'package:flutter/material.dart';

class InvoicingDetailsForm extends StatelessWidget {
  final TextEditingController legalNameController;
  final TextEditingController addressController;
  final TextEditingController businessIdController;

  const InvoicingDetailsForm({
    super.key,
    required this.legalNameController,
    required this.addressController,
    required this.businessIdController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        TextFormField(
          controller: legalNameController,
          decoration: const InputDecoration(
            labelText: "Legal name",
            prefixIcon: Icon(Icons.business_outlined),
          ),
        ),
        TextFormField(
          controller: addressController,
          minLines: 2,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            labelText: "Legal address",
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 360,
            child: TextFormField(
              controller: businessIdController,
              decoration: const InputDecoration(
                labelText: "Business ID or VAT number",
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
