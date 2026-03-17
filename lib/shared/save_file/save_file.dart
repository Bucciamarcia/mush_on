import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

import 'save_file_web.dart' if (dart.library.io) 'save_file_io.dart' as impl;

/// Saves a file to disk when supported.
/// Returns true if a file was saved, false otherwise.
Future<bool> saveFileIfSupported({
  required String filename,
  required Uint8List bytes,
  required String fileExtension,
  String? mimeType,
}) async {
  final normalizedExtension = fileExtension.startsWith('.')
      ? fileExtension.substring(1)
      : fileExtension;
  final fullFilename = filename.endsWith('.$normalizedExtension')
      ? filename
      : '$filename.$normalizedExtension';
  if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
    return impl.saveFileImpl(
      filename: fullFilename,
      bytes: bytes,
      fileExtension: normalizedExtension,
      mimeType: mimeType,
    );
  }
  return false;
}

/// Saves a CSV file to disk when supported.
/// Returns true if a file was saved, false otherwise.
Future<bool> saveCsvIfSupported({
  required String filename,
  required String content,
}) async {
  return saveFileIfSupported(
    filename: filename,
    bytes: Uint8List.fromList(utf8.encode(content)),
    fileExtension: 'csv',
    mimeType: 'text/csv;charset=utf-8',
  );
}
