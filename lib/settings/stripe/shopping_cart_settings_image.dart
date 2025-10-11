import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/settings/stripe/riverpod.dart';
import 'package:mush_on/settings/stripe/stripe_repository.dart';

class KennelImageCard extends ConsumerWidget {
  final Uint8List? image;
  final bool isLoading;
  const KennelImageCard({
    super.key,
    required this.image,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  ? const CircularProgressIndicator()
                  : (image != null)
                      ? Image.memory(image!, fit: BoxFit.cover)
                      : const Placeholder()),
          Column(
            children: [
              IconButton.outlined(
                  onPressed: () async {
                    final account = await ref.read(accountProvider.future);
                    try {
                      ref
                          .read(isLoadingKennelImageProvider.notifier)
                          .change(true);
                      _onEditPressed(account,
                          onChanged: (data) => ref
                              .read(kennelImageProvider.notifier)
                              .change(data));
                    } on FileSizeException catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(context, "Max file size is 10mb"));
                        logger.info("File uploaded is too large", error: e);
                      }
                    } on NoFileSelectedException catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(context, "No file selected"));
                        logger.info("No file selected", error: e);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(
                                context, "Error: couldn't upload file"));
                      }
                    } finally {
                      ref
                          .read(isLoadingKennelImageProvider.notifier)
                          .change(false);
                    }
                  },
                  icon: const Icon(Icons.edit)),
              IconButton.outlined(
                  onPressed: () async {
                    final account = await ref.read(accountProvider.future);
                    try {
                      ref
                          .read(isLoadingKennelImageProvider.notifier)
                          .change(true);
                      await StripeRepository(account: account)
                          .deleteKennelImage();
                      ref.read(kennelImageProvider.notifier).change(null);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(
                                context, "Couldn't delete the image"));
                      }
                    } finally {
                      ref
                          .read(isLoadingKennelImageProvider.notifier)
                          .change(false);
                    }
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onEditPressed(String account,
      {required Function(Uint8List) onChanged}) async {
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
    if (result == null) throw NoFileSelectedException("No file selected");
    if (result.files.first.size > 10485760) {
      logger.debug("File uploaded is above 10mb");
      logger.warning("File uploaded is too large");
      throw FileSizeException("File too large");
    }

    final finalFile = File(result.files.single.path!);
    try {
      await StripeRepository(account: account).saveKennelImage(finalFile);
      onChanged(finalFile.readAsBytesSync());
    } catch (e) {
      rethrow;
    }
  }
}

class FileSizeException implements Exception {
  final String message;
  FileSizeException(this.message);

  @override
  String toString() => 'FileSizeException: $message';
}

class NoFileSelectedException implements Exception {
  final String message;
  NoFileSelectedException(this.message);

  @override
  String toString() => 'NoFileSelectedException: $message';
}
