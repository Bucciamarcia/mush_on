import 'package:flutter/material.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:uuid/uuid.dart';

class CustomerEditorAlert extends StatefulWidget {
  final Customer? customer;

  /// The booking id this Customer is part of.
  final String bookingId;
  final Function(Customer) onCustomerEdited;
  const CustomerEditorAlert(
      {super.key,
      this.customer,
      required this.onCustomerEdited,
      required this.bookingId});

  @override
  State<CustomerEditorAlert> createState() => _CustomerEditorAlertState();
}

class _CustomerEditorAlertState extends State<CustomerEditorAlert> {
  late String id;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController ageController;
  late bool isSingleDriver;
  late TextEditingController weightController;
  late bool isDriving;

  @override
  void initState() {
    super.initState();
    id = widget.customer?.id ?? Uuid().v4();
    nameController = TextEditingController(text: widget.customer?.name);
    emailController = TextEditingController(text: widget.customer?.email);
    ageController =
        TextEditingController(text: widget.customer?.age?.toString());
    isSingleDriver = widget.customer?.isSingleDriver ?? false;
    weightController =
        TextEditingController(text: widget.customer?.weight?.toString());
    isDriving = widget.customer?.isDriving ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      title: Text("Customer editor"),
      content: Column(
        spacing: 5,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Age"),
          ),
          SwitchListTile.adaptive(
            title: Text("Is Single Driver?"),
            value: isSingleDriver,
            onChanged: (value) {
              setState(() {
                isSingleDriver = value;
              });
            },
          ),
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Weight (kg)"),
          ),
          SwitchListTile.adaptive(
            title: Text("Is Driving?"),
            value: isDriving,
            onChanged: (value) {
              setState(() {
                isDriving = value;
              });
            },
          ),
        ],
      ),
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
            widget.onCustomerEdited(
              Customer(
                id: id,
                bookingId: widget.bookingId,
                name: nameController.text,
                email:
                    emailController.text.isEmpty ? null : emailController.text,
                age: ageController.text.isEmpty
                    ? null
                    : int.tryParse(ageController.text),
                weight: weightController.text.isEmpty
                    ? null
                    : int.tryParse(weightController.text),
                isDriving: isDriving,
                isSingleDriver: isSingleDriver,
              ),
            );
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
