import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

import 'save_file_web.dart' if (dart.library.io) 'save_file_io.dart' as impl;

/// Saves a CSV file to disk when supported.
/// Returns true if a file was saved, false otherwise.
Future<bool> saveCsvIfSupported({
  required String filename,
  required String content,
}) async {
  // Only perform direct download on Web or Android as requested.
  if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
    return impl.saveCsvImpl(filename: filename, content: content);
  }
  return false;
}

