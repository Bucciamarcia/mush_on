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
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog.adaptive(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      scrollable: true,
      title: Row(
        children: [
          Icon(Icons.person_add, color: colorScheme.primary),
          const SizedBox(width: 12),
          Text(widget.customer == null ? "Add Customer" : "Edit Customer"),
        ],
      ),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              TextField(
                onChanged: (s) {
                  setState(() {});
                },
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Customer Name",
                  hintText: "Enter full name",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  hintText: "Optional contact email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Age",
                  hintText: "Customer age (optional)",
                  prefixIcon: const Icon(Icons.cake),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
              ),
              Card(
                elevation: 0,
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                child: SwitchListTile(
                  title: const Text("Single Driver",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Drives alone without passenger"),
                  secondary: Icon(Icons.person_outline,
                      color: isSingleDriver
                          ? colorScheme.primary
                          : colorScheme.outline),
                  value: isSingleDriver,
                  onChanged: (value) {
                    setState(() {
                      isSingleDriver = value;
                    });
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
              ),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Weight (kg)",
                  hintText: "Optional weight information",
                  prefixIcon: const Icon(Icons.monitor_weight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
              ),
              Card(
                elevation: 0,
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                child: SwitchListTile(
                  title: const Text("Is Driving",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Will be driving the sled"),
                  secondary: Icon(Icons.sledding,
                      color: isDriving
                          ? colorScheme.primary
                          : colorScheme.outline),
                  value: isDriving,
                  onChanged: (value) {
                    setState(() {
                      isDriving = value;
                    });
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(color: colorScheme.error),
          ),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: nameController.text.isNotEmpty
              ? () {
                  widget.onCustomerEdited(
                    Customer(
                      id: id,
                      bookingId: widget.bookingId,
                      name: nameController.text,
                      email: emailController.text.isEmpty
                          ? null
                          : emailController.text,
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
                }
              : null,
          icon: const Icon(Icons.save),
          label:
              Text(widget.customer == null ? "Add Customer" : "Save Changes"),
        ),
      ],
    );
  }
}
