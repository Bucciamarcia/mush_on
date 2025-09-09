import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:mush_on/services/error_handling.dart';

Future<bool> saveCsvImpl({
  required String filename,
  required String content,
}) async {
  final logger = BasicLogger();
  try {
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save CSV',
      fileName: filename,
      type: FileType.custom,
      allowedExtensions: const ['csv'],
      bytes: Uint8List.fromList(utf8.encode(content)),
    );
    return result != null;
  } catch (e, s) {
    logger.error("Couldn't save", error: e, stackTrace: s);
    return false;
  }
}
