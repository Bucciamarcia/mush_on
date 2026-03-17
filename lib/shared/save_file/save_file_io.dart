import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:mush_on/services/error_handling.dart';

Future<bool> saveFileImpl({
  required String filename,
  required Uint8List bytes,
  required String fileExtension,
  String? mimeType,
}) async {
  final logger = BasicLogger();
  try {
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save file',
      fileName: filename,
      type: FileType.custom,
      allowedExtensions: [fileExtension],
      bytes: bytes,
    );
    return result != null;
  } catch (e, s) {
    logger.error("Couldn't save", error: e, stackTrace: s);
    return false;
  }
}
