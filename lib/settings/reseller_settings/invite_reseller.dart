import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/reseller_settings/repository.dart';

class InviteResellerSnippet extends ConsumerStatefulWidget {
  const InviteResellerSnippet({super.key});

  @override
  ConsumerState<InviteResellerSnippet> createState() =>
      _InviteResellerSnippetState();
}

class _InviteResellerSnippetState extends ConsumerState<InviteResellerSnippet> {
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
              onPressed: () async {
                final user = await ref.watch(userProvider.future);
                if (user == null) return;
                final userName =
                    await ref.watch(userNameProvider(user.uid).future);
                if (userName == null) return;
                final senderEmail = userName.email;
                if (_formKey.currentState!.validate()) {
                  final account = await ref.watch(accountProvider.future);
                  try {
                    await ResellerSettingsRepository().inviteReseller(
                        _emailController.text,
                        int.parse(_discountAmountController.text),
                        account,
                        senderEmail);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          confirmationSnackbar(
                              context, "Reseller has been invited via email"));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          errorSnackBar(context, "Couldn't invite reseller"));
                    }
                  }
                }
              },
              child: const Text("Send Invitation")),
        ],
      ),
    );
  }
}
