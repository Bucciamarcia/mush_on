import 'dart:io';
import 'package:mush_on/services/error_handling.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/services/storage.dart';

class DogPhotoCard extends StatelessWidget {
  final String id;
  final String account;
  const DogPhotoCard(this.id, this.account, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Placeholder(),
          ),
          Column(
            children: [
              IconButton.outlined(
                  onPressed: () {
                    _onEditPressed();
                  },
                  icon: Icon(Icons.edit)),
              IconButton.outlined(onPressed: () {}, icon: Icon(Icons.delete))
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onEditPressed() async {
    final BasicLogger logger = BasicLogger();
    logger.info("Starting the image upload process");
    late FilePickerResult? result;
    try {
      result = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);
    } catch (e, s) {
      logger.error("Couldn't pick file", error: e, stackTrace: s);
      rethrow;
    }
    logger.debug("File picked (or not)");
    if (result == null) return;

    File file = File(result.files.single.path!);
    String extension = path.extension(file.path);
    logger.debug("File path: ${file.path}");
    try {
      await StorageService().uploadFromFile(
          file: file, path: "accounts/$account/dogs/$id/image$extension");
      logger.info("Dog pic uploaded to storage");
    } catch (e, s) {
      logger.error("Couldn't upload the dog image to storage",
          error: e, stackTrace: s);
    }
  }
}
