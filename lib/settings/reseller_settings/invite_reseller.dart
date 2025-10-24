import 'package:flutter/material.dart';

class InviteResellerSnippet extends StatefulWidget {
  const InviteResellerSnippet({super.key});

  @override
  State<InviteResellerSnippet> createState() => _InviteResellerSnippetState();
}

class _InviteResellerSnippetState extends State<InviteResellerSnippet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _discountAmountController;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _discountAmountController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _discountAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "Reseller email"),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !value.contains("@") ||
                  !value.contains(".")) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _discountAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: "Discount % amount (e.g. 15)", suffix: Text("%")),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a discount amount';
              }
              final discount = double.tryParse(value);
              if (discount == null || discount < 0 || discount > 100) {
                return 'Please enter a discount between 0 (no discount) and 100 (all bookings are free)';
              }
              return null;
            },
          ),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Process the invitation logic here
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Invitation sent to ${_emailController.text}')));
                }
              },
              child: const Text("Send Invitation")),
        ],
      ),
    );
  }
}
