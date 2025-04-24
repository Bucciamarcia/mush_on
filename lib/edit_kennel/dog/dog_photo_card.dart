import 'dart:io';
import 'dart:typed_data';
import 'package:mush_on/services/error_handling.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/services/storage.dart';

class DogPhotoCard extends StatefulWidget {
  final String id;
  final String account;
  const DogPhotoCard(this.id, this.account, {super.key});

  @override
  State<DogPhotoCard> createState() => _DogPhotoCardState();
}

class _DogPhotoCardState extends State<DogPhotoCard> {
  Uint8List? image;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getImage();
  }

  Future<void> _getImage() async {
    Uint8List? newImage =
        await DogPhotoCardUtils(account: widget.account, id: widget.id)
            .getImage();
    setState(() {
      image = newImage;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    BasicLogger logger = BasicLogger();
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
              child: (isLoading)
                  ? CircularProgressIndicator()
                  : (image != null)
                      ? Image.memory(image!, fit: BoxFit.cover)
                      : Placeholder()),
          Column(
            children: [
              IconButton.outlined(
                  onPressed: () async {
                    try {
                      await _onEditPressed();
                    } on FileSizeException catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            ErrorSnackbar("Max file size is 10mb"));
                        logger.info("File uploaded is too large", error: e);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            ErrorSnackbar("Error: couldn't upload file"));
                      }
                    }
                  },
                  icon: Icon(Icons.edit)),
              IconButton.outlined(
                  onPressed: () async {
                    DogPhotoCardUtils utils = DogPhotoCardUtils(
                        account: widget.account, id: widget.id);
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      await utils.deleteCurrentImage();
                      setState(() {
                        image = null;
                      });
                    } catch (e, s) {
                      logger.error("Couldn't delete dog picture",
                          error: e, stackTrace: s);
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  icon: Icon(Icons.delete))
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
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
    logger.debug("File picked (or not)");
    if (result == null) return;
    if (result.files.first.size > 10485760) {
      logger.debug("File uploaded is above 10mb");
      setState(() {
        isLoading = false;
      });
      logger.warning("File uploaded is too large");
      throw FileSizeException("File too large");
    }

    File file = File(result.files.single.path!);
    String extension = path.extension(file.path);
    logger.debug("File path: ${file.path}");
    setState(() {
      isLoading = true;
    });
    try {
      await DogPhotoCardUtils(account: widget.account, id: widget.id)
          .deleteCurrentImage();
    } catch (e, s) {
      logger.error("Couldn't delete old image", error: e, stackTrace: s);
      setState(() {
        isLoading = false;
      });
    }
    try {
      await StorageService().uploadFromFile(
          file: file,
          path: "accounts/${widget.account}/dogs/${widget.id}/image$extension");
      logger.info("Dog pic uploaded to storage");
    } catch (e, s) {
      logger.error("Couldn't upload the dog image to storage",
          error: e, stackTrace: s);
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
    Uint8List? newImage;
    try {
      newImage = await DogPhotoCardUtils(account: widget.account, id: widget.id)
          .getImage();
    } catch (e, s) {
      logger.error("can't edit image", error: e, stackTrace: s);
      setState(() {
        isLoading = false;
      });
      rethrow;
    } finally {
      setState(() {
        image = newImage;
        isLoading = false;
      });
    }
  }
}

class DogPhotoCardUtils {
  final String id;
  final String account;
  BasicLogger logger = BasicLogger();

  DogPhotoCardUtils({required this.id, required this.account});

  /// Deletes the dog image
  Future<void> deleteCurrentImage() async {
    String? filename = await findImageFilename();
    if (filename == null) return;
    String path = "accounts/$account/dogs/$id/$filename";
    try {
      await StorageService().deleteFile(path);
      logger.debug("Dog image deleted successfully");
    } catch (e, s) {
      logger.error("Couldn't delete dog image", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Finds the image filename. Mostly to find its extension. Eg. "image.png".
  /// If the image isn't found, returns null.
  Future<String?> findImageFilename() async {
    late final List<String> filesInFolder;
    try {
      filesInFolder = await StorageService()
          .listFilesInFolder("accounts/$account/dogs/$id");
    } catch (e, s) {
      logger.error("Error while getting image file name",
          error: e, stackTrace: s);
      rethrow;
    }
    late final String? imagePath;
    try {
      imagePath =
          filesInFolder.firstWhere((element) => element.contains("image"));
    } catch (e) {
      logger.info("Couldn't find any image with the image path", error: e);
      imagePath = null;
    }
    return imagePath;
  }

  /// Finds and returns the image of the dog, or null if there is none.
  Future<Uint8List?> getImage() async {
    final String? imagePath = await findImageFilename();
    if (imagePath != null) {
      Uint8List? fileToGet;
      try {
        fileToGet = await StorageService()
            .getFile("accounts/$account/dogs/$id/$imagePath");
      } catch (e, s) {
        logger.error("Couldn't get image", error: e, stackTrace: s);
        rethrow;
      }
      return fileToGet;
    } else {
      return null;
    }
  }
}

class FileSizeException implements Exception {
  final String message;
  FileSizeException(this.message);

  @override
  String toString() => 'FileSizeException: $message';
}
