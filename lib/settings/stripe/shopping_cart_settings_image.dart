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
                    final notifier =
                        ref.read(kennelImageProvider(account: null).notifier);
                    try {
                      notifier.state = const AsyncValue.loading();
                      final newData = await _onEditPressed(account);
                      notifier.change(newData);
                    } on FileSizeException catch (e) {
                      notifier.state = AsyncValue.error(e, StackTrace.current);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(context, "Max file size is 10mb"));
                        logger.info("File uploaded is too large", error: e);
                      }
                    } on NoFileSelectedException catch (e) {
                      notifier.state = AsyncValue.error(e, StackTrace.current);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(context, "No file selected"));
                        logger.info("No file selected", error: e);
                      }
                    } catch (e, s) {
                      notifier.state = AsyncValue.error(e, s);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(
                                context, "Error: couldn't upload file"));
                      }
                    }
                  },
                  icon: const Icon(Icons.edit)),
              IconButton.outlined(
                  onPressed: () async {
                    final account = await ref.read(accountProvider.future);
                    final notifier =
                        ref.read(kennelImageProvider(account: null).notifier);
                    try {
                      notifier.state = const AsyncValue.loading();
                      await StripeRepository(account: account)
                          .deleteKennelImage();
                      notifier.change(null);
                    } catch (e, s) {
                      notifier.state = AsyncValue.error(e, s);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(
                                context, "Couldn't delete the image"));
                      }
                    }
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _onEditPressed(String account) async {
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
      return finalFile.readAsBytesSync();
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
