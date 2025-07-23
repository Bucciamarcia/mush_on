import 'package:flutter/material.dart';
import 'package:mush_on/customer_management/models.dart';

class CustomerEditorAlert extends StatefulWidget {
  final Customer? customer;
  final Function(Customer) onCustomerEdited;
  const CustomerEditorAlert(
      {super.key, this.customer, required this.onCustomerEdited});

  @override
  State<CustomerEditorAlert> createState() => _CustomerEditorAlertState();
}

class _CustomerEditorAlertState extends State<CustomerEditorAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      title: Text("Customer editor"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Save",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
