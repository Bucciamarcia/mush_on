import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/services/models/settings/settings.dart';

class SettingsProvider extends ChangeNotifier {
  BasicLogger logger = BasicLogger();
  late SettingsModel settings = SettingsModel();
  bool didSomethingChange = false;
  bool _isInitLoading = true;
  bool get isInitLoading => _isInitLoading;

  SettingsProvider() {
    _getSettings();
  }

  Future<void> _getSettings() async {
    FirestoreService firestore = FirestoreService();
    String account = await firestore.getUserAccount();
    String path = "accounts/$account/data/settings";
    try {
      Map<String, dynamic>? settingsJson = await firestore.getDocument(path);
      if (settingsJson == null) {
        settings = SettingsModel();
      } else {
        settings = SettingsModel.fromJson(settingsJson);
      }
    } catch (e, s) {
      logger.error("Couldn't get settings", error: e, stackTrace: s);
      settings = SettingsModel();
    } finally {
      _isInitLoading = false;
      notifyListeners();
    }
  }

  void addCustomField(CustomFieldTemplate newField) {
    List<CustomFieldTemplate> updatedList =
        List<CustomFieldTemplate>.from(settings.customFieldTemplates)
          ..add(newField);
    settings = settings.copyWith(customFieldTemplates: updatedList);
    didSomethingChange = true;
    notifyListeners();
  }

  void deleteCustomField(String toRemove) {
    List<CustomFieldTemplate> updatedList =
        List<CustomFieldTemplate>.from(settings.customFieldTemplates);
    updatedList.removeWhere((i) => i.id == toRemove);
    settings = settings.copyWith(customFieldTemplates: updatedList);
    didSomethingChange = true;
    notifyListeners();
  }

  Future<void> saveSettingsToDb() async {
    Map<String, dynamic> payload = settings.toJson();
    String account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/settings";
    try {
      await FirestoreService()
          .addDocToDb(payload: payload, path: path, merge: false);
    } catch (e, s) {
      logger.error(
          "Couldn't save settings to db. Path: $path\n\nPayload: $payload",
          error: e,
          stackTrace: s);
      rethrow;
    }
  }
}
