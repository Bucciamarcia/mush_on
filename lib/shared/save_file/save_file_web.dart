import 'dart:typed_data';

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

Future<bool> saveFileImpl({
  required String filename,
  required Uint8List bytes,
  required String fileExtension,
  String? mimeType,
}) async {
  try {
    final blob = html.Blob([bytes], mimeType ?? 'application/octet-stream');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = filename
      ..style.display = 'none';
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
    return true;
  } catch (_) {
    return false;
  }
}
