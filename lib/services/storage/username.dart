// Repository for things related to the UserName class
import 'dart:io';

import 'package:flutter/foundation.dart';

class UserNameRepository {
  /// Gets the bytes of the user avatar.
  static Future<Uint8List> getAvatar(String uid) async {
    return Uint8List(4);
  }

  static Future<void> writeAvatar(File file) async {}
}
