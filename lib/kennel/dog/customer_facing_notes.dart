import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_facing/repository.dart';
import 'package:mush_on/customer_facing/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

class CustomerFacingNotesWidget extends ConsumerWidget {
  final Dog dog;
  const CustomerFacingNotesWidget({super.key, required this.dog});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<DogPhoto> pics = ref
            .watch(
                customerDogPhotosProvider(dogId: dog.id, includeAvatar: false))
            .value ??
        [];
    final picsNotifier = ref.read(
        customerDogPhotosProvider(dogId: dog.id, includeAvatar: false)
            .notifier);
    return ExpansionTile(
      title: Text("Customer facing data"),
      children: [
        Text(
          "Pictures",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
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
                        title: Text("Confirm deletion"),
                        content: Text(
                            "Are you sure you want to delete picture: ${pic.fileName} ?\nIt will be gone forever."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Nevermind"),
                          ),
                          TextButton(
                            onPressed: () async {
                              final repo = CustomerFacingRepository(
                                account:
                                    await ref.watch(accountProvider.future),
                              );
                              repo
                                  .deleteCustomerFacingDogPic(
                                      fileName: pic.fileName, dogId: dog.id)
                                  .onError(
                                (e, s) {
                                  BasicLogger().error("Error deleting pic",
                                      error: e, stackTrace: s);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        errorSnackBar(context,
                                            "Error deleting picture: $e"));
                                  }
                                },
                              );
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
        SizedBox(height: 15),
        ElevatedButton.icon(
          onPressed: () async {
            FilePickerResult? result;
            try {
              result = await FilePicker.platform
                  .pickFiles(allowMultiple: false, type: FileType.image);
              if (result != null && result.files.single.path != null) {
                final file = File(result.files.single.path!);
                final repo = CustomerFacingRepository(
                  account: await ref.watch(accountProvider.future),
                );

                // Not awaiting the add to make UI more responsive.
                repo.addCustomerFacingDogPic(
                    fileName: result.files.single.name,
                    file: file,
                    dogId: dog.id);

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
          label: Text("Add picture"),
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
