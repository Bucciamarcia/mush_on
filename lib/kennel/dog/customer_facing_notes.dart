import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_facing/repository.dart';
import 'package:mush_on/customer_facing/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';

class CustomerFacingNotesWidget extends ConsumerStatefulWidget {
  final Dog dog;
  const CustomerFacingNotesWidget({super.key, required this.dog});

  @override
  ConsumerState<CustomerFacingNotesWidget> createState() =>
      _CustomerFacingNotesWidgetState();
}

class _CustomerFacingNotesWidgetState
    extends ConsumerState<CustomerFacingNotesWidget> {
  late TextEditingController customerFacingDogDescription;
  @override
  void initState() {
    super.initState();
    customerFacingDogDescription = TextEditingController(
      text: widget.dog.customerFacingDescription,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pics = ref
            .watch(customerDogPhotosProvider(
                dogId: widget.dog.id, includeAvatar: false))
            .value ??
        [];

    final picsNotifier = ref.read(
        customerDogPhotosProvider(dogId: widget.dog.id, includeAvatar: false)
            .notifier);

    return ExpansionTile(
      title: const Text("Customer facing data"),
      children: [
        const Text(
          "Pictures",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: pics.length,
          itemBuilder: (context, index) {
            final pic = pics[index];
            return Stack(
              children: [
                Image.memory(pic.data),
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (alertContext) => AlertDialog.adaptive(
                        title: const Text("Confirm deletion"),
                        content: Text(
                          "Are you sure you want to delete picture: ${pic.fileName} ?\nIt will be gone forever.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Nevermind"),
                          ),
                          TextButton(
                            onPressed: () async {
                              final repo = CustomerFacingRepository(
                                account: await ref.read(accountProvider.future),
                              );
                              repo
                                  .deleteCustomerFacingDogPic(
                                fileName: pic.fileName,
                                dogId: widget.dog.id,
                              )
                                  .onError((e, s) {
                                BasicLogger().error("Error deleting pic",
                                    error: e, stackTrace: s);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    errorSnackBar(
                                      context,
                                      "Error deleting picture: $e",
                                    ),
                                  );
                                }
                              });
                              picsNotifier.removePicture(pic.fileName);
                              if (alertContext.mounted) {
                                Navigator.of(alertContext).pop();
                              }
                            },
                            child: Text(
                              "Yes, delete",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 15),
        ElevatedButton.icon(
          onPressed: () async {
            FilePickerResult? result;
            try {
              result = await FilePicker.platform
                  .pickFiles(allowMultiple: false, type: FileType.image);
              if (result != null && result.files.single.path != null) {
                final file = File(result.files.single.path!);
                final repo = CustomerFacingRepository(
                  account: await ref.read(accountProvider.future),
                );

                // Not awaiting the add to make UI more responsive.
                repo.addCustomerFacingDogPic(
                  fileName: result.files.single.name,
                  file: file,
                  dogId: widget.dog.id,
                );

                // Now update the UI
                picsNotifier.addPicture(file);
              }
            } catch (e, s) {
              BasicLogger()
                  .error("Error picking file", error: e, stackTrace: s);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error picking file: $e")),
                );
              }
              return;
            }
          },
          label: const Text("Add picture"),
          icon: const Icon(Icons.add),
        ),
        const SizedBox(height: 15),
        TextField(
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Customer facing description",
            hintText: "Shown in tour page for customers",
          ),
          controller: customerFacingDogDescription,
        ),
        ElevatedButton(
          onPressed: () async {
            final account = await ref.watch(accountProvider.future);
            try {
              await DogsDbOperations().changeDogCustomerFacingDescription(
                  newDescription: customerFacingDogDescription.text,
                  id: widget.dog.id,
                  account: account);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  confirmationSnackbar(context, "Description updated"),
                );
              }
            } catch (e, s) {
              BasicLogger()
                  .error("Error updating description", error: e, stackTrace: s);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  errorSnackBar(context, "Error updating description: $e"),
                );
              }
              return;
            }
          },
          child: Text("Update description"),
        ),
      ],
    );
  }
}
